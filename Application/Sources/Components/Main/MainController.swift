import Reactant

import RealmSwift
import RxRealm
import RxSwift

enum ScanButton : String {
    case Start = "Start"
    case Stop = "Stop"
}

final class MainController: ControllerBase<Void, MainRootView> {

    struct Dependencies {
        let verifoneDetectorService: VeriFoneDetectorService
        let dataService: DataService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.dependencies.verifoneDetectorService.dataService = self.dependencies.dataService
        super.init(title: "VeriFone Detector") // setting the title of our main page
    }
    
    override func afterInit() {
        
        // Initialize the ComponentState of the RootView
        self.rootView.componentState = (devices: [], progress: 0.0)
        
        // Add button for starting a scan
        let rightBarButtonItem = UIBarButtonItem(title: ScanButton.Start.rawValue, style: .plain) { [unowned self, dependencies] in
            
            guard let buttonItem = self.navigationItem.rightBarButtonItem, let text = buttonItem.title else {
                print("returning")
                return
            }
            
            if text == ScanButton.Stop.rawValue {
                buttonItem.title = ScanButton.Start.rawValue
                dependencies.verifoneDetectorService.stopDetection()
            } else {
                buttonItem.title = ScanButton.Stop.rawValue
                dependencies.verifoneDetectorService.startDetection()
            }
            
            self.invalidate()
        }
        
        // A button used to show a percentage; hacky
        let progressBarButtonItem = UIBarButtonItem(title: "", style: .done)
        progressBarButtonItem.isEnabled = false
        
        navigationItem.setRightBarButtonItems([rightBarButtonItem, progressBarButtonItem], animated: true)
        //navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain) { [unowned self, dependencies] in
            dependencies.dataService.clear()
            self.invalidate()
        }
    }
    
    override func update() {
        
        // Register Realm as data source; react to collection changes through RxRealm
        let realm = try! Realm()
        let devices = realm.objects(Device.self)
        
        let _ = Observable.array(from: devices)
            .subscribe(onNext: { devices  in
                self.rootView.componentState.devices = devices
            })
        
        // Hacky way to update the percentage of the scan by abusing BarButtonItem
        let _ = dependencies.verifoneDetectorService.progress.asObservable()
            .subscribe({ progress in
                guard let newValue : Float = progress.element else {
                    return
                }
                
                self.rootView.componentState.progress = newValue
                
                // NOTE: below is code that updates percentage; hacky :)
                // TODO: look into possibilities to improve this within the component?
                var updatedString : String
                if newValue == 1.0 || newValue == 0.0 {
                    updatedString = ""
                } else {
                    updatedString = String(format: "%.0f", newValue * 100) + "%"
                }
                
                guard let item : UIBarButtonItem = self.navigationItem.rightBarButtonItems?[1] else {
                    return
                }
                item.title = updatedString
                
                
                // Reset the ScanButton to Start after we're done
                if newValue == 1.0 {
                    guard let item : UIBarButtonItem = self.navigationItem.rightBarButtonItems?[0] else {
                        return
                    }
                    item.title = ScanButton.Start.rawValue
                }
            
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        invalidate()
        super.viewWillAppear(animated)
    }
    
}

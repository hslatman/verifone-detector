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
                self.rootView.componentState = devices
            })
        
        // Hacky way to update the percentage of the scan by abusing BarButtonItem
        let _ = dependencies.verifoneDetectorService.progress.asObservable()
            .subscribe({ progress in
                let item : UIBarButtonItem = self.navigationItem.rightBarButtonItems![1]
                guard let newValue : Float = progress.element else {
                    return
                }
                
                var updatedString : String
                if newValue == 100.0 || newValue == 0.0 {
                    updatedString = ""
                } else {
                    updatedString = String(format: "%.0f", newValue) + "%"
                }
                
                if newValue == 100.0 {
                    self.navigationItem.rightBarButtonItems![0].title = ScanButton.Start.rawValue
                }
                
                item.title = updatedString
            })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        invalidate()
        super.viewWillAppear(animated)
    }
    
}

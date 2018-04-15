import Reactant

import RealmSwift
import RxRealm
import RxSwift

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain) { [unowned self, dependencies] in
            
            guard let buttonItem = self.navigationItem.rightBarButtonItem, let text = buttonItem.title else {
                print("returning")
                return
            }
            
            if text == "Start" {
                dependencies.verifoneDetectorService.startDetection()
                buttonItem.title = "Stop"
            } else {
                dependencies.verifoneDetectorService.stopDetection()
                buttonItem.title = "Start"
            }
            
            
            self.invalidate()
        }
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
    }
    
    func didDetectNewDevice() {
        self.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        invalidate()
        super.viewWillAppear(animated)
    }
    
}

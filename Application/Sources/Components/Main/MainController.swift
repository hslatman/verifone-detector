import Reactant

import RealmSwift
import RxRealm
import RxSwift

final class MainController: ControllerBase<Void, MainRootView>,VerifoneDetectorDelegate {

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
            dependencies.verifoneDetectorService.startDetection()
            self.invalidate()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain) { [unowned self, dependencies] in
            dependencies.dataService.clear()
            self.invalidate()
        }
    }
    
    override func update() {        
        dependencies.verifoneDetectorService.detectedDevices.asObservable()
            .subscribe(onNext: { [unowned self] devices in
                self.rootView.componentState = devices
            })
            .disposed(by: lifetimeDisposeBag)
        }
    
    func didDetectNewDevice() {
        self.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        invalidate()
        super.viewWillAppear(animated)
    }
    
}

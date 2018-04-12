import Reactant

final class MainController: ControllerBase<Void, MainRootView> {
    
    struct Dependencies {
        let verifoneDetectorService: VeriFoneDetectorService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(title: "VeriFone Detector") // setting the title of our main page
    }
    
//    override func afterInit() {
//        let devices = [
//            Device(ip: "192.168.1.10", isVerifone: true),
//            Device(ip: "192.168.1.20", isVerifone: false)
//        ]
//        rootView.componentState = devices
//    }
    
    override func update() {
        do {
            rootView.componentState = try dependencies.verifoneDetectorService.loadDevices()
        } catch let error {
            print("Failed to load devices:", error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        invalidate()
        super.viewWillAppear(animated)
    }

}

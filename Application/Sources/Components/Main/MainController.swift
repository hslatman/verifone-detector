import Reactant

final class MainController: ControllerBase<Void, MainRootView> {
    
    override init() {
        super.init(title: "VeriFone Detector") // setting the title of our main page
    }
    
    override func afterInit() {
        let devices = [
            Device(ip: "192.168.1.10", isVerifone: true),
            Device(ip: "192.168.1.20", isVerifone: false)
        ]
        rootView.componentState = devices
    }

}

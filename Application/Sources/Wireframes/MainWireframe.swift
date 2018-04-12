import UIKit
import Reactant

final class MainWireframe: Wireframe {
    private let module: DependencyModule

    init(module: DependencyModule) {
        self.module = module
    }

    func entrypoint() -> UIViewController {
        let mainController = main()
        return UINavigationController(rootViewController: mainController)
    }

    private func main() -> MainController {
        let dependencies = MainController.Dependencies(verifoneDetectorService: module.verifoneDetectorService)
        return create { provider in
            return MainController(dependencies: dependencies)
        }
    }
}

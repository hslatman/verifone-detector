import UIKit
import Reactant
import RealmSwift

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?

    private let module = ApplicationModule()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        
        var configuration : Realm.Configuration = Realm.Configuration.defaultConfiguration
        configuration.deleteRealmIfMigrationNeeded = true
        
        Realm.Configuration.defaultConfiguration = configuration
        
        Configuration.global.set(Properties.Style.controllerRoot, to: GeneralStyles.controllerRootView)

        let window = UIWindow()
        let wireframe = MainWireframe(module: module)
        window.rootViewController = wireframe.entrypoint()
        window.makeKeyAndVisible()
        self.window = window
        activateLiveReload(in: window)
        return true
    }
}


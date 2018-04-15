import Reactant
import RxSwift
import RealmSwift
import RxRealmDataSources

final class MainRootView: ViewBase<[Device], PlainTableViewAction<DeviceCell>> {

    let deviceTableView = PlainTableView<DeviceCell>(reloadable: false)
    
    // TODO: find out how to add a UIProgressView (correctly)
    
    override var actions: [Observable<PlainTableViewAction<DeviceCell>>] {
        return [deviceTableView.action]
    }
    
    override func update() {
        deviceTableView.componentState = componentState.isEmpty ? .empty(message: "No devices scanned so far!") : .items(componentState)
    }
    
    override func loadView() {
        deviceTableView.footerView = UIView() // this is so that cell dividers end after the last cell
        deviceTableView.rowHeight = DeviceCell.height
        deviceTableView.separatorStyle = .singleLine
        deviceTableView.tableView.contentInset.bottom = 0
    }
    
}

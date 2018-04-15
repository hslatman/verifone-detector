import Reactant
import RxSwift
import RealmSwift
import RxRealmDataSources

final class MainRootView: ViewBase<[Device], PlainTableViewAction<DeviceCell>> {

    let deviceTableView = PlainTableView<DeviceCell>(reloadable: false)
    
    // create data source
//    let dataSource = RxTableViewRealmDataSource<Device>(
//    cellIdentifier: "DeviceCell", cellType: DeviceCell.self) {cell, ip, lap in
//        //cell. = "\(ip.row). \(lap.text)"
//    }
    
    override var actions: [Observable<PlainTableViewAction<DeviceCell>>] {
        return [deviceTableView.action]
    }
    
    override func update() {
        deviceTableView.componentState = componentState.isEmpty ? .empty(message: "No devices so far!") : .items(componentState)
        // create data source
//        let dataSource = RxTableViewRealmDataSource<Device>(cellIdentifier: "Cell", cellType: DeviceCell.self) {cell, ip, lap in
//            cell.customLabel.text = "\(ip.row). \(lap.text)"
//        }
//
//        let realm = try! Realm()
//
//        let devices = Observable.changeset(from: componentState)
//
//        devices
//            .bindTo(deviceTableView.rx.realmChanges(dataSource))
//            .addDisposableTo(bag)
    }
    

    
    // RxRealm to get Observable<Results>
//    let realm = try! Realm()
//    let lapsList = realm.objects(Timer.self).first!.laps
//    let laps = Observable.changeset(from: lapsList)
//
    // bind to table view
//    laps
//    .bindTo(tableView.rx.realmChanges(dataSource))
//    .addDisposableTo(bag)
    
    override func loadView() {
        deviceTableView.footerView = UIView() // this is so that cell dividers end after the last cell
        deviceTableView.rowHeight = DeviceCell.height
        deviceTableView.separatorStyle = .singleLine
        deviceTableView.tableView.contentInset.bottom = 0
    }
    
}

import Reactant
import RxSwift
import RealmSwift
import RxRealmDataSources

final class MainRootView: ViewBase<(devices: [Device], progress: Float), PlainTableViewAction<DeviceCell>> {

    let deviceTableView = PlainTableView<DeviceCell>(reloadable: false)
    
    let progressView = UIProgressView()
    
    override var actions: [Observable<PlainTableViewAction<DeviceCell>>] {
        return [deviceTableView.action]
    }
    
    override func update() {
        updateProgressView()
        deviceTableView.componentState = componentState.devices.isEmpty ? .empty(message: "No devices scanned so far!") : .items(componentState.devices)
    }
    
    override func loadView() {
        deviceTableView.footerView = UIView() // this is so that cell dividers end after the last cell
        deviceTableView.rowHeight = DeviceCell.height
        deviceTableView.separatorStyle = .singleLine
        deviceTableView.tableView.contentInset.bottom = 0
        
        progressView.progressViewStyle = .bar
    }
    
    func updateProgressView() {
        let progress = componentState.progress
        if progress == 1.0 || progress == 0.0 {
            progressView.isHidden = true
            progressView.setProgress(0.0, animated: false)
        } else {
            progressView.setProgress(componentState.progress, animated: true)
            progressView.isHidden = false
        }
        
    }
    
}

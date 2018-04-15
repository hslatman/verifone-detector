//
//  VeriFoneDetectorService.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 12/04/2018.
//

import Foundation

import RxSwift
import RxCocoa
import MMLanScan


protocol VerifoneDetectorDelegate {
    func didDetectNewDevice()
}

class VeriFoneDetectorService : NSObject, NetworkScannerDelegate {
    
    var scanner : NetworkScanner!
    var recognizer : VerifoneRecognizer!
    
    var detectedDevices : BehaviorRelay<[Device]> = BehaviorRelay(value: [])//Results<Device>?
    
    var delegate : VerifoneDetectorDelegate?
    
    var dataService : DataService?
    
    override init() {

        super.init()

        self.scanner = NetworkScanner(delegate: self) //NetworkScannerRunner(delegate: self)
        self.recognizer = VerifoneRecognizer()
        
    }
    
    func startDetection() {
        print("starting scan")
        self.scanner.startScan()
    }
    
    
    func networkScannerIPSearchFinished() {
        print("ping finished")
    }
    
    func networkScannerDidFindNewDevice(device: MMDevice) {
        print("new device: \(device.ipAddress)")
        
        let deviceModel = Device()
        deviceModel.ip = device.ipAddress
        
        self.dataService?.add(deviceModel)
        
        // Perform check for existing IPs
//        let ips : [IPAddress] = detectedDevices.value.map { detectedDevice in
//            detectedDevice.ip
//        }
//
//        if !ips.contains(device.ip) {
//            // Note: it looks a bit ugly; is this the way to go?
//            // https://github.com/ReactiveX/RxSwift/issues/1501#issuecomment-349562384
//            self.detectedDevices.accept(self.detectedDevices.value + [device])
//        }
        
        
        
//        let ip = device.ip
//        let predicate = NSPredicate(format: "%K = %@", "ip", ip)
//        if detectedDevices.filter(predicate).count == 0 {
//            // Query and update from any thread
//            DispatchQueue.global(qos: .background).async {
//                autoreleasepool {
//                    let realm = try! Realm()
//                    try! realm.write {
//                        realm.add(device)
//                    }
//                }
//            }
//        }
        
        // No matter what happens; we'll always perform the port scan on the IP
        self.performVeriFoneRecognition(ip: device.ipAddress)
    }
    
    func networkScannerIPSearchCancelled() {
        print("ping cancelled")
    }
    
    func networkScannerIPSearchFailed() {
        print("ping failed")
    }
    
    func networkScannerIPSearchStarted() {
        print("ping started")
    }
    
    func performVeriFoneRecognition(ip: IPAddress) {

        DispatchQueue.global(qos: .background).async {
            let isVerifone = self.recognizer.check(ip: ip)
            print("is verifone: \(isVerifone)")
            
//            // Update the item
//            for detectedDevice : Device in self.detectedDevices.value {
//                if ip == detectedDevice.ip {
//                    detectedDevice.isVerifone = isVerifone
//                    self.delegate?.didDetectNewDevice()
//                }
//            }
            self.dataService?.update(ip: ip, isVerifone: isVerifone)
        }
    }
}

//
//  VeriFoneDetectorService.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 12/04/2018.
//

import Foundation

import RxSwift

protocol VerifoneDetectorDelegate {
    func didDetectNewDevice()
}

class VeriFoneDetectorService : NSObject, NetworkScannerDelegate {

    //let chocolates: Variable<[Chocolate]> = Variable([])
    
    var scanner : NetworkScanner!
    var recognizer : VerifoneRecognizer!
    
    var detectedDevices : Variable<[Device]> = Variable([])//Results<Device>?
    
    var delegate : VerifoneDetectorDelegate?
    
    override init() {

        super.init()
        
        //self.detectedDevices = realm.objects(Device.self)

        self.scanner = NetworkScanner(delegate: self) //NetworkScannerRunner(delegate: self)
        self.recognizer = VerifoneRecognizer()
        

    }
    
    func startDetection() {
        print("starting scan")
        self.scanner.startScan()
    }
    
    
    func networkScannerIPSearchFinished() {
        print("ping finished")
        
//        let result = self.scanner.retrieveResult()
        
//        for ip : IPAddress in result {
//            let isVerifone = self.recognizer.check(ip: ip)
//            let device = Device(ip: ip, isVerifone: isVerifone)
//            self.detectedDevices.append(device)
//            self.delegate?.didDetectNewDevice()
//            print("added detected device")
//        }
    }
    
    func networkScannerDidFindNewDevice(device: Device) {
        print("new device: \(device.ip)")
        
        // Perform check for existing IPs
        let ips : [IPAddress] = detectedDevices.value.map { detectedDevice in
            detectedDevice.ip
        }

        if !ips.contains(device.ip) {
            self.detectedDevices.value.append(device)
        }
        
        //if 1detectedDevices.contains(
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
        
//        let ip = device.ip
//        if !detectedDevices.value.keys.contains(ip) {
//            self.detectedDevices.value[ip] = device
//        }
        
        
        // No matter what happens; we'll always perform the port scan on the IP
        self.performVeriFoneRecognition(ip: device.ip)
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
            
            // Update the item, if necessary
            //if isVerifone {
            for detectedDevice : Device in self.detectedDevices.value {
                if ip == detectedDevice.ip {
                    detectedDevice.isVerifone = isVerifone
                    self.delegate?.didDetectNewDevice()
                }
            }
            //}
        }
    }
    
//    func devices() -> Observable<[Device]> {
//
////        let devices = [
////            Device(ip: "192.168.1.10", isVerifone: true),
////            Device(ip: "192.168.1.20", isVerifone: false)
////        ]
////        return Observable.create { observer in
////            for element in self.detectedDevices {
////                observer.on(.next(element))
////            }
////
////            observer.on(.completed)
////            return Disposables.create()
////        }
//
//
//        //return detectedDevices.value
//    }
    
    //    func networkScannerDidFindNewDevice(device: MMDevice) {
    //        var newDevice = DeviceModel(ip: device.ipAddress, )
    //    }
    
}

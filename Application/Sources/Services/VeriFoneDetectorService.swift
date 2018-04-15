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

class VeriFoneDetectorService : NSObject, NetworkScannerDelegate {
    
    var scanner : NetworkScanner!
    var recognizer : VerifoneRecognizer!
    
    var progress: BehaviorRelay<Float> = BehaviorRelay(value: 0.0)
    
    var dataService : DataService?
    
    override init() {

        super.init()

        self.scanner = NetworkScanner(delegate: self)
        self.recognizer = VerifoneRecognizer()
        
    }
    
    func startDetection() {
        print("starting scan")
        self.scanner.startScan()
    }
    
    func stopDetection() {
        print("stopping scan")
        self.scanner.stopScan()
    }
    
    func networkScannerDidFindNewDevice(device: MMDevice) {
        // Extract fields from MMDevice
        let deviceModel = Device()
        deviceModel.ip = device.ipAddress
        
        // Store the new device and check whether it's a VeriFone device
        self.dataService?.add(deviceModel)
        self.performVeriFoneRecognition(ip: device.ipAddress)
    }
    
    func networkScannerIPSearchCancelled() {
        print("ping cancelled")
        self.progress.accept(100.0)
    }
    
    func networkScannerIPSearchFailed() {
        print("ping failed")
        self.progress.accept(100.0)
    }
    
    func networkScannerIPSearchStarted() {
        print("ping started")
        self.progress.accept(0.0)
    }
    
    func networkScannerIPSearchFinished() {
        print("ping finished")
        self.progress.accept(100.0)
    }
    
    func networkScannerProgressPinged(progress: Float) {
        print("progress: \(progress)")
        self.progress.accept(progress)
    }
    
    func performVeriFoneRecognition(ip: IPAddress) {
        DispatchQueue.global(qos: .background).async {
            let isVerifone = self.recognizer.check(ip: ip)
            self.dataService?.update(ip: ip, isVerifone: isVerifone)
        }
    }
}

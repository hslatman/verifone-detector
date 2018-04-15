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
    
    
    func networkScannerIPSearchFinished() {
        print("ping finished")
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
            self.dataService?.update(ip: ip, isVerifone: isVerifone)
        }
    }
}

//
//  VeriFoneDetectorService.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 12/04/2018.
//

import Foundation

protocol VerifoneDetectorDelegate {
    func didDetectNewDevice()
}

class VeriFoneDetectorService : NSObject, NetworkScannerDelegate {
    
    var scanner : NetworkScanner!
    var recognizer : VerifoneRecognizer!
    
    var detectedDevices : [Device]!
    
    var delegate : VerifoneDetectorDelegate?
    
    override init() {
        super.init()
        self.detectedDevices = []
        self.scanner = NetworkScanner(delegate: self) //NetworkScannerRunner(delegate: self)
        self.recognizer = VerifoneRecognizer()
    }
    
    func startDetection() {
        //self.runner.startScanner()
        self.scanner.startScan()
    }
    
    
    func networkScannerIPSearchFinished() {
        print("ping finished")
        
        let result = self.scanner.retrieveResult()
        
        for ip : IPAddress in result {
            let isVerifone = self.recognizer.check(ip: ip)
            let device = Device(ip: ip, isVerifone: isVerifone)
            self.detectedDevices.append(device)
            self.delegate?.didDetectNewDevice()
            print("added detected device")
        }
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
    
    func loadDevices() -> [Device] {
        return []
    }
    
    //    func networkScannerDidFindNewDevice(device: MMDevice) {
    //        var newDevice = DeviceModel(ip: device.ipAddress, )
    //    }
    
}

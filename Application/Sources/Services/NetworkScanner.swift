//
//  NetworkScannerService.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 12/04/2018.
//

import Foundation

import MMLanScan

typealias IPAddress = String

protocol NetworkScannerDelegate {
    func networkScannerIPSearchFinished()
    func networkScannerIPSearchCancelled()
    func networkScannerIPSearchFailed()
    func networkScannerIPSearchStarted()
    func networkScannerDidFindNewDevice(device: Device)
}

class NetworkScanner : NSObject, MMLANScannerDelegate {
    
    var lanScanner : MMLANScanner!
    var delegate : NetworkScannerDelegate?
    
    @objc dynamic var scannedDevices : [MMDevice]!
    @objc dynamic var progressValue : Float = 0.0
    @objc dynamic var isScanRunning : BooleanLiteralType = false
    @objc dynamic var isComplete : BooleanLiteralType = false
    
    //var delegate
    
    init(delegate : NetworkScannerDelegate) {
        super.init()
        self.delegate = delegate
        self.scannedDevices = [MMDevice]()
        self.isScanRunning = false
        self.lanScanner = MMLANScanner(delegate: self)
    }
    
    func startScan() -> Void {
        self.delegate?.networkScannerIPSearchStarted()
        self.scannedDevices.removeAll()
        self.isScanRunning = true
        self.lanScanner.start()
    }
    
    func stopScan() -> Void {
        self.lanScanner.stop()
        self.isScanRunning = false
        self.delegate?.networkScannerIPSearchCancelled()
    }
 
    func retrieveResult() -> [IPAddress] {
        
        var result : [String] = []
        scannedDevices.forEach({ (device: MMDevice) in
            result.append(device.ipAddress)
        })
        
        return result
    }
    
    func lanScanProgressPinged(_ pingedHosts: Float, from overallHosts: Int) {
        self.progressValue = pingedHosts / Float(overallHosts)
    }
    
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        if(!self.scannedDevices.contains(device)) {
            self.scannedDevices.append(device)
            print("\(device): \(device.ipAddress)")
            
            let deviceModel = Device() //Device(ip: device.ipAddress, isVerifone: false)
            deviceModel.ip = device.ipAddress
            deviceModel.isVerifone = false
            self.delegate?.networkScannerDidFindNewDevice(device: deviceModel)
        }
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        self.isScanRunning = false
        self.isComplete = true
        self.delegate?.networkScannerIPSearchFinished()
    }
    
    func lanScanDidFailedToScan() {
        self.isScanRunning = false
        self.delegate?.networkScannerIPSearchFailed()
    }
    
}

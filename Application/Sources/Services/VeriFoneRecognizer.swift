//
//  VerifoneRecognizer.swift
//  trial-verifone-detector
//
//  Created by Herman Slatman on 31/03/2018.
//  Copyright © 2018 Herman Slatman. All rights reserved.
//

import Foundation
import SwiftSocket

class VerifoneRecognizer {
    
    func check(ip: String, signaturePorts: [Int] = [4100, 4101, 4104], timeout: Int = 2) -> Bool {
        
        var allPortsConnectedSuccessfully = true
        
        for port in signaturePorts where allPortsConnectedSuccessfully {
            let newClient = TCPClient(address: ip, port: Int32(port))
            switch newClient.connect(timeout: timeout) {
            case .success:
                break
            case .failure(let error):
                print(error)
                allPortsConnectedSuccessfully = false
            }
        }
        
        return allPortsConnectedSuccessfully
    }
    
    func check(ips: [String],
               signaturePorts : [Int] = [4100, 4101, 4104],
               timeout : Int = 2) -> [String:Bool] {
        
        var result : [String:Bool] = [:]
        for ip in ips {
            result[ip] = self.check(ip: ip, signaturePorts: signaturePorts, timeout: timeout)
        }
        
        return result
    }
    
    func check(dictionaryOfIps: [Int:String],
               signaturePorts : [Int] = [4100, 4101, 4104],
               timeout : Int = 2) -> [Int:Bool] {
        
        var result : [Int:Bool] = [:]
        for (id, ip) in dictionaryOfIps {
            result[id] = self.check(ip: ip, signaturePorts: signaturePorts, timeout: timeout)
        }
        
        return result
    }
    
}

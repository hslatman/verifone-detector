//
//  VerifoneEmulator.swift
//  trial-verifone-detector
//
//  Created by Herman Slatman on 01/04/2018.
//  Copyright © 2018 Herman Slatman. All rights reserved.
//

import Foundation
import SwiftSocket

class VerifoneEmulator {
    
    let server4100 : TCPServer!
    let server4101 : TCPServer!
    let server4104 : TCPServer!
    
    var shouldAcceptConnections = true
    
    var connectedClients : SynchronizedArray<TCPClient> = SynchronizedArray<TCPClient>()
    
    init(ip: String) {
        self.server4100 = TCPServer(address: ip, port: 4100)
        self.server4101 = TCPServer(address: ip, port: 4101)
        self.server4104 = TCPServer(address: ip, port: 4104)
    }
    
    func stop() {
        shouldAcceptConnections = false
        
        connectedClients.forEach({ (client: TCPClient) -> Void  in
            client.close()
        })
        
        self.server4100.close()
        self.server4101.close()
        self.server4104.close()
    }
    
    func start() {
        
        DispatchQueue.global(qos: .background).async {
            switch self.server4100.listen() {
            case .success:
                while self.shouldAcceptConnections {
                    if let client = self.server4100.accept() {
                        print("client connected")
                        self.connectedClients.append(client)
                    } else {
                        print("accept error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            switch self.server4101.listen() {
            case .success:
                while self.shouldAcceptConnections {
                    if let client = self.server4101.accept() {
                        print("client connected")
                        self.connectedClients.append(client)
                    } else {
                        print("accept error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            switch self.server4104.listen() {
            case .success:
                while self.shouldAcceptConnections {
                    if let client = self.server4104.accept() {
                        print("client connected")
                        self.connectedClients.append(client)
                    } else {
                        print("accept error")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

//
//  NetworkUtilities.swift
//  trial-verifone-detector
//
//  Created by Herman Slatman on 02/04/2018.
//  Copyright © 2018 Herman Slatman. All rights reserved.
//

import Foundation

func getIPAddress() -> String? {
    
    var ipAddress : String? = nil
    
    let ipaddresses = NetInfo.getIFAddresses()
    if let netInfo = ipaddresses.filter({$0.name == "en0"}).first {
        ipAddress = netInfo.ip
    }
    else if let netInfo = ipaddresses.filter({$0.name == "en1"}).first  {
        ipAddress = netInfo.ip
    }
    else if let netInfo = ipaddresses.filter({$0.name == "en2"}).first  {
        ipAddress = netInfo.ip
    }
    
    return ipAddress
}

func getNetMask() -> String? {
    var netmask : String? = nil
    
    let ipaddresses = NetInfo.getIFAddresses()
    if let netInfo = ipaddresses.filter({$0.name == "en0"}).first {
        netmask = netInfo.netmask
    }
    else if let netInfo = ipaddresses.filter({$0.name == "en1"}).first  {
        netmask = netInfo.netmask
    }
    else if let netInfo = ipaddresses.filter({$0.name == "en2"}).first  {
        netmask = netInfo.netmask
    }
    
    return netmask
}

func getNetwork() -> String? {
    var network : String? = nil
    
    let ipaddresses = NetInfo.getIFAddresses()
    if let netInfo = ipaddresses.filter({$0.name == "en0"}).first {
        network = netInfo.network
    }
    else if let netInfo = ipaddresses.filter({$0.name == "en1"}).first  {
        network = netInfo.network
    }
    else if let netInfo = ipaddresses.filter({$0.name == "en2"}).first  {
        network = netInfo.network
    }
    
    return network
}

struct NetInfo {
    
    // Source: https://stackoverflow.com/questions/29845182/how-to-get-local-and-subnet-mask-ip-address-in-swift/30261777
    
    let ip: String
    let name: String
    let netmask: String
    
    // Get the local ip addresses used by this node
    static func getIFAddresses() -> [NetInfo] {
        var addresses = [NetInfo]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr;
            while ptr != nil {
                
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                var addr = ptr?.pointee.ifa_addr.pointee
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.init(validatingUTF8:hostname),
                                let ifaName = ptr?.pointee.ifa_name{
                                
                                var net = ptr?.pointee.ifa_netmask.pointee
                                let name = String(cString: ifaName)
                                var netmaskName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                                getnameinfo(&net!, socklen_t((net?.sa_len)!), &netmaskName, socklen_t(netmaskName.count),
                                            nil, socklen_t(0), NI_NUMERICHOST)// == 0
                                if let netmask = String.init(validatingUTF8:netmaskName) {
                                    addresses.append(NetInfo(ip: address, name: name, netmask: netmask))
                                }
                            }
                        }
                    }
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
    // Network Address
    var network: String {
        return bitwise(op: &, net1: ip, net2: netmask)
    }
    
    // Broadcast Address
    var broadcast: String {
        let inverted_netmask = bitwise(op: ~, net1: netmask)
        let broadcast = bitwise(op: |, net1: network, net2: inverted_netmask)
        return broadcast
    }
    
    // CIDR: Classless Inter-Domain Routing
    var cidr: Int {
        var cidr = 0
        for number in binaryRepresentation(s: netmask) {
            let numberOfOnes = number.split(separator: "1").count - 1//number.componentsSeparatedByString("1").count - 1
            cidr += numberOfOnes
        }
        return cidr
    }
    
    private func binaryRepresentation(s: String) -> [String] {
        var result: [String] = []
        for numbers in (s.split(separator: ".")) {
            if let intNumber = Int(numbers) {
                if let binary = Int(String(intNumber, radix: 2)) {
                    result.append(NSString(format: "%08d", binary) as String)
                }
            }
        }
        return result
    }
    
    private func bitwise(op: (UInt8,UInt8) -> UInt8, net1: String, net2: String) -> String {
        let net1numbers = toInts(networkString: net1)
        let net2numbers = toInts(networkString: net2)
        var result = ""
        for i in 0..<net1numbers.count {
            result += "\(op(net1numbers[i],net2numbers[i]))"
            if i < (net1numbers.count-1) {
                result += "."
            }
        }
        return result
    }
    
    private func bitwise(op: (UInt8) -> UInt8, net1: String) -> String {
        let net1numbers = toInts(networkString: net1)
        var result = ""
        for i in 0..<net1numbers.count {
            result += "\(op(net1numbers[i]))"
            if i < (net1numbers.count-1) {
                result += "."
            }
        }
        return result
    }
    
    private func toInts(networkString: String) -> [UInt8] {
        return (networkString.split(separator: ".")).map{UInt8($0)!}
    }
}



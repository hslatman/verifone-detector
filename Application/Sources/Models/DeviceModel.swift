//
//  DeviceModel.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 12/04/2018.
//

import Foundation

import RealmSwift

typealias IPAddress = String

class Device : Object {
    @objc dynamic var ip : IPAddress = ""
    @objc dynamic var isVerifone : Bool = false
    
    override static func primaryKey() -> String? {
        return "ip"
    }

}

//
//  DataService.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 15/04/2018.
//

import Foundation

import RealmSwift

class DataService {
    
    func add(_ device: Device) {
        DispatchQueue(label: "realm").async {
            print("adding: \(device)")
            let realm = try! Realm()
            try! realm.write {
                realm.add(device, update: true)
            }
        }
    }
    
    func update(ip: IPAddress, isVerifone: Bool) {
        DispatchQueue(label: "realm").async {
            autoreleasepool {
                print("updating: \(ip)")
                let realm = try! Realm()
                guard let device = realm.object(ofType: Device.self, forPrimaryKey: ip) else {
                    return
                }
                try! realm.write {
                    device.isVerifone = isVerifone
                    realm.add(device, update: true)
                }
            }
        }
    }
    
    func clear() {
        DispatchQueue(label: "realm").async {
            autoreleasepool {
                let realm = try! Realm()
                let count = realm.objects(Device.self).count
                print("clearing \(count) device(s)")
                try! realm.write {
                    realm.delete(realm.objects(Device.self))
                }
            }
        }
    }
    
}

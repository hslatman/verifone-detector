//
//  DeviceCell.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 12/04/2018.
//

import UIKit
import Reactant

final class DeviceCell: ViewBase<Device, Void> {
    static let height: CGFloat = 80
    
    let ip = UILabel()
    let isVerifone = UILabel()
    
    override func update() {
        ip.text = componentState.ip
        isVerifone.text = componentState.isVerifone ? "YES" : "NO"
    }
    
}

//
//  DeviceCell.swift
//  VeriFone Detector
//
//  Created by Herman Slatman on 12/04/2018.
//

import UIKit
import Reactant

final class DeviceCell: ViewBase<Device, Void>, Reactant.TableViewCell {
    static let height: CGFloat = 60
    
    let ip = UILabel()
    let isVerifone = UILabel()
    
    override func update() {
        ip.text = componentState.ip
        isVerifone.text = componentState.isVerifone ? "\u{2713}" : "-"
    }
    
    func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let style = { self.apply(style: highlighted ? Styles.highlightedBackground : Styles.normalBackground) }
        if animated {
            UIView.animate(withDuration: 0.7, animations: style)
        } else {
            style()
        }
    }
    
}

extension DeviceCell.Styles {
    static func normalBackground(_ cell: DeviceCell) {
        cell.backgroundColor = nil
    }
    
    static func highlightedBackground(_ cell: DeviceCell) {
        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    }
}

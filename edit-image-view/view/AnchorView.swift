//
//  AnchorView.swift
//  basho.store
//
//  Created by idt on 2020/11/17.
//  Copyright © 2020 Imagedt. All rights reserved.
//

import Foundation
import UIKit

class AnchorView: UIView {
    static let LOCATION_TOP_LEFT = "location_top_left"
    static let LOCATION_TOP_RIGHT = "location_top_right"
    static let LOCATION_TOP_MID = "location_top_mid"
    static let LOCATION_LEFT_MID = "location_left_mid"
    static let LOCATION_RIGHT_MID = "location_right_mid"
    static let LOCATION_BOTTOM_LEFT = "location_bottom_left"
    static let LOCATION_BOTTOM_RIGHT = "location_bottom_right"
    static let LOCATION_BOTTOM_MID = "location_bottom_mid"
    static let LOCATION_CENTER = "location_center"
    static let LOCATION_NONE = "location_none"

    let type: String

    var padding: CGFloat = CGFloat.init(UIScreen.main.scale * 5) {
        didSet {
            updateBackgroupLayer()
        }
    }
    
    var anchorBackgroundColor: UIColor = UIColor.clear {
        didSet {
            backgroundLayer.fillColor = anchorBackgroundColor.cgColor
        }
    }
    
    private let backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        return layer
    }()

    override var frame: CGRect {
        didSet {
            updateBackgroupLayer()
        }
    }

    override convenience init(frame: CGRect) {
        self.init(frame: frame, type: AnchorView.LOCATION_NONE)
    }

    init(frame: CGRect, type: String) {
        self.type = type
        super.init(frame: frame)
        self.layer.addSublayer(self.backgroundLayer)
        updateBackgroupLayer()
    }

    convenience init(type: String) {
        self.init(frame: .zero, type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBackgroupLayer() {
        let path = CGPath.init(rect: CGRect.init(
            x: (frame.width - padding) / 2,
            y: (frame.height - padding) / 2,
            width: padding,
            height: padding), transform: nil)
        backgroundLayer.path = path
    }
}

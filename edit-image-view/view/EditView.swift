//
//  PosmEditView.swift
//  basho.store
//
//  Created by idt on 2020/11/17.
//  Copyright © 2020 Imagedt. All rights reserved.
//

import Foundation
import UIKit
class EditViewConfig: NSObject {
    let anchorLength: CGFloat
    let anchorHalfLength: CGFloat
    let minSpace: CGFloat
    let areaBorderWidth: CGFloat
    let anchorPadding: CGFloat
    let anchorBackgroundColor: UIColor
    let areaBorderColor: UIColor
    init(anchorLength: CGFloat = 20,
        minSpace: CGFloat = 100,
        areaBorderWidth: CGFloat = 1,
        anchorPadding: CGFloat = 5,
        anchorBackgroundColor: UIColor = UIColor.white,
        areaBorderColor: UIColor = UIColor.systemBlue) {
        self.anchorLength = anchorLength
        self.anchorHalfLength = anchorLength / 2
        self.minSpace = minSpace
        self.areaBorderWidth = areaBorderWidth
        self.anchorPadding = anchorPadding
        self.anchorBackgroundColor = anchorBackgroundColor
        self.areaBorderColor = areaBorderColor
    }
}

class EditView: UIImageView {
    private let config: EditViewConfig
    private let ratios: [Float]
    private var tmpAreaCenterPoint: CGPoint? = nil
    init(ratios: [Float], config: EditViewConfig = EditViewConfig.init()) {
        self.ratios = ratios
        self.config = config
        super.init(frame: .zero)
        
        isUserInteractionEnabled = true
        
        layer.addSublayer(maskLayer)
        
        addSubview(areaView)
        addSubview(topLeftView)
        addSubview(topRightView)
        addSubview(bottomLeftView)
        addSubview(bottomRightView)
        addSubview(leftMidView)
        addSubview(topMidView)
        addSubview(rightMidView)
        addSubview(bottomMidView)

        configView(view: topLeftView)
        configView(view: topRightView)
        configView(view: bottomLeftView)
        configView(view: bottomRightView)
        configView(view: areaView)
        configView(view: leftMidView)
        configView(view: rightMidView)
        configView(view: topMidView)
        configView(view: bottomMidView)
    }
    
    override var frame: CGRect {
        didSet {
            updateView()
        }
    }

    private var cornerMargin: CGFloat {
        get {
            CGFloat.init(config.anchorHalfLength - config.areaBorderWidth)
        }
    }

    private let maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.fillColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        return layer
    }()

    private let topLeftView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_TOP_LEFT)
        return view
    }()

    private let topRightView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_TOP_RIGHT)
        return view
    }()

    private let bottomLeftView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_BOTTOM_LEFT)
        return view
    }()

    private let bottomRightView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_BOTTOM_RIGHT)
        return view
    }()

    private let leftMidView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_LEFT_MID)
        return view
    }()

    private let topMidView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_TOP_MID)
        return view
    }()

    private let rightMidView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_RIGHT_MID)
        return view
    }()

    private let bottomMidView: AnchorView = {
        let view = AnchorView.init(type: AnchorView.LOCATION_BOTTOM_MID)
        return view
    }()

    private let areaView: UIView = {
        let view = UIView.init()
        return view
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAreaRect() -> CGRect {
        return areaView.frame
    }

    private func updateView() {
        createConrners()
        resetArea()
        resetMask()
        resetMid()
    }

    private func configView(view: UIView) {
        let panR = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(gesture:)))
        panR.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panR)
        
        if let anchorView = view as? AnchorView {
            anchorView.padding = config.anchorPadding
            anchorView.anchorBackgroundColor = config.anchorBackgroundColor
        } else if view == areaView {
            view.layer.borderColor = config.areaBorderColor.cgColor
            view.layer.borderWidth = config.areaBorderWidth
        }
    }

    private func createConrners() {
        let rectLeftTopX = frame.width * CGFloat.init(ratios[0])
        let rectLeftTopY = frame.height * CGFloat.init(ratios[1])
        let rectRightBottomX = frame.width * CGFloat.init(ratios[2])
        let rectRightBottomY = frame.height * CGFloat.init(ratios[3])

        let targetRect = CGRect.init(x: rectLeftTopX, y: rectLeftTopY, width: rectRightBottomX - rectLeftTopX, height: rectRightBottomY - rectLeftTopY)
        
        topLeftView.frame = CGRect.init(x: targetRect.minX - config.anchorHalfLength, y: targetRect.minY - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)

        topRightView.frame = CGRect.init(x: targetRect.maxX - config.anchorHalfLength, y: targetRect.minY - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)

        bottomLeftView.frame = CGRect.init(x: targetRect.minX - config.anchorHalfLength, y: targetRect.maxY - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)

        bottomRightView.frame = CGRect.init(x: targetRect.maxX - config.anchorHalfLength, y: targetRect.maxY - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)
    }

    private func resetArea() {
        areaView.frame = CGRect.init(x: topLeftView.frame.minX + cornerMargin,
            y: topLeftView.frame.minY + cornerMargin,
            width: topRightView.frame.maxX - topLeftView.frame.minX - cornerMargin * 2,
            height: bottomLeftView.frame.maxY - topLeftView.frame.minY - cornerMargin * 2)
    }

    private func resetMid() {
        leftMidView.frame = CGRect.init(x: areaView.frame.minX - config.anchorHalfLength, y: areaView.frame.minY + areaView.frame.height / 2 - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)
        topMidView.frame = CGRect.init(x: areaView.frame.minX + areaView.frame.width / 2 - config.anchorHalfLength, y: areaView.frame.minY - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)
        rightMidView.frame = CGRect.init(x: areaView.frame.maxX - config.anchorHalfLength, y: areaView.frame.minY + areaView.frame.height / 2 - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)
        bottomMidView.frame = CGRect.init(x: areaView.frame.maxX - areaView.frame.width / 2 - config.anchorHalfLength, y: areaView.frame.maxY - config.anchorHalfLength, width: config.anchorLength, height: config.anchorLength)
    }

    private func resetMask() {
        let path = UIBezierPath.init(rect: self.bounds)
        let targetRect = areaView.frame
        
        let clipPath = UIBezierPath(rect: targetRect).reversing()
        path.append(clipPath)
        maskLayer.path = path.cgPath
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        if let panView = gesture.view as? AnchorView {
            switch panView.type {
            case AnchorView.LOCATION_TOP_LEFT,
                 AnchorView.LOCATION_TOP_RIGHT,
                 AnchorView.LOCATION_BOTTOM_LEFT,
                 AnchorView.LOCATION_BOTTOM_RIGHT:
                let location = gesture.location(in: self)
                if onHandleCornerAnchorPan(view: panView, location: location) {
                    resetArea()
                    resetMask()
                    resetMid()
                }
                break
            case AnchorView.LOCATION_LEFT_MID:
                let location = gesture.location(in: self)
                if onHandleLeftMidAnchorPan(view: panView, location: location) {
                    resetCornerOnAreaFrameChanged()
                    resetMask()
                    resetMid()
                }
                break
            case AnchorView.LOCATION_RIGHT_MID:
                let location = gesture.location(in: self)
                if onHandleRightMidAnchorPan(view: panView, location: location) {
                    resetCornerOnAreaFrameChanged()
                    resetMask()
                    resetMid()
                }
                break
            case AnchorView.LOCATION_TOP_MID:
                let location = gesture.location(in: self)
                if onHandleTopMidAnchorPan(view: panView, location: location) {
                    resetCornerOnAreaFrameChanged()
                    resetMask()
                    resetMid()
                }
                break
            case AnchorView.LOCATION_BOTTOM_MID:
                let location = gesture.location(in: self)
                if onHandleBottomMidAnchorPan(view: panView, location: location) {
                    resetCornerOnAreaFrameChanged()
                    resetMask()
                    resetMid()
                }
                break
            default:
                break
            }
        } else if gesture.view == areaView {
            if gesture.state == .began {
                self.tmpAreaCenterPoint = areaView.center
            } else if gesture.state == .changed, let tmpAreaCenter = self.tmpAreaCenterPoint {
                let translation = gesture.translation(in: self)
                let location = CGPoint.init(x: tmpAreaCenter.x + translation.x, y: tmpAreaCenter.y + translation.y)
                if onHandleCenterAnchorPan(location: location) {
                    resetCornerOnAreaFrameChanged()
                    resetMask()
                    resetMid()
                }
            }
        }
    }

    private func updateCornerOnPan(view: AnchorView, location: CGPoint) -> Bool {
        let relationX: UIView
        let relationY: UIView
        switch view.type {
        case AnchorView.LOCATION_TOP_LEFT:
            relationX = topRightView
            relationY = bottomLeftView
            break
        case AnchorView.LOCATION_TOP_RIGHT:
            relationX = topLeftView
            relationY = bottomRightView
            break
        case AnchorView.LOCATION_BOTTOM_LEFT:
            relationX = bottomRightView
            relationY = topLeftView
            break
        case AnchorView.LOCATION_BOTTOM_RIGHT:
            relationX = bottomLeftView
            relationY = topRightView
            break
        default:
            return false
        }

        let xFactor = relationX.frame.minX > view.frame.minX ? -1 : 1
        let yFactor = relationY.frame.minY > view.frame.minY ? -1 : 1

        let a = (location.x - relationX.center.x) * CGFloat(xFactor) + view.frame.width - self.cornerMargin * 2
        let b = config.minSpace + view.frame.width * 2 - self.cornerMargin * 2
        let c: CGFloat
        if xFactor < 0 {
            c = relationX.center.x + view.frame.width / 2 - self.cornerMargin
        } else {
            c = self.frame.width - relationX.center.x + view.frame.width / 2 - self.cornerMargin
        }
        let spaceX = min(max(a, b), c)

        let d = (location.y - relationY.center.y) * CGFloat(yFactor) + view.frame.height - self.cornerMargin * 2
        let e = config.minSpace + view.frame.height * 2 - self.cornerMargin * 2
        let f: CGFloat
        if yFactor < 0 {
            f = relationY.center.y + view.frame.height / 2 - self.cornerMargin
        } else {
            f = self.frame.height - relationY.center.y + view.frame.height / 2 - self.cornerMargin
        }
        let spaceY = min(max(d, e), f)

        let centerX = (spaceX - view.frame.width + self.cornerMargin * 2) * CGFloat(xFactor) + relationX.center.x
        let centerY = (spaceY - view.frame.height + self.cornerMargin * 2) * CGFloat(yFactor) + relationY.center.y
        view.frame = CGRect.init(x: centerX - view.frame.width / 2, y: centerY - view.frame.height / 2, width: view.frame.width, height: view.frame.height)
        print("location: \(location), a: \(a), b:\(b), c: \(c), d: \(d), e: \(e), f: \(f), spaceX: \(spaceX), spaceY: \(spaceY), centerX: \(centerX), centerY: \(centerY)")
        return true
    }

    private func resetCornerRelationFrame(view: AnchorView) -> Bool {
        let relationX: UIView
        let relationY: UIView
        switch view.type {
        case AnchorView.LOCATION_TOP_LEFT:
            relationX = topRightView
            relationY = bottomLeftView
            break
        case AnchorView.LOCATION_TOP_RIGHT:
            relationX = topLeftView
            relationY = bottomRightView
            break
        case AnchorView.LOCATION_BOTTOM_LEFT:
            relationX = bottomRightView
            relationY = topLeftView
            break
        case AnchorView.LOCATION_BOTTOM_RIGHT:
            relationX = bottomLeftView
            relationY = topRightView
            break
        default:
            return false
        }

        relationX.frame = CGRect.init(x: relationX.frame.minX, y: view.frame.minY, width: relationX.frame.width, height: relationX.frame.height)
        relationY.frame = CGRect.init(x: view.frame.minX, y: relationY.frame.minY, width: relationY.frame.width, height: relationY.frame.height)

        return true
    }

    private func onHandleCornerAnchorPan(view: AnchorView, location: CGPoint) -> Bool {
        if updateCornerOnPan(view: view, location: location) {
            return resetCornerRelationFrame(view: view)
        } else {
            return false
        }
    }

    private func onHandleCenterAnchorPan(location: CGPoint) -> Bool {
        let centerMinX = areaView.frame.width / 2
        let centerMaxX = self.frame.width - areaView.frame.width / 2
        let centerMinY = areaView.frame.height / 2
        let centerMaxY = self.frame.height - areaView.frame.height / 2

        areaView.center = CGPoint.init(x: min(max(centerMinX, location.x), centerMaxX),
            y: min(max(centerMinY, location.y), centerMaxY))
        return true
    }

    private func onHandleLeftMidAnchorPan(view: AnchorView, location: CGPoint) -> Bool {
        let willY = areaView.frame.minY
        let willX = location.x
        let maxWidth = frame.maxX
        let minWidth = config.minSpace + view.frame.width * 2 - self.cornerMargin * 2
        let willWidth = min(max(minWidth, areaView.frame.maxX - willX), maxWidth)
        let deltaX = willWidth - areaView.frame.width
        areaView.frame = CGRect.init(x: areaView.frame.minX - deltaX, y: willY, width: willWidth, height: areaView.frame.height)
        print("willX:\(willX), maxWidth: \(maxWidth), minWidth: \(minWidth), deltaX: \(deltaX), distance: \(willWidth - areaView.frame.width), areaViewFrame: \(areaView.frame)")
        return true
    }

    private func onHandleRightMidAnchorPan(view: AnchorView, location: CGPoint) -> Bool {
        let willX = location.x
        let maxWidth = frame.width - areaView.frame.minX
        let minWidth = config.minSpace + view.frame.width * 2 - self.cornerMargin * 2
        let willWidth = min(max(minWidth, willX - areaView.frame.maxX + areaView.frame.width), maxWidth)
        let deltaX = willWidth - areaView.frame.width
        areaView.frame = CGRect.init(x: areaView.frame.minX, y: areaView.frame.minY, width: willWidth, height: areaView.frame.height)
        print("willX:\(willX), maxWidth: \(maxWidth), minWidth: \(minWidth), deltaX: \(deltaX), distance: \(willWidth - areaView.frame.width), areaViewFrame: \(areaView.frame)")
        return true
    }

    private func onHandleTopMidAnchorPan(view: AnchorView, location: CGPoint) -> Bool {
        let distance = areaView.frame.minY - location.y
        let maxHeight = areaView.frame.maxY
        let minHeight = config.minSpace + view.frame.height * 2 - self.cornerMargin * 2
        let willHeight = min(max(minHeight, areaView.frame.height + distance), maxHeight)
        let deltaY = willHeight - areaView.frame.height
        areaView.frame = CGRect.init(x: areaView.frame.minX, y: areaView.frame.minY - deltaY, width: areaView.frame.width, height: willHeight)
        print("maxHeight: \(maxHeight), minHeight: \(minHeight), distance: \(distance),willHeight:\(willHeight) areaViewFrame: \(areaView.frame)")
        return true
    }

    private func onHandleBottomMidAnchorPan(view: AnchorView, location: CGPoint) -> Bool {
        let maxHeight = frame.height - areaView.frame.minY
        let minHeight = config.minSpace + view.frame.height * 2 - self.cornerMargin * 2
        let distance: CGFloat = location.y - areaView.frame.maxY + areaView.frame.height

        let willHeight = min(max(minHeight, distance), maxHeight)
        areaView.frame = CGRect.init(x: areaView.frame.minX, y: areaView.frame.minY, width: areaView.frame.width, height: willHeight)
        print("maxHeight: \(maxHeight), minHeight: \(minHeight), willHeight: \(willHeight), distance: \(distance)")
        return true
    }

    private func resetCornerOnAreaFrameChanged() {
        topLeftView.frame = CGRect.init(x: areaView.frame.minX - self.cornerMargin, y: areaView.frame.minY - self.cornerMargin, width: topLeftView.frame.width, height: topLeftView.frame.height)
        topRightView.frame = CGRect.init(x: areaView.frame.maxX + self.cornerMargin - config.anchorLength, y: areaView.frame.minY - self.cornerMargin, width: topRightView.frame.width, height: topRightView.frame.height)
        bottomLeftView.frame = CGRect.init(x: areaView.frame.minX - self.cornerMargin, y: areaView.frame.maxY + self.cornerMargin - config.anchorLength, width: bottomLeftView.frame.width, height: bottomLeftView.frame.height)
        bottomRightView.frame = CGRect.init(x: areaView.frame.maxX - self.cornerMargin, y: areaView.frame.maxY - self.cornerMargin, width: bottomLeftView.frame.width, height: bottomLeftView.frame.height)
    }
}

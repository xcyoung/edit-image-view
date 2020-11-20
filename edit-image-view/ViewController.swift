//
//  ViewController.swift
//  edit-image-view
//
//  Created by idt on 2020/11/20.
//

import UIKit

extension UIView {
    func getSafeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }

    func topSafeAreaInset() -> CGFloat {
        return getSafeAreaInsets().top
    }

    func bottomSafeAreaInset() -> CGFloat {
        return getSafeAreaInsets().bottom
    }

    func leftSafeAreaInset() -> CGFloat {
        return getSafeAreaInsets().left
    }

    func rightSafeAreaInset() -> CGFloat {
        return getSafeAreaInsets().right
    }
}

class ViewController: UIViewController {

    private let editView: EditView = EditView.init(ratios: [0, 0, 0.5, 0.5])

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        editView.frame = CGRect.init(
            x: self.view.leftSafeAreaInset(),
            y: self.view.topSafeAreaInset() + 76,
            width: self.view.frame.width,
            height: self.view.frame.width * (4.0 / 3.0))
        self.view.addSubview(editView)
        
        editView.image = UIImage.init(named: "aa")
    }


}


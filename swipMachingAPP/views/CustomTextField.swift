//
//  CustomTextField.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/13.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    let padding: CGFloat

    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        self.layer.cornerRadius = 22
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

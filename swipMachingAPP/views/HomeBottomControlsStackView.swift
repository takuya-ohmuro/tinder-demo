
//
//  HomeBottomControlsStackView.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/02.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit

final class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true

        let subviews = [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map{ (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }

        subviews.forEach { (v) in
            addArrangedSubview(v)
        }

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

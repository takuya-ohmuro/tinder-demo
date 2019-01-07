 //
//  TopNavigationStackView.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/05.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit

final class TopNavigationStackView: UIStackView {

    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    private let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        heightAnchor.constraint(equalToConstant: 80).isActive = true
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        fireImageView.contentMode = .scaleAspectFit

        [settingsButton, UIView(), fireImageView, UIView(), messageButton].forEach { (v) in
            addArrangedSubview(v)
        }

        distribution = .equalCentering

        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

    }

    required init(coder: NSCoder) {
        fatalError()
    }

}

//
//  Advertiser.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/08.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {

    let title: String
    let brandName: String
    let posterPhotoName: String

    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))

        return CardViewModel(imageNames: [posterPhotoName], attributedString: attributedString, textAligment: .center)
    }

}

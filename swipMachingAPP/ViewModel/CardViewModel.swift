 //
//  CardViewModel.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/08.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit

 protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
 }


struct CardViewModel {

    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment

 }

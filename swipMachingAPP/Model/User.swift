//
//  User.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/06.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {

    var name: String?
    var age: Int?
    var profession: String?
//    let imageNames: [String]
    var imageUrl1: String?
    var uid: String?

    init(dictionary: [String: Any]) {
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""

    }

    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedText.append(NSMutableAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        let professionString = profession != nil ? profession! : "Not available"
        attributedText.append(NSMutableAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAligment: .left)
    }
    
}


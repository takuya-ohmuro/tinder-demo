//
//  Bindable.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/12/09.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }

    var observer: ((T?) -> ())?

    func bind(observer: @escaping ((T?) -> ())) {
        self.observer = observer
    }

}

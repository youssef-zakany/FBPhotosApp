//
//  Bindable.swift
//  FBPhotosApp
//
//  Created by YouSS on 6/26/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}

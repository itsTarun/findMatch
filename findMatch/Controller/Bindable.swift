//
//  Bindable.swift
//  findMatch

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ( (T?) -> () )?
    
    func bind(_ observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}

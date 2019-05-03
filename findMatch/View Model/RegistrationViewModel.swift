//
//  RegistrationViewModel.swift
//  findMatch

import Foundation

class RegistrationViewModel {
    
    var fullName  : String? { didSet { checkFormValidity() } }
    var email     : String? { didSet { checkFormValidity() } }
    var password  : String? { didSet { checkFormValidity() } }
    
    var isFormValidObserver: ( (Bool) -> () )?
    
    fileprivate func checkFormValidity() {
        
        let isFormValid = (fullName?.isEmpty == false) && (email?.isEmpty == false) && (password?.isEmpty == false)
        
        isFormValidObserver?(isFormValid)
    }
}

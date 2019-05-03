//
//  RegistrationViewModel.swift
//  findMatch

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    var fullName  : String?   { didSet { checkFormValidity() } }
    var email     : String?   { didSet { checkFormValidity() } }
    var password  : String?   { didSet { checkFormValidity() } }
    
    var bindableIsFormValid = Bindable<Bool>()
    
    fileprivate func checkFormValidity() {
        
        let isFormValid = (fullName?.isEmpty == false) && (email?.isEmpty == false) && (password?.isEmpty == false)
        
        bindableIsFormValid.value = isFormValid
    }
}

//
//  CardViewModel.swift
//  findMatch


import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    
    let imageName : String
    let attributedString : NSAttributedString   
    let textAlignment: NSTextAlignment
    
}

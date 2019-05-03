//
//  CardViewModel.swift
//  findMatch


import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    
    let imageNames : [String]
    let attributedString : NSAttributedString   
    let textAlignment: NSTextAlignment
    
}

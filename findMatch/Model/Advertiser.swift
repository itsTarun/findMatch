//
//  Advertiser.swift
//  findMatch

import UIKit

struct Advertiser {
    
    let title: String
    let brandName : String
    let posterPhotoName: String
    
}

extension Advertiser : ProducesCardViewModel {
    
    func toCardViewModel() -> CardViewModel {
        
        let attributeString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        
        attributeString.append(NSAttributedString(string: "\n \(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageName: posterPhotoName, attributedString: attributeString, textAlignment: .center)
    }
    
}

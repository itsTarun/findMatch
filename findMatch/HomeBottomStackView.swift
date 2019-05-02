//
//  HomeBottomStackView.swift
//  findMatch

import UIKit

class HomeBottomStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeBottomStackView {
    
    fileprivate func setupView() {
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        // bottom row of buttons
        let bottomSubViews = [UIColor.red,
                              UIColor.green,
                              UIColor.blue,
                              UIColor.purple,
                              UIColor.black].map
            { (color) -> UIView in
                let v = UIView()
                v.backgroundColor = color
                return v
        }
        
        bottomSubViews.forEach { (view) in
            addArrangedSubview(view)
        }
    }
    
}

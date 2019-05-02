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
        heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        // bottom row of buttons
        
        let bottomSubViews = [#imageLiteral(resourceName: "refresh_circle"),#imageLiteral(resourceName: "dismiss_circle"),#imageLiteral(resourceName: "super_like_circle"),#imageLiteral(resourceName: "like_circle"),#imageLiteral(resourceName: "boost_circle")].map
        { (img) -> UIView in
            
            let button = UIButton(type: UIButton.ButtonType.system)
            
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: UIControl.State.normal)
            
            return button
        }
        
        
        
        bottomSubViews.forEach { (view) in
            addArrangedSubview(view)
        }
    }
    
}

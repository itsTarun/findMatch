//
//  HomeTopStackView.swift
//  findMatch

import UIKit

class HomeTopStackView: UIStackView {

    let settingsButton = UIButton(type: UIButton.ButtonType.system)
    let messageButton = UIButton(type: UIButton.ButtonType.system)
    
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon.png"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeTopStackView {
    
    fileprivate func setupView()
    {
        
        
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        
        fireImageView.contentMode = .scaleAspectFit
        
        [settingsButton,
         UIView(),
         fireImageView,
         UIView(),
         messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}

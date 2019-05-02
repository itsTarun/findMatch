//
//  ViewController.swift
//  findMatch

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethods()
    }


    fileprivate func viewDidLoadMethods() {
        
        let topSubViews = [UIColor.gray,
                           UIColor.darkGray,
                           UIColor.black].map
            { (color) -> UIView in
                let v = UIView()
                v.backgroundColor = color
                return v
            }
        
        let topStackView = UIStackView(arrangedSubviews: topSubViews)
        topStackView.distribution = .fillEqually
        topStackView.axis = .horizontal
        
        topStackView.backgroundColor = .red
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let centerView = UIView()
        centerView.backgroundColor = .blue
        
        let bottomStackView = HomeBottomStackView()
        
        let overAllStackView = UIStackView(arrangedSubviews: [topStackView, centerView, bottomStackView])
        
        overAllStackView.axis = .vertical
        
        view.addSubview(overAllStackView)
        
        overAllStackView.fillSuperview()
    }
    
}


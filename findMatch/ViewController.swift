//
//  ViewController.swift
//  findMatch

import UIKit

class ViewController: UIViewController {

    let topStackView = HomeTopStackView()
    let centerView = UIView()
    let bottomStackView = HomeBottomStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }

}

extension ViewController {
    
    fileprivate func setupLayout() {
        
        centerView.backgroundColor = .blue
        
        let overAllStackView = UIStackView(arrangedSubviews: [topStackView, centerView, bottomStackView])
        
        overAllStackView.axis = .vertical
        
        view.addSubview(overAllStackView)
        
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor)
    }
    
}

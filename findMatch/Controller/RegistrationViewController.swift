//
//  RegistrationViewController.swift
//  findMatch


import UIKit

class RegistrationViewController: UIViewController {
    
    // UI Components
    
    let selectPhotoButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    let fullNameTextField: UITextField = {
       let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        return tf
    }()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        let stackView = UIStackView(arrangedSubviews: [selectPhotoButton,fullNameTextField,emailTextField,passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32))
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
}


extension RegistrationViewController {
    
    fileprivate func setupGradientLayer()
    {
        let gradientLayer = CAGradientLayer()
        
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3647058824, blue: 0.3568627451, alpha: 1)
        
        let bottomColor = #colorLiteral(red: 0.9173635563, green: 0.2775638204, blue: 0.4196078431, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
        gradientLayer.locations = [0,1]
        
        view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = view.bounds
    }
    
}

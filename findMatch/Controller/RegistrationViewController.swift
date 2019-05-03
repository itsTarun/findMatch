import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    // UI Components
    //---------------------------------------------------------------------------------------------------------------------------------------------
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        return tf
    }()
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        return tf
    }()
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextDidChange), for: .editingChanged)
        return tf
    }()
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    let gradientLayer = CAGradientLayer()
    
    let imagePickerController = UIImagePickerController()
    
    let registrationViewModel = RegistrationViewModel()
    
    let registeringHUD = JGProgressHUD(style: .dark)
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    //---------------------------------------------------------------------------------------------------------------------------------------------
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
        ])
    
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModel()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
        
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension RegistrationViewController {
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc fileprivate func handleRegister() {
        
        self.handleTapDismiss()
        
        guard let email = emailTextField.text ,
            let password = passwordTextField.text
            else { return }
        
        registeringHUD.textLabel.text = "Register"
        registeringHUD.show(in: view)
        
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            
            if let err = error {
                self.showHUDWithError(err)
                return
            }
            
            
            print("\n\nSuccessfully registered user: ", response?.user.uid ?? "" ,"\n\n")
            
            // only upload images to firebase storage once you are authorized.
            let fileName = UUID().uuidString
            
            let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
            
            if let imageData = self.registrationViewModel.bindableImage.value?.jpegData(compressionQuality: 0.75) {
                
                ref.putData(imageData, metadata: nil, completion: { (_, err) in
                    
                    if let error = err {
                        self.showHUDWithError(error)
                        return
                    }
                    
                    print("\n\nFinished uploading image to storage\n\n")
                    
                    ref.downloadURL(completion: { (url, err) in
                        
                        if let error = err {
                            self.showHUDWithError(error)
                            return
                        }
                        
                        print("\n\nDownload url of our image - \(url?.absoluteString ?? "")\n\n")
                        
                        // store the download url into firestore next lesson
                        
                        self.registeringHUD.dismiss()
                    })
                    
                })
                
            }
            
            
        }
        
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc fileprivate func handleSelectPhoto() {
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc fileprivate func handleTapDismiss() {
        // dismisses keyboard
        self.view.endEditing(true)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc fileprivate func handleTextDidChange(textField: UITextField) {
        
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
        
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        // how to figure out how tall the keyboard actually is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        //print(keyboardFrame)
        
        // let's try to figure out how tall the gap is from the register button to the bottom of the screen
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        //print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
}


extension RegistrationViewController {
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func showHUDWithError(_ error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.4)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func setupRegistrationViewModel() {
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self]   (isFormValid) in
            
            guard let isFormValid = isFormValid else { return }
            
            self.registerButton.isEnabled = isFormValid
            
            if isFormValid {
                
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
                
            }else {
                
                self.registerButton.setTitleColor(.gray, for: .disabled)
                self.registerButton.backgroundColor = .lightGray
                
            }
        }
        
        registrationViewModel.bindableImage.bind {  [unowned self] (img) in
            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        
        overallStackView.axis = .vertical
        
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
}


extension RegistrationViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        registrationViewModel.bindableImage.value = image
        
        dismiss(animated: true)
        
    }
    //---------------------------------------------------------------------------------------------------------------------------------------------
}

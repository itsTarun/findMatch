//
//  ViewController.swift
//  findMatch

import UIKit

class HomeViewController: UIViewController {
    
    let cardViewModel: [CardViewModel] = {
        
        let producers = [
            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
            Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster"),
            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1", "jane2", "jane3"])
            ] as [ProducesCardViewModel]
        
        let viewModels = producers.map({ return $0.toCardViewModel() })
        
        return viewModels
    }()
    
    
    let topStackView = HomeTopStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomStackView()
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
    }
    
}

extension HomeViewController {
    
    @objc fileprivate func handleSetting() {
        
        let registrationViewController = RegistrationViewController()
        
        present(registrationViewController, animated: true)
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func setupDummyCards() {
        
        cardViewModel.forEach { (cardVM) in
            
            let cardView = CardView(frame: .zero)
            
            cardView.cardViewModel = cardVM
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
    
}

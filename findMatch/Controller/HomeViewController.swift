//
//  ViewController.swift
//  findMatch

import UIKit

class HomeViewController: UIViewController {
    
    let cardViewModel: [CardViewModel] = {
        
        let producers = [
            
            User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c"),
            User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c"),
            Advertiser(title: "Slide out menu", brandName: "Lets build that app", posterPhotoName: "slide_out_menu_poster"),
            User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c"),
            User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c")
            
            ] as [ProducesCardViewModel]
        
        let viewModels = producers.map({ return $0.toCardViewModel() })
        
        return viewModels
    }()
    
    
    let topStackView = HomeTopStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
    }
    
}

extension HomeViewController {
    
    // MARK:- Fileprivate
    
    fileprivate func setupDummyCards() {
        
        cardViewModel.forEach { (cardVM) in
            
            let cardView = CardView(frame: .zero)
            
            cardView.cardViewModel = cardVM
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    
    
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

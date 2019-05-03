//
//  CardView.swift
//  findMatch

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    fileprivate let informationLabel = UILabel()
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let barsStackView = UIStackView()
    
    fileprivate let deSelectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate let threshold: CGFloat = 80
    
    fileprivate var imageIndex = 0
    
    var cardViewModel: CardViewModel! {
        didSet {
            
            let imageName = cardViewModel.imageNames.first ?? ""
            
            imageView.image = UIImage(named: imageName)
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { _ in
                
                let barView = UIView()
                barView.backgroundColor = deSelectedColor
                barsStackView.addArrangedSubview(barView)
            }
            
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
}


extension CardView {
    
    
    fileprivate func setupLayout() {
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
        
        imageView.contentMode = .scaleAspectFill
        
        // add imageView
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        // add bars StackView
        setupBarsStackView()
        
        // add gradient layer
        
        setupGradientLayer()
        
        // add informationLabel
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 4))
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
    }
    
    fileprivate func setupGradientLayer()
    {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        gradientLayer.locations = [0.50, 1.1]
        
        layer.addSublayer(gradientLayer)
    }
    
}


extension CardView {
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subView) in
                subView.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            ()
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        
        let tapLocation = gesture.location(in: nil)
        
        let shouldAdvanceNexPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNexPhoto {
            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
            
        } else {
            imageIndex = max(0, imageIndex - 1)
        }
        
        let imageName = cardViewModel.imageNames[imageIndex]
        
        imageView.image = UIImage(named: imageName)
        
        
        barsStackView.arrangedSubviews.forEach { (view) in
            view.backgroundColor = deSelectedColor
        }
        
        barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
    }
    
}


extension CardView {
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        // rotation
        // some not that scary math here to convert radians to degrees
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
            
        }
        
    }
    
}

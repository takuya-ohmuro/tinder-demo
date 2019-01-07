//
//  CardsView.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/06.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit
import SDWebImage

class CardsView: UIView {

    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
//            imageView.image = UIImage(named: imageName)
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAligment

            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
        }
    }

    // MARK:- properties

    private let threshould: CGFloat = 80
    private let gradientLayer = CAGradientLayer()
    private let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    private let informationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)

    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
        }else {
            imageIndex = max(0, imageIndex - 1)
        }
        let imageName = cardViewModel.imageNames[imageIndex]
        imageView.image = UIImage(named: imageName)
        barsStackView.arrangedSubviews.forEach { (v) in
            v.backgroundColor = barDeselectedColor
        }
        barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
    }

    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()

        setupBarsStackView()

        // add a gradient layer somehow
        setupGradientLayer()

        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))

        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
    }

    private let barsStackView = UIStackView()

    private func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }


    fileprivate func setupGradientLayer() {
        // how we can draw a gradient with Swift
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }


    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                super.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }

    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshould

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
//            self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
        }
    }

    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {let translation = gesture.translation(in: nil)
        // rotation
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

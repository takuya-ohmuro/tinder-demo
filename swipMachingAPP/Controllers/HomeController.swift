//
//  ViewController.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/02.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    // MARK: Properties

    let topStackView = TopNavigationStackView()
    private let cardsDeckView = UIView()
    private let bottomStackView = HomeBottomControlsStackView()

//    let cardViewModels: [CardViewModel] = {
//        let producers = [
//             User(name: "Kally", age: 23, profession: "Music DJ", imageNames: ["kelly1","kelly2","kelly3"]),
//            Advertiser(title: "Slide Out Menu", brandName: "Lets Build That App", posterPhotoName: "slide_out_menu_poster"),
//            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1","jane2","jane3"])
//        ] as [ProducesCardViewModel]
//
//        let viewModels = producers.map({ return $0.toCardViewModel() })
//        return viewModels
//    }()

    var cardViewModels = [CardViewModel]()

    // MARK:- Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        fetchUsersFromFirestore()
    }

    private func fetchUsersFromFirestore() {
        let query = Firestore.firestore().collection("users")
        query.getDocuments { (snapshot, err) in
            if let err = err {
                print("Fiald to fetch users:", err)
                return
            }

            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDirectory = documentSnapshot.data()
                let user = User(dictionary: userDirectory)
                self.cardViewModels.append(user.toCardViewModel())
            })
            self.setupFirestoreUserCards()

        }
    }

    @objc func handleSettings() {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
        
    }
    
    private func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardsView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }

    // MARK:- setiing layout

    private func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)

        overallStackView.bringSubviewToFront(cardsDeckView)
    }


}


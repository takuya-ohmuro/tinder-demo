//
//  RegistrationViewModel.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/18.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {

    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormVaild = Bindable<Bool>()

//    var image: UIImage? {
//        didSet {
//            imageObserver?(image)
//        }
//    }

//    var imageObserver: ((UIImage?) -> ())?

    var fullName: String? { didSet { checkFormVaildity() } }
    var email: String? { didSet { checkFormVaildity() } }
    var password: String? { didSet { checkFormVaildity() } }

    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in

            if let err = err {
                completion(err)
                return
            }
            print("Successfully registered user:", res?.user.uid ?? "")
            self.saveImageToFirebase(completion: completion)
        }

    }

    private func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                print("Donload url of our image is:", url?.absoluteString ?? "")
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
        })
    }

    private func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl": imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }

            completion(nil)

        }
    }


    fileprivate func checkFormVaildity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormVaild.value = isFormValid
//        isFormVaildObserver?(isFormValid)
    }

    // Reactive Programing

//    var isFormVaildObserver: ((Bool) -> ())?

}

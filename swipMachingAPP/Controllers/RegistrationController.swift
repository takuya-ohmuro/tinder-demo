//
//  RegistrationController.swift
//  swipMachingAPP
//
//  Created by 大室拓也 on 2018/11/13.
//  Copyright © 2018年 taku9321. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

}

class RegistrationController: UIViewController {

    // UI Componets

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleToFill
        button.clipsToBounds = true
        return button
    }()

    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    let fullNameTextFeild: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.backgroundColor = .white
        return tf
    }()

    let emailTextFeild: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.backgroundColor = .white
        return tf
    }()

    let passwordTextFeild: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        tf.backgroundColor = .white
        return tf
    }()

    @objc private func handleTextChange(textField: UITextField) {
        if textField == fullNameTextFeild {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextFeild {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }


    }

    let registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
//        btn.backgroundColor = #colorLiteral(red: 0.7450980392, green: 0.1921568627, blue: 0.3333333333, alpha: 1)
        btn.backgroundColor = .lightGray
        btn.setTitleColor(.gray, for: .disabled)
        btn.isEnabled = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return btn
    }()

    let registeringHUD = JGProgressHUD(style: .dark)

    @objc private func handleRegister() {
        self.handleTapDismiss()

        registrationViewModel.performRegistration { [weak self] err in
            if let err = err {
                self?.showHUDWithError(error: err)
                return
            }
            print("Finished registering our user")
        }

    }

    private func showHUDWithError(error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }

    // MARK: private

    let registrationViewModel = RegistrationViewModel()

    private func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormVaild.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.6901960784, green: 0.2392156863, blue: 0.337254902, alpha: 1) : .lightGray
            self.registerButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }

        registrationViewModel.bindableImage.bind { [unowned self] img in
            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        registrationViewModel.bindableIsRegistering.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.registeringHUD.textLabel.text = "Register"
                self.registeringHUD.show(in: self.view)
            } else {
                self.registeringHUD.dismiss()
            }
        }

    }

    private func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }

    @objc private func handleTapDismiss() {
        self.view.endEditing(true)
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }

    @objc private func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)

        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        print(bottomSpace)

        let differece = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -differece - 8)

    }

    lazy var vericalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextFeild,
            emailTextFeild,
            passwordTextFeild,
            registerButton,
            ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()

    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        vericalStackView
        ])

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }

    private func setupLayout() {
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    let gradientLayer = CAGradientLayer()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.937254902, green: 0.5215686275, blue: 0.4901960784, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8156862745, green: 0.2156862745, blue: 0.4549019608, alpha: 1)
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }

}

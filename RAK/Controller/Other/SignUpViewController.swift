//
//  signUpViewController.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let profilePictureImageView: UIImageView  = {
        let image = UIImageView()
        image.tintColor = .lightGray
        image.image = UIImage(systemName: "person.circle")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 45
        return image
    }()
    
    
    private let userNameField: UITextField  = {
        let field = RAKTextField()
        field.placeholder = "Username"
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
    }()
    
    private let emailField: UITextField  = {
        let field = RAKTextField()
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
    }()
    
    private let passwordField: UITextField  = {
        let field = RAKTextField()
        field.placeholder = "Create Password"
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        return field
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Terms of Service", for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Privacy Policy", for: .normal)
        return button
    }()
    
    public var completion: (() -> Void)?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        addSubViews()
        
        userNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        addButtonActions()
        addImageGesture()
    }
    
    func addSubViews() {
        view.addSubview(profilePictureImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(userNameField)
        view.addSubview(privacyButton)
        view.addSubview(termsButton)
        addImageGesture()
    }
    
    private func addImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 90
        profilePictureImageView.frame = CGRect(x: (view.width - imageSize) / 2,
                                               y: view.safeAreaInsets.top + 15,
                                               width: imageSize,
                                               height: imageSize)
        
        userNameField.frame = CGRect(x: 25,
                                     y: profilePictureImageView.bottom+20,
                                     width: view.width-50,
                                     height: 50)
        
        emailField.frame = CGRect(x: 25,
                                  y: userNameField.bottom+10,
                                  width: view.width-50,
                                  height: 50)
        
        passwordField.frame = CGRect(x: 25,
                                     y: emailField.bottom+10,
                                     width: view.width-50,
                                     height: 50)
        
        signUpButton.frame = CGRect(x: 35,
                                    y: passwordField.bottom+20,
                                    width: view.width-70,
                                    height: 50)
        
        termsButton.frame = CGRect(x: 35,
                                   y: signUpButton.bottom+50,
                                   width: view.width-70,
                                   height: 50)
        
        privacyButton.frame = CGRect(x: 35,
                                     y: termsButton.bottom+10,
                                     width: view.width-70,
                                     height: 40)
    }
    //MARK: - Actions
    func addButtonActions() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
    }
    
    @objc
    func didTapSignUp(){
        userNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let userName = userNameField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !userName.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              userName.count >= 2,
              userName.trimmingCharacters(in: .alphanumerics).isEmpty    else {
            presentError()
            return
        }
        let data = profilePictureImageView.image?.pngData()
        
        AuthManager.shared.signUp(
            email: email,
            username: userName,
            password: password,
            profilePicture: data
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                    UserDefaults.standard.setValue(user.username, forKey: "username")
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.completion?()
                case .failure(let error):
                    print("\n\nSign Up Error: \(error)")
                }
            }
        }
    }
    
    @objc
    func didTapTerms(){
        guard let url = URL(string: "https://www.rakphotoproject.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc
    func didTapPrivacy(){
        guard let url = URL(string: "https://www.rakphotoproject.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc
    func didTapImage(){
        let sheet = UIAlertController(
            title: "Profile Picture",
            message: "Set a picture to help your friends find you.",
            preferredStyle: .actionSheet
        )
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.delegate = self
                self?.present (picker,animated: true)
            }
            
        }))
        sheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self?.present (picker,animated: true)
            }
        }))
        present(sheet,animated: true)
    }
    
    //MARK: - TextField Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField{
            emailField.becomeFirstResponder()
        }else if textField == emailField{
            passwordField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
            didTapSignUp()
        }
        return true
    }
    
    func presentError()  {
        let alert = UIAlertController(title: "Whoops", message: "Please make sure to fill all all fields and have a password longer than 6 characters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return  }
        profilePictureImageView.image = image
    }
}

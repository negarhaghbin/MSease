//
//  SignupViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-12.
//

import UIKit
import RealmSwift

class SignupViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    let app = RealmManager.shared.connectToMongoDB()

    var email: String? {
        get {
            return emailTextField.text
        }
    }

    var password: String? {
        get {
            return passwordTextField.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    // MARK: - Helpers
    
    func setUpElements(){
//        errorLabel.alpha = 0
        StylingUtilities.styleTextField(emailTextField)
        StylingUtilities.styleTextField(passwordTextField)
        StylingUtilities.styleFilledButton(signupButton)
        setLoading(false)
    }
    
    func setLoading(_ loading: Bool) {
        activityIndicator.isHidden = !loading
        if loading {
            activityIndicator.startAnimating()
            errorLabel.text = ""
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loading
        passwordTextField.isEnabled = !loading
        signupButton.isEnabled = !loading
    }
    
    func loginAction(result: Result<RealmSwift.User, Error>){
        setLoading(false)
        switch result {
        case .failure(let error):
            print("Login failed: \(error)")
            errorLabel.text = "Login failed: \(error.localizedDescription)"
            return
        case .success(let user):
            print("Login succeeded!")

            setLoading(true)
            var configuration = user.configuration(partitionValue: "user=\(user.id)")
            configuration.objectTypes = [User.self]
            Realm.asyncOpen(configuration: configuration) { [weak self](result) in
                DispatchQueue.main.async {
                    self!.setLoading(false)
                    switch result {
                    case .failure(let error):
                        fatalError("Failed to open realm: \(error)")
                    case .success(let userRealm):
                        
                    print("go to main view controller")
                    /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let homeVC = storyboard.instantiateViewController(identifier: "home") as? MainViewController{
                            present(homeVC(userRealm: userRealm), animated: true)
                        }*/
                    }
                }
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        setLoading(true)
        app.emailPasswordAuth.registerUser(email: email!, password: password!, completion: { [weak self](error) in
            DispatchQueue.main.async {
                self!.setLoading(false)
                guard error == nil else {
                    print("Signup failed: \(error!)")
                    self!.errorLabel.text = "Signup failed: \(error!.localizedDescription)"
                    return
                }
                print("Signup successful!")
                self!.errorLabel.text = "Signup successful! Signing in..."
                // TODO: Login
//                RealmManager.shared.login(email: self?.email, password: self?.password, loginAction: self?.loginAction)
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

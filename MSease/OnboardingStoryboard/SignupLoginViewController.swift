//
//  SignupLoginViewController.swift
//  MSease
//
//  Created by Negar on 2021-03-12.
//

import UIKit
import RealmSwift

class SignupLoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupLoginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    var isLoggingIn : Bool?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Helpers
    func scheduleReminders(){
        let reminders = RealmManager.shared.getReminders()
        for reminder in reminders{
            scheduleNotification(reminder: reminder)
        }
    }
    
    func setUpElements(){
//        errorLabel.alpha = 0
        self.navigationController?.navigationBar.isHidden = true
        StylingUtilities.styleTextField(emailTextField)
        StylingUtilities.styleTextField(passwordTextField)
        StylingUtilities.styleFilledButton(signupLoginButton)
        setLoading(false)
        if isLoggingIn!{
            signupLoginButton.setTitle("Login", for: .normal)
        }
        else{
            signupLoginButton.setTitle("Sign Up", for: .normal)
        }
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
        signupLoginButton.isEnabled = !loading
    }
    
    func login(){
        print("Log in as user: \(email!)")
        setLoading(true)
        app.login(credentials: Credentials.emailPassword(email: email!, password: password!)) { result in
            DispatchQueue.main.async {
                self.setLoading(false)
                switch result {
                case .failure(let error):
                    print("Login failed: \(error)")
                    self.errorLabel.text = "Login failed: \(error.localizedDescription)"
                    return
                case .success(let user):
                    print("Login succeeded!")
                    RealmManager.shared.saveCredentials(email: self.email!, password: self.password!)
                    self.setLoading(true)
                    var configuration = user.configuration(partitionValue: "user=\(user.id)")
                    configuration.objectTypes = [User.self, Reminder.self, Note.self, Injection.self, TSQM.self]
                    Realm.asyncOpen(configuration: configuration) { [weak self](result) in
                        DispatchQueue.main.async {
                            self!.setLoading(false)
                            switch result {
                            case .failure(let error):
                                fatalError("Failed to open realm: \(error)")
                            case .success(let userRealm):
                                RealmManager.shared.setRealm(realm: userRealm)
                                if RealmManager.shared.hasSignedConsent(realm: userRealm){
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let homeVC = storyboard.instantiateViewController(withIdentifier: "home") as! MainViewController
//                                    homeVC.userRealm = userRealm
                                    
                                    self?.scheduleReminders()
                                    self?.navigationController?.setViewControllers([homeVC], animated: true)
                                }
                                else{
                                    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                                    let destination = storyboard.instantiateViewController(withIdentifier: "consentVC") as! ConsentViewController
                                    destination.userRealm = userRealm

                                    self?.navigationController?.setViewControllers([destination], animated: true)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpLoginButtonTapped(_ sender: Any) {
        if isLoggingIn!{
            login()
        }
        else{
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
                    self!.login()
                }
            })
        }
    }
    
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "consent"{
            if let destination = segue.destination as ConsentViewController{
                destination.userRealm =
            }
        }
        // Pass the selected object to the new view controller.
    }*/
    

}

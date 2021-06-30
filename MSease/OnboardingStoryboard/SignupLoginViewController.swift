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
    
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Variables
    var isLoggingIn : Bool?
    var notificationToken: NotificationToken?
    var user : Results<User>?
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Initialization
    deinit {
        notificationToken?.invalidate()
    }
    
    // MARK: - Helpers
    func scheduleReminders(){
        let reminders = RealmManager.shared.getReminders()
        for reminder in reminders{
            scheduleNotification(reminder: reminder)
        }
    }
    
    func onProfileAddedToRealm(){
        self.setLoading(false)
        if RealmManager.shared.hasSignedConsent(){
            scheduleReminders()
            goToViewController(storyboardID: "Main", viewcontrollerID: "home")
        }
        else{
            goToViewController(storyboardID: "Onboarding", viewcontrollerID: "consentVC")
        }
    }
    
    /*func setUserObserver(){
        notificationToken = user!.observe { [weak self] (changes) in
            switch changes {
            case .initial:
                print("initial")
                if self!.user!.count > 0{
                    self!.onUserAddedToRealm()
                }
            case .update(_, _, _, _):
                self!.onUserAddedToRealm()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }*/
    
    func setUpElements(){
        StylingUtilities.styleQuestionnaireView(bgView)
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
    
    func onRealmOpened(_ realm: Realm){
//        user = realm.objects(User.self)
//        setUserObserver()
        RealmManager.shared.saveCredentials(email: self.email!, password: self.password!)
        RealmManager.shared.setRealm(realm: realm, handler:{
            RealmManager.shared.addProfile(email: self.email!, handler:{
                self.onProfileAddedToRealm()
            })
            /*if !self!.isLoggingIn!{
                RealmManager.shared.addUser(newUser: User(id: app.currentUser!.id, email: (self?.email!)!))
            }*/
        })
    }
    
    func onLogin(){
        let user = app.currentUser!
        let partitionValue = "user=\(user.id)"
        var configuration = user.configuration(partitionValue: partitionValue)
        configuration.objectTypes = RealmManager.OBJECT_TYPES
        self.setLoading(true)
        
        Realm.asyncOpen(configuration: configuration) { result in
            switch result {
            case .failure(let error):
                fatalError("Failed to open realm: \(error)")
            case .success(let userRealm):
                self.onRealmOpened(userRealm)
            }
        }
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
                    print(user.id)
                    self.onLogin()
                }
            }
        }
    }
    
    func goToViewController(storyboardID: String, viewcontrollerID: String){
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewcontrollerID)
        navigationController?.setViewControllers([vc], animated: true)
    }
    
    
    // MARK: - Actions
    
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

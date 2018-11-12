//
//  SignUpViewController.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import UIKit
import TransitionButton
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameField: MyTextField!
    @IBOutlet weak var lastNameField: MyTextField!
    @IBOutlet weak var mobileField: MyTextField!
    @IBOutlet weak var emailField: MyTextField!
    @IBOutlet weak var passwordField: MyTextField!
    
    @IBOutlet weak var signupButton: TransitionButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.signupButton.cornerRadius = self.signupButton.frame.height/2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        signupButton.startAnimation()
        var hasError = false
        if firstNameField.text == nil{
            firstNameField.errorMessage = "missing firstname"
            firstNameField.hasError = true
            hasError = true
        }
        if lastNameField.text == nil{
            lastNameField.errorMessage = "missing lastName"
            lastNameField.hasError = true
            hasError = true
        }
        if mobileField.text == nil {
            mobileField.errorMessage = "missing mobile number"
            mobileField.hasError = true
            hasError = true
        }
        if emailField.text == nil {
            emailField.errorMessage = "missing email"
            emailField.hasError = true
            hasError = true
        }
        if passwordField.text == nil {
            passwordField.errorMessage = "missing password"
            passwordField.hasError = true
            hasError = true
        }
        
        if hasError {
            self.signupButton.stopAnimation(animationStyle: .shake, completion: nil)
            return

        }
        let parameters: [String:String?] = [
            "firstName" : firstNameField.text,
            "lastName"  : lastNameField.text,
            "emailId"     : emailField.text,
            "password"  : passwordField.text,
            "mobile"    : mobileField.text
        ]
        
        // Both calls are equivalent
        Alamofire.request(Constants.registerURL, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default).responseJSON { (data) in 
            if let response = Response(data.result.value){
                if response.statusCode == 200 && response.success == true{
                    Authentication.shared.isLoggedIn = true
                    UserDefaults.standard.set(parameters, forKey: "UserDetails")
//                    Authentication.shared.fetchUserProfile()
                    self.signupButton.stopAnimation(animationStyle: .expand, completion: {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
//                            self.present(viewController, animated: true, completion: nil)
                            self.navigationController?.setViewControllers([viewController], animated: false)
                        }
                    })
                } else{
                    self.signupButton.stopAnimation(animationStyle: .shake, completion: nil)
                }
            } else{
                self.signupButton.stopAnimation(animationStyle: .shake, completion: nil)
            }
            print(data)
        }

    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
        let navCtrl = UINavigationController(rootViewController: viewController)
        navCtrl.modalTransitionStyle = .flipHorizontal
        self.navigationController?.present(navCtrl, animated: true, completion: nil)
                    }

    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            let navCtrl = UINavigationController(rootViewController: viewController)
            navCtrl.modalTransitionStyle = .flipHorizontal
            self.navigationController?.present(navCtrl, animated: true, completion: nil)
            
        }

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

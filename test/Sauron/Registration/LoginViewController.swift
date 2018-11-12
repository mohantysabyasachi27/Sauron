//
//  LoginViewController.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/9/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import UIKit
import TransitionButton
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: MyTextField!
    @IBOutlet weak var passwordField: MyTextField!
    @IBOutlet weak var loginButton: TransitionButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var skipButton: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.loginButton.cornerRadius = self.loginButton.frame.height/2
        // Do any additional setup after loading the view.
    }
        
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginButton.startAnimation()
        var hasError = false
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
            self.loginButton.stopAnimation(animationStyle: .shake, completion: nil)
            return
            
        }

        if let email = emailField.text, let password = passwordField.text{
            let parameters: [String:String?] = [
                "emailId"   : email
            ]
            Alamofire.request(Constants.loginURL, method: .post, parameters: ["username":email,"password":password])
                .responseJSON { data in
                    if let response = Response(data.result.value){
                        if response.statusCode == 200 && response.success == true{
                            Authentication.shared.isLoggedIn = true
                            UserDefaults.standard.set(parameters, forKey: "UserDetails")
                            UserDefaults.standard.set(email, forKey: "email")
//                            Authentication.shared.fetchUserProfile()
                            self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
//                                    self.present(viewController, animated: true, completion: nil)
//                                    UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: viewController)
                                    self.navigationController?.setViewControllers([viewController], animated: false)
                                }
                            })
                        } else{
                            self.loginButton.stopAnimation(animationStyle: .shake, completion: nil)
                        }
                    } else{
                        self.loginButton.stopAnimation(animationStyle: .shake, completion: nil)
                    }
                    debugPrint(data)
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
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
            self.navigationController?.present(navCtrl, animated: true, completion: nil)        }
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

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
        // Do any additional setup after loading the view.
    }
        
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginButton.startAnimation()
        if let email = emailField.text, let password = passwordField.text{
            let parameters: [String:String?] = [
                "emailId"   : emailField.text
            ]
            Alamofire.request(Constants.loginURL, method: .get)
                .authenticate(user: email, password: password)
                .responseJSON { data in
                    if let response = Response(data.result.value){
                        if response.statusCode == 200 && response.success == true{
                            self.loginButton.stopAnimation(animationStyle: .expand, completion: {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                                    self.present(viewController, animated: true, completion: nil)
                                    Authentication.shared.isLoggedIn = true
                                    UserDefaults.standard.set(parameters, forKey: "UserDetails")
                                    self.navigationController?.setViewControllers([viewController], animated: true)
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
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
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

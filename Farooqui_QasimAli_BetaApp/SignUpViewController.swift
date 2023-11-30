//
//  SignUpViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/30/23.
//

import UIKit

protocol signUpDelegate{
    func addUserFunction(name: String, password: String)
}

class SignUpViewController: UIViewController {
    
    var delegate: signUpDelegate?
    var userName: String?
    var userPass: String?
    
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var passInput: UITextField!
    @IBOutlet weak var confirmPassInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign Up"
        passInput.isSecureTextEntry = true // Set the password field to secure text entry
        confirmPassInput.isSecureTextEntry = true // Set the confirm password field to secure text entry

    }
    
    @IBAction func signUp(_ sender: Any) {
        if let userName = userNameInput.text, let password = passInput.text, let confirmPassword = confirmPassInput.text {
            
            // Validate username length
            if userName.count <= 15 {
                
                // Validate password length and format
                let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
                let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                
                if passwordPredicate.evaluate(with: password) {
                    
                    if password == confirmPassword {
                        self.userName = userName
                        self.userPass = password
                        
                        // Clear input fields
                        self.passInput.text = ""
                        self.confirmPassInput.text = ""
                        self.userNameInput.text = ""
                        
                        performSegue(withIdentifier: "signUpToUserView" , sender: self)
                    } else {
                        createAlert(title: "Password Mismatch!", msg: "Password and Confirm Password do not match")
                    }
                } else {
                    createAlert(title: "Invalid Password!", msg: "Password must be at least 8 characters with a capital letter and a number")
                }
            } else {
                createAlert(title: "Invalid Username!", msg: "Username must be no more than 15 characters")
            }
        } else {
            createAlert(title: "Missing Entry!", msg: "Missing Username, Password, or Confirm Password")
        }
    }
    
    func createAlert(title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpToUserView"{
            if let userNavigationController = segue.destination as? UINavigationController {
                let segueSignUpToUserView = userNavigationController.topViewController as? UserDonationViewController
                
               
            }
            //segueSignUpToWelcome.name = userName!
            delegate?.addUserFunction(name: userName!, password: userPass!)
        }
    }
    
    

}

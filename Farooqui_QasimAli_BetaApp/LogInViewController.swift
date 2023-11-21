//
//  LogInViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/30/23.
//

import UIKit

class LogInViewController: UIViewController, signUpDelegate {
    
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var passInput: UITextField!
    
    var userName:String?
    var userNamePassDict = ["admin":"admin", "qasim":"12345", "user": "user"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passInput.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToAdminView" {
            if let adminNavigationController = segue.destination as? UINavigationController {
                let adminTopViewController = adminNavigationController.topViewController as? ViewController
            }
        }
        if segue.identifier == "homeToUserView" {
            if let userNavigationController = segue.destination as? UINavigationController {
                let userTopViewController = userNavigationController.topViewController as? UserDonationViewController
            }
        }
        if segue.identifier == "homeToSignUp"{
            let segueSignUp = segue.destination as! SignUpViewController
            segueSignUp.delegate = self
        }
    }
    
    func createAlert(title: String, msg: String) {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    func addUserFunction(name: String, password: String) {
        userNamePassDict[name] = password
    }
    
    @IBAction func signIn(_ sender: Any) {

        guard let username = userNameInput.text, let password = passInput.text else {
                createAlert(title: "Missing Entry!", msg: "Missing User Name or Password")
                return
            }

            if let storedPassword = userNamePassDict[username], storedPassword == password, !password.isEmpty {
                // Successful login
                userName = username
                userNameInput.text = ""
                passInput.text = ""

                if username == "admin" || username == "qasim" {
                    performSegue(withIdentifier: "homeToAdminView", sender: self)
                } else {
                    performSegue(withIdentifier: "homeToUserView", sender: self)
                }
            } else {
                createAlert(title: "Invalid Entry!", msg: "Combination of User Name and Password is not valid")
            }
    }
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: "homeToSignUp", sender: self)
    }
    

}

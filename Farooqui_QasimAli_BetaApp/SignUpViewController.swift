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
    }
    
    @IBAction func signUp(_ sender: Any) {
        if (userNameInput.text?.count)! > 0 && (passInput.text?.count)! > 0 &&
            (confirmPassInput.text?.count)! > 0{
            if passInput.text == confirmPassInput.text{
                userName = self.userNameInput.text!
                userPass = self.passInput.text!
                self.passInput.text = ""
                self.confirmPassInput.text = ""
                self.userNameInput.text = ""
                
                performSegue(withIdentifier: "signUpToUserView" , sender: self)
                }
            else{
                createAlert(title: "Password Mismatch!", msg: "Password and Confirm Password does not match")
            }
        }
        else {
                   createAlert(title: "Missing Entry!", msg: "Missing UserName, Password, or Confirm Password")
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

//
//  UserAppealViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/30/23.
//

import UIKit
import CoreData

class UserAppealViewController: UIViewController {

    @IBOutlet weak var appealDesc: UITextField!
    @IBOutlet weak var appealAmount: UITextField!
    @IBOutlet weak var appealDate: UIDatePicker!
    
    var appeals:[Appeal] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAppeals()
        // Do any additional setup after loading the view.
    }
    
    //Add Appeal Button for new appeal for the appeal entity. Create the alert after adding

    @IBAction func addAppeal(_ sender: Any) {
        let newAppeal = Appeal(context: self.context)
        newAppeal.title = appealDesc.text!
        newAppeal.amount = Double(appealAmount.text!) ?? 0.0
        newAppeal.date = appealDate.date
        self.appeals.append(newAppeal)
        saveAppeals()
        
        createAlert(title:"Added Appeal",msg:"Your appeal has been successfully added!")

    }
    
    //Save bills into context and fetch the appeal object
    func saveAppeals(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        
    }
    
    func fetchAppeals(with request: NSFetchRequest<Appeal> = Appeal.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            appeals = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    //Create alert with Done button
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:nil))
        self.present(alert, animated: true, completion:nil)
    }

}

//
//  AddAppealViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/27/23.
//

import UIKit
import CoreData

protocol AddAppealDelegate: AnyObject {
    func didAddAppeal()
}

class AddAppealViewController: UIViewController {
    
    weak var delegate: AddAppealDelegate?

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
    
    @IBAction func addAppealButton(_ sender: Any) {
        
        // Validate description
        guard let description = appealDesc.text, !description.isEmpty, description.count <= 25 else {
            createAlert(title: "Invalid Description", msg: "Description should not be empty and should have at most 25 characters.")
            return
        }

        // Validate amount
        guard let amountStr = appealAmount.text, let amount = Double(amountStr), amount > 0, amount < 1000000 else {
            createAlert(title: "Invalid Amount", msg: "Amount should be a valid number greater than 0 and less than 1000000.")
            return
        }
        
        let newAppeal = Appeal(context: context)
        newAppeal.title = description
        newAppeal.amount = amount
        newAppeal.date = appealDate.date
        appeals.append(newAppeal)
        saveAppeals()

        delegate?.didAddAppeal()
        createAlert(title: "Added Appeal", msg: "Your appeal has been successfully added!")
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
    
    //Create alert with Done button and send back to income view controller
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{_ in self.dismiss(animated: true, completion:nil)}))
        super.viewDidLoad()
        self.present(alert, animated: true, completion:nil)
    }


}

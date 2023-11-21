//
//  AddInitiativeViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/27/23.
//

import UIKit
import CoreData

protocol AddInitiativeDelegate: AnyObject {
    func didAddInitiative()
}

class AddInitiativeViewController: UIViewController {
    
    weak var delegate: AddInitiativeDelegate?

    @IBOutlet weak var initiativeDesc: UITextField!
    @IBOutlet weak var initiativeAmount: UITextField!
    @IBOutlet weak var initiativeDate: UIDatePicker!
    
    var initiatives:[Initiative] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInitiatives()
        // Do any additional setup after loading the view.
    }
    
    //Add Initiative Button for new expense for the expense entity and also add it to the summary entity. Create the alert after adding
    @IBAction func addInitiativeButton(_ sender: Any) {
        
        // Validate description
        guard let description = initiativeDesc.text, !description.isEmpty, description.count <= 25 else {
            createAlert(title: "Invalid Description", msg: "Description should not be empty and should have at most 25 characters.")
            return
        }

        // Validate amount
        guard let amountStr = initiativeAmount.text, let amount = Double(amountStr), amount > 0, amount < 1000000 else {
            createAlert(title: "Invalid Amount", msg: "Amount should be a valid number greater than 0 and less than 1000000.")
            return
        }
        
        let newInitiative = Initiative(context: context)
        newInitiative.title = description
        newInitiative.amount = amount
        newInitiative.date = initiativeDate.date
        initiatives.append(newInitiative)
        saveInitiatives()

        delegate?.didAddInitiative()
        createAlert(title: "Added Initiative", msg: "Your initiative has been successfully added!")
    }

    
    //Save bills  into context and fetch the income object
    func saveInitiatives(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        
    }
    
    func fetchInitiatives(with request: NSFetchRequest<Initiative> = Initiative.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            initiatives = try context.fetch(request)
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

//
//  AddDonationsController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/23/23.
//

import UIKit
import CoreData

protocol AddDonationDelegate: AnyObject {
    func didAddDonation()
}

class AddDonationsController: UIViewController {
    
    weak var delegate: AddDonationDelegate?
    
    @IBOutlet weak var donationDesc: UITextField!
    @IBOutlet weak var donationAmount: UITextField!
    @IBOutlet weak var donationDate: UIDatePicker!
    
    
    var bills:[Donations] = []
    var summary:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        // Do any additional setup after loading the view.
    }
    
    //Add Income Button for new expense for the expense entity and also add it to the summary entity. Create the alert after adding
    
    @IBAction func addDonationButton(_ sender: Any) {
        
        // Validate description
        guard let description = donationDesc.text, !description.isEmpty, description.count <= 25 else {
            createAlert(title: "Invalid Description", msg: "Description should not be empty and should have at most 25 characters.")
            return
        }

        // Validate amount
        guard let amountStr = donationAmount.text, let amount = Double(amountStr), amount > 0, amount < 1000000 else {
            createAlert(title: "Invalid Amount", msg: "Amount should be a valid number greater than 0 and less than 1000000.")
            return
        }
        
        let newDonation = Donations(context: context)
        newDonation.title = description
        newDonation.amount = amount
        newDonation.date = donationDate.date
        bills.append(newDonation)
        saveBills()

        let newSummary = Summary(context: context)
        newSummary.title = description
        newSummary.amount = amount
        newSummary.date = donationDate.date
        summary.append(newSummary)
        saveSummary()

        delegate?.didAddDonation()
        createAlert(title: "Added Donation", msg: "Your donation has been successfully added!")
    }
    
    //Save bills  into context and fetch the income object
    func saveBills(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        
    }
    
    func fetchBills(with request: NSFetchRequest<Donations> = Donations.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    //Save into summary context and fetch the summary object and save it as well
    func saveSummary(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchSummary()
    }
    
    func fetchSummary(with request: NSFetchRequest<Summary> = Summary.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            summary = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    //Create alert with Done button and send back to income view controller
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{_ in self.dismiss(animated: true, completion:nil)
            
            }))
        self.present(alert, animated: true, completion:nil)
    }


}

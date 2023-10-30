//
//  UserDonationViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/30/23.
//

import UIKit
import CoreData

class UserDonationViewController: UIViewController {
    
    @IBOutlet weak var donationDesc: UITextField!
    @IBOutlet weak var donationAmount: UITextField!
    @IBOutlet weak var donationDate: UIDatePicker!
    
    var donations:[Donations] = []
    var summary:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDonations()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addDonation(_ sender: Any) {
        let newDonation = Donations(context: self.context)
        newDonation.title = donationDesc.text!
        newDonation.amount = Double(donationAmount.text!) ?? 0.0
        newDonation.date = donationDate.date
        self.donations.append(newDonation)
        saveDonations()
        
        let newSummary = Summary(context: self.context)
        newSummary.title = donationDesc.text!
        newSummary.amount = Double(donationAmount.text!) ?? 0.0
        newSummary.date = donationDate.date
        self.summary.append(newSummary)
        saveSummary()
        
        createAlert(title:"Added Donation",msg:"Your donation has been successfully added!")
    }
    
    //Save bills  into context and fetch the income object
    func saveDonations(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        
    }
    
    func fetchDonations(with request: NSFetchRequest<Donations> = Donations.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            donations = try context.fetch(request)
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
    
    //Create alert with Done button
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:nil))
        self.present(alert, animated: true, completion:nil)
    }

}

//
//  EditDonationViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 11/1/23.
//

import UIKit
import CoreData

class EditDonationViewController: UIViewController {
    
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    @IBOutlet weak var date1: UIDatePicker!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedDonation = Donations()
    var title2 = ""
    var amount2 = 0.00
    var date2 = Date()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedDonation.title
        amount1.text = "\(selectedDonation.amount)"
        date1.date = selectedDonation.date!
//
        // Do any additional setup after loading the view.
    }
    

    @IBAction func editButton(_ sender: Any) {
        changeMade()
    }
    
    func changeMade(){
        
        // Validate title
        guard let titleText = title1.text, !titleText.isEmpty, titleText.count <= 25 else {
            createAlert(title: "Invalid Title", msg: "Title should not be empty and should have at most 25 characters.")
            return
        }

        // Validate amount
        guard let amountText = amount1.text, let amountValue = Double(amountText), amountValue > 0, amountValue < 1000000 else {
            createAlert(title: "Invalid Amount", msg: "Amount should be a valid number greater than 0 and less than 1000000.")
            return
        }

        title2 = titleText
        amount2 = amountValue
        date2 = date1.date

        var bill = selectedDonation
        var fetchrequest: NSFetchRequest<Donations> = Donations.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "title = %@", selectedDonation.title!)
        let results = try? context.fetch(fetchrequest)
        if results?.count == 0 {
            bill = Donations(context: context)
        } else {
            bill = (results?.first)!
        }
        
        // Update the corresponding summary record
        var summary: Summary?
        let summaryFetchRequest: NSFetchRequest<Summary> = Summary.fetchRequest()
        summaryFetchRequest.predicate = NSPredicate(format: "title = %@", selectedDonation.title!)
        let summaryResults = try? context.fetch(summaryFetchRequest)
        
        if summaryResults?.count == 0 {
            // If summary record doesn't exist, create a new one
            summary = Summary(context: context)
            summary?.title = title2
        } else {
            // If summary record exists, update it
            summary = summaryResults?.first
        }
        
        bill.title = title2
        bill.amount = amount2
        bill.date = date2

        summary?.title = title2
        summary?.amount = amount2
        summary?.date = date2
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        createAlert(title: "Edited Donation", msg: "Your Donation has been successfully edited!")
}
    
    //Create alert with a Done button then send back to the Donations controller
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Done",style:.cancel,handler:{ (action: UIAlertAction!) in
            _=self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion:nil)}
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

//
//  AddExpenditureController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/23/23.
//

import UIKit
import CoreData

protocol AddExpenditureDelegate: AnyObject {
    func didAddExpenditure()
}

class AddExpenditureController: UIViewController {
    
    weak var delegate: AddExpenditureDelegate?
    
    @IBOutlet weak var expenseDesc: UITextField!
    @IBOutlet weak var expenditureAmount: UITextField!
    @IBOutlet weak var expenditureDate: UIDatePicker!
    
    //Created  object array to later change for expense and for overall summary, and the context
    var bills:[Expenditure] = []
    var summary:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBills()
        fetchSummary()
    }
    
    
    @IBAction func addExpenditureButton(_ sender: Any) {
        
        // Validate description
        guard let description = expenseDesc.text, !description.isEmpty, description.count <= 25 else {
            createAlert(title: "Invalid Description", msg: "Description should not be empty and should have at most 25 characters.")
            return
        }
        
        // Validate amount
        guard let amountStr = expenditureAmount.text, let amount = Double(amountStr), amount > 0, amount < 1000000 else {
            createAlert(title: "Invalid Amount", msg: "Amount should be a valid number greater than 0 and less than 1000000.")
            return
        }
        
        let newExpenditure = Expenditure(context: context)
        newExpenditure.title = description
        newExpenditure.amount = amount
        newExpenditure.type = "Expenditure"
        newExpenditure.date = expenditureDate.date
        bills.append(newExpenditure)
        saveBills()

        let newSummary = Summary(context: context)
        newSummary.title = description
        newSummary.type = "Expenditure"
        newSummary.amount = amount
        newSummary.date = expenditureDate.date
        summary.append(newSummary)
        saveSummary()
        
        delegate?.didAddExpenditure()
        createAlert(title: "Added Expenditure", msg: "Your expense has been successfully added!")
    }
    
    //Save the context expense in the core data

    func saveBills(){
        do {
                    try context.save()
                
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchBills()
        
    }
    //Fetch the expense context
    func fetchBills(with request: NSFetchRequest<Expenditure> = Expenditure.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            
        }catch{
            print(error)
        }
        
    }
//Save into summary entity for the home view
    func saveSummary(){
        do {
                    try context.save()
                } catch {
                    print("Error saving context \(error)")
                }
        self.fetchSummary()
    }
  //fetch the summary request entity
    func fetchSummary(with request: NSFetchRequest<Summary> = Summary.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
 
        do{
            summary = try context.fetch(request)
        }catch{
            print(error)
        }
    }
//create an alert for adding expense  and navigate back to the expense view
    func createAlert(title: String, msg:String){
        let alert = UIAlertController(title:title, message:msg,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                    //self.delegate?.didAddExpenditure()
                }))
        self.present(alert, animated: true, completion:nil)
    }


}

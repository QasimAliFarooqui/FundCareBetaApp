//
//  DonationsViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/23/23.
//

import UIKit
import CoreData

class DonationsViewController: UIViewController, AddDonationDelegate {

    //Create object variables and context and the reload data function
    var bills:[Donations] = []
    var selectedIn = Donations()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var totalDonations: UILabel!
    @IBOutlet weak var donationTable: UITableView!
    
    func reloadData(){
        fetchBills()
        DispatchQueue.main.async(execute:{self.donationTable.reloadData()})
    }
    
    //Implementing the delegate method.
    func didAddDonation() {
        DispatchQueue.main.async {
                self.viewDidLoad()
            }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "seg_donate_to_add" {
                if let addDonationController = segue.destination as? AddDonationsController {
                    // Set the delegate to self
                    addDonationController.delegate = self
                }
            }
            if segue.identifier == "donationToEdit"{
                let detailed_view = segue.destination as! EditDonationViewController
                detailed_view.selectedDonation = selectedIn
            }
    }
    
    
    //Self delegate and dataSource then update the donations amounts and texts
    override func viewDidLoad() {
        super.viewDidLoad()
        donationTable.delegate = self
        donationTable.dataSource = self
        fetchBills()
        donationTable.reloadData()
        var income = 0.0
        for incomeBill in bills {
            income += incomeBill.amount
        }
        totalDonations.text = "$\(round(income*100)/100)"
        self.donationTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    //Create override for viewDidAppear to reload data and fetch the expense from the core data
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        reloadData()
    }
    
    func fetchBills(with request: NSFetchRequest<Donations> = Donations.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            bills = try context.fetch(request)
            DispatchQueue.main.async{
                self.donationTable.reloadData()
            }
        }catch{
            print(error)
        }
    }

}

//Configure the tableView rows to the expense count and the size of the table cells to 100  then return it
extension DonationsViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bills.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //Return the incomeCell with the correct tags and labels, format the date and return the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "donationCell", for: indexPath)
        
            //cell.delegate = self
        let exp = cell.viewWithTag(7) as! UILabel
        let amount = cell.viewWithTag(9) as! UILabel
        let date = cell.viewWithTag(8) as! UILabel
        
        let expense = self.bills[indexPath.row]
        exp.text = expense.title
        amount.text = "+$\(round(expense.amount*100)/100)"
        amount.textColor = UIColor(red: 4/255.0, green: 128/255.0, blue: 49/255.0, alpha: 1)
        date.text = "\(expense.date!.formatted(date: .abbreviated, time: .omitted))"
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor(red: 244/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1);
        case 1:
            cell.backgroundColor = UIColor(red: 251/255.0, green: 251/255.0, blue: 254/255.0, alpha: 1);
        default:
            cell.backgroundColor = .white
        }
            return cell
        }
    
    //Delete cell when swiped to the left, delete from the core data and end the updates. Reload the data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       let expense = self.bills[indexPath.row]

       if editingStyle == UITableViewCell.EditingStyle.delete{
           donationTable.beginUpdates()
           context.delete(expense)
           
           // Next, find and delete the corresponding record from the Summary entity
           if let summaryToDelete = findSummaryRecordForExpense(expense) {
               context.delete(summaryToDelete)
           }
           
           //expenseTable.reloadData()
           do{
               try context.save()

               
           }catch {
               print("Error While deleting")
           }
           donationTable.endUpdates()
           //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
           self.viewDidLoad()

       }
   }
    
    func findSummaryRecordForExpense(_ expense: Donations) -> Summary? {
        // Implement a method to find the corresponding Summary record based on some criteria (e.g., matching attributes)
        // Return the Summary record if found, or nil if not found
        // You should implement this based on how you determine the correspondence between Expenditure and Summary records.
        // Example:
        if let title = expense.title {
            let fetchRequest: NSFetchRequest<Summary> = Summary.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            do {
                let results = try context.fetch(fetchRequest)
                return results.first
            } catch {
                print("Error fetching Summary record: \(error)")
            }
        }
        return nil
    }
    
   //perforn the segue for the table when a table is selected
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedIn = bills[indexPath.row]
       self.performSegue(withIdentifier: "donationToEdit", sender: self)
   }
    
    
}

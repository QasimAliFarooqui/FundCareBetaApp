//
//  ExpenditureViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/23/23.
//

import UIKit
import CoreData

class ExpenditureViewController: UIViewController {

    //Expense entity to change later and context
    var bills:[Expenditure]?
    var selectedBill = Expenditure()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    @IBOutlet weak var totalExpenditure: UILabel!
    @IBOutlet weak var expenditureTable: UITableView!
  
    //In the viewDidLoad the delegate and datasource are made to self. Reload the data and set expense to 0 while increasing amount. Set to keep the overall amounts up to date
    override func viewDidLoad() {
        super.viewDidLoad()
        expenditureTable.delegate = self
        expenditureTable.dataSource = self
        fetchBills()
        expenditureTable.reloadData()
        var expense = 0.0
        for expenseBill in bills! {
            expense += expenseBill.amount
        }
        totalExpenditure.text = "$\(round(expense*100)/100)"

        self.expenditureTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        // Do any additional setup after loading the view.
        //To Delete Everything in Expenses
        //for object in bills!{
           // context.delete(object)
       // }
        
        //do{
        //    try context.save()
       // }catch{}
    }
    //Reload the data for the expense table
    func reloadData(){
        fetchBills()
        DispatchQueue.main.async(execute:{self.expenditureTable.reloadData()})
    }
    
//    //Prepare the segue, send the current row to EditExpenseController and set the destination
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "ExpenseToEdit"{
//            let detailed_view = segue.destination as! EditExpenseViewController
//            detailed_view.selectedBill = selectedBill
//
//        }
//    }
    
    //viewDidAppear needed to refresh the view when changes are made and fetch the expense data and table
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        self.expenditureTable.reloadData()
    }

    func fetchBills(with request: NSFetchRequest<Expenditure> = Expenditure.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            
            bills = try context.fetch(request)
            DispatchQueue.main.async{
                self.expenditureTable.reloadData()
            }
        }catch{
            print(error)
        }
    }

}

//Make changes to the table including the size, amount of rows and cell specifications to change the different labels and changing the date format then return the cell
extension ExpenditureViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills!.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenditureCell", for: indexPath)
        let exp = cell.viewWithTag(4) as! UILabel
        let amount = cell.viewWithTag(6) as! UILabel
        let date = cell.viewWithTag(5) as! UILabel
        
        let expense = self.bills![indexPath.row]
        exp.text = expense.title
        amount.text = "-$\(expense.amount)"
        amount.textColor = UIColor(red: 191/255.0, green: 32/255.0, blue: 27/255.0, alpha: 1);
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

    //Delete function to swipe to the left then reload the table and core data then reload the data
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         var expense = self.bills![indexPath.row]


        if editingStyle == UITableViewCell.EditingStyle.delete{
            expenditureTable.beginUpdates()
            
            //self.expenditureTable.deleteRows(at: [indexPath], with: .automatic)
            
            context.delete(expense)
            
            // Next, find and delete the corresponding record from the Summary entity
            if let summaryToDelete = findSummaryRecordForExpense(expense) {
                context.delete(summaryToDelete)
            }

            //expenditureTable.reloadData()
            do{
                try context.save()

                
            }catch {
                print("Error While deleting")
            }
            expenditureTable.endUpdates()
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.viewDidLoad()

        }
    }
    
    func findSummaryRecordForExpense(_ expense: Expenditure) -> Summary? {
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
    
    
//    //perform the segue for row selected and send the row
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        selectedBill = bills![indexPath.row]
//        self.performSegue(withIdentifier: "ExpenseToEdit", sender: self)
//
//    }
}

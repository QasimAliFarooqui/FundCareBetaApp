//
//  ViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/23/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var totalSummaryTable: UITableView!
    @IBOutlet weak var expenditureAmount: UILabel!
    @IBOutlet weak var currentDonationAmount: UILabel!
    @IBOutlet weak var donationAmount: UILabel!
    
    var expenditureBills:[Expenditure] = []
    var donationBills:[Donations] = []
    var totalSummaryBills:[Summary] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Reload the screen when it's called
    func reloadData(){
        fetchExpenditureBills()
        fetchDonations()
        fetchSummary()
        DispatchQueue.main.async(execute:{self.totalSummaryTable.reloadData()})
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        totalSummaryTable.delegate = self
        totalSummaryTable.dataSource = self
        
        // Fetch expense, income and summary records
        
        fetchExpenditureBills()
        fetchDonations()
        fetchSummary()
        totalSummaryTable.reloadData()
        
        // calculate total expenditure and total donations to be displayed
        
        var totalDonation = 0.0
        for donationBill in donationBills {
            totalDonation += donationBill.amount
        }
        
        var totalExpenditure = 0.0
        for bill in expenditureBills {
            totalExpenditure += bill.amount
        }
        
        currentDonationAmount.text = "$\(round((totalDonation-totalExpenditure)*100)/100)"
        expenditureAmount.text = "$\(round(totalExpenditure*100)/100)"
        donationAmount.text = "$\(round(totalDonation*100)/100)"
        self.totalSummaryTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        reloadData()
    }
    
    // fetch expenses
    func fetchExpenditureBills(with request: NSFetchRequest<Expenditure> = Expenditure.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            expenditureBills = try context.fetch(request)
            //print(bills[7].title)
        }catch{
            print(error)
        }
    }
    
    // fetch income

    func fetchDonations(with request: NSFetchRequest<Donations> = Donations.fetchRequest()){
        do{
            donationBills = try context.fetch(request)

        }catch{
            print(error)
        }
    }
    
    // fetch account summary
    
    func fetchSummary(with request: NSFetchRequest<Summary> = Summary.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            totalSummaryBills = try context.fetch(request)
            totalSummaryBills.sort(by: { $0.date! > $1.date! })

            DispatchQueue.main.async{
                self.totalSummaryTable.reloadData()
            }
            //print(bills[7].title)
        }catch{
            print(error)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return totalSummaryBills.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath)
        
        let exp = cell.viewWithTag(10) as! UILabel
        let amount = cell.viewWithTag(11) as! UILabel
        let date = cell.viewWithTag(12) as! UILabel
        
        // set appropriate values to tableview labels
        
        let expense = self.totalSummaryBills[indexPath.row]
        exp.text = expense.title
        
        date.text = "\(expense.date!.formatted(date: .abbreviated, time: .omitted))"
        

        //set amount to be displayed in green for donations and red for expenditure records

        if expense.type == "Expenditure"{
            amount.textColor = UIColor(red: 191/255.0, green: 32/255.0, blue: 27/255.0, alpha: 1);
            amount.text = "-$\(expense.amount)"
        }
        else{
            amount.textColor = UIColor(red: 4/255.0, green: 128/255.0, blue: 49/255.0, alpha: 1)
            amount.text = "+$\(expense.amount)"
        }
        
        //No color feature
        //amount.text = "$\(expense.amount)"
        
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
    
  // fucntion to edit records

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let expense = self.totalSummaryBills[indexPath.row]

        if editingStyle == UITableViewCell.EditingStyle.delete{
            totalSummaryTable.beginUpdates()
            context.delete(expense)
            //expenseTable.reloadData()
            do{
                try context.save()
                reloadData()
                totalSummaryTable.reloadData()
                //self.expenseTable.deleteRows(at: [indexPath], with: .automatic)
                
            }catch {
                print("Error While deleting")
            }
            totalSummaryTable.endUpdates()
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            

        }
    }
    

}

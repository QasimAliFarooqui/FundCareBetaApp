//
//  AppealViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/26/23.
//

import UIKit
import CoreData

class AppealViewController: UIViewController, AddAppealDelegate {

    //Create object variables and context and the reload data function
    var appeals:[Appeal] = []
    var selectedIn = Appeal()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var totalAppeals: UILabel!
    @IBOutlet weak var appealTable: UITableView!
    
    func reloadData(){
        fetchAppeals()
        DispatchQueue.main.async(execute:{self.appealTable.reloadData()})
    }
    
    //Prepare the segue to IncomeToEdit for editing rows
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "IncomeToEdit"{
//            let detailed_view = segue.destination as! EditIncomeController
//            detailed_view.selectedBill = selectedIn
//
//        }
//    }
    
    //Implementing the delegate method.
    func didAddAppeal() {
        DispatchQueue.main.async {
            self.viewDidLoad()
            }
       }
    
    //Self delegate and dataSource then update the income amounts and texts
    override func viewDidLoad() {
        super.viewDidLoad()
        appealTable.delegate = self
        appealTable.dataSource = self
        fetchAppeals()
        appealTable.reloadData()
        var appeal = 0.0
        for appealBill in appeals {
            appeal += appealBill.amount
        }
        totalAppeals.text = "$\(round(appeal*100)/100)"
        self.appealTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // Do any additional setup after loading the view.
        
        
        //To Delete Everything in Expenses
        
        //for object in bills!{
           // context.delete(object)
       // }
        
        //do{
        //    try context.save()
       // }catch{}
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "seg_appeal_to_add" {
                if let addAppealController = segue.destination as? AddAppealViewController {
                    // Set the delegate to self
                    addAppealController.delegate = self
                }
            }
        if segue.identifier == "appealToEdit"{
                let detailed_view = segue.destination as! EditAppealViewController
                detailed_view.selectedAppeal = selectedIn
    
        }
    }
    
    //Create override for viewDidAppear to reload data and fetch the expense from the core data
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        reloadData()
    }
    
    func fetchAppeals(with request: NSFetchRequest<Appeal> = Appeal.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            appeals = try context.fetch(request)
            DispatchQueue.main.async{
                self.appealTable.reloadData()
            }
        }catch{
            print(error)
        }
    }

}

//Configure the tableView rows to the expense count and the size of the table cells to 100  then return it
extension AppealViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return appeals.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    //Return the incomeCell with the correct tags and labels, format the date and return the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "appealCell", for: indexPath)
        
            //cell.delegate = self
        let appealDesc = cell.viewWithTag(13) as! UILabel
        let amount = cell.viewWithTag(14) as! UILabel
        let date = cell.viewWithTag(15) as! UILabel
        
        let appeal = self.appeals[indexPath.row]
        appealDesc.text = appeal.title
        amount.text = "+$\(round(appeal.amount*100)/100)"
        amount.textColor = UIColor(red: 4/255.0, green: 128/255.0, blue: 49/255.0, alpha: 1)
        date.text = "\(appeal.date!.formatted(date: .abbreviated, time: .omitted))"
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
       let appeal = self.appeals[indexPath.row]

       if editingStyle == UITableViewCell.EditingStyle.delete{
           appealTable.beginUpdates()
           context.delete(appeal)
           //expenseTable.reloadData()
           do{
               try context.save()

               
           }catch {
               print("Error While deleting")
           }
           appealTable.endUpdates()
           //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
           self.viewDidLoad()

       }
   }
    
   //perforn the segue for the table when a table is selected
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       selectedIn = appeals[indexPath.row]
       self.performSegue(withIdentifier: "appealToEdit", sender: self)
   }
    
    
}

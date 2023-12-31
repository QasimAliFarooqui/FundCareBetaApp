//
//  InitiativeViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/27/23.
//

import UIKit
import CoreData

class InitiativeViewController: UIViewController, AddInitiativeDelegate {
    
    //Create object variables and context and the reload data function
    var initiatives:[Initiative] = []
    var selectedIn = Initiative()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var totalInitiatives: UILabel!
    @IBOutlet weak var initiativeTable: UITableView!
    
    func reloadData(){
        fetchInitiatives()
        DispatchQueue.main.async(execute:{self.initiativeTable.reloadData()})
    }
    
    //Implementing the delegate method
    func didAddInitiative() {
        DispatchQueue.main.async {
            self.viewDidLoad()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg_initiative_to_add" {
            if let addInitiativeController = segue.destination as?
                AddInitiativeViewController {
                //Set delegate to self
                addInitiativeController.delegate = self
            }
        }
        if segue.identifier == "initiativeToEdit"{
                    let detailed_view = segue.destination as! EditInitiativeViewController
                    detailed_view.selectedInitiative = selectedIn
        
                }
    }
    
    //Self delegate and dataSource then update the income amounts and texts
    override func viewDidLoad() {
        super.viewDidLoad()
        initiativeTable.delegate = self
        initiativeTable.dataSource = self
        fetchInitiatives()
        initiativeTable.reloadData()
        var initiative = 0.0
        for initiativeBill in initiatives {
            initiative += initiativeBill.amount
        }
        totalInitiatives.text = "$\(round(initiative*100)/100)"
        self.initiativeTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
    }
    //Create override for viewDidAppear to reload data and fetch the expense from the core data
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
        reloadData()
    }
    
    func fetchInitiatives(with request: NSFetchRequest<Initiative> = Initiative.fetchRequest()){
        //Fetch the data from Core Data to displau in the tableview
        //context.
        do{
            initiatives = try context.fetch(request)
            DispatchQueue.main.async{
                self.initiativeTable.reloadData()
            }
        }catch{
            print(error)
        }
    }

}

//Configure the tableView rows to the expense count and the size of the table cells to 100  then return it
extension InitiativeViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return initiatives.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //Return the initiativeCell with the correct tags and labels, format the date and return the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "initiativeCell", for: indexPath)
        
            //cell.delegate = self
        let initiativeDesc = cell.viewWithTag(1) as! UILabel
        let amount = cell.viewWithTag(2) as! UILabel
        let date = cell.viewWithTag(3) as! UILabel
        
        let initiative = self.initiatives[indexPath.row]
        initiativeDesc.text = initiative.title
        amount.text = "+$\(round(initiative.amount*100)/100)"
        amount.textColor = UIColor(red: 4/255.0, green: 128/255.0, blue: 49/255.0, alpha: 1)
        date.text = "\(initiative.date!.formatted(date: .abbreviated, time: .omitted))"
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
       let initiative = self.initiatives[indexPath.row]

       if editingStyle == UITableViewCell.EditingStyle.delete{
           initiativeTable.beginUpdates()
           context.delete(initiative)
           do{
               try context.save()

               
           }catch {
               print("Error While deleting")
           }
           initiativeTable.endUpdates()
           //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
           self.viewDidLoad()

       }
   }
    
   //perforn the segue for the table when a table is selected
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       selectedIn = initiatives[indexPath.row]
       self.performSegue(withIdentifier: "initiativeToEdit", sender: self)
   }
    
    
}

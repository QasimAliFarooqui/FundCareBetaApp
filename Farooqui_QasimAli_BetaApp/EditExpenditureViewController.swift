//
//  EditExpenditureViewController.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 11/1/23.
//

import UIKit
import CoreData

class EditExpenditureViewController: UIViewController {
    
    @IBOutlet weak var title1: UITextField!
    @IBOutlet weak var amount1: UITextField!
    @IBOutlet weak var date1: UIDatePicker!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBill = Expenditure()
    var title2 = ""
    var amount2 = 0.00
    var date2 = Date()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title1.text = selectedBill.title
        amount1.text = "\(selectedBill.amount)"
        date1.date = selectedBill.date!
//
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editButton(_ sender: Any) {
        changeMade()
    }
    
    func changeMade(){
        title2 = title1.text!
        amount2 = Double(amount1.text!)!
        date2 = date1.date
        
        var bill = selectedBill
        var fetchrequest: NSFetchRequest<Expenditure> = Expenditure.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "title = %@",selectedBill.title!)
        let results = try? context.fetch(fetchrequest)
        if results?.count == 0{
            bill = Expenditure(context: context)
        }else{
            bill = (results?.first)!
        }
        
        bill.title = title2
        bill.amount = amount2
        bill.date = date2
        do{
        try context.save()
        }catch{}
        createAlert(title:"Editted Expenditure",msg:"Your expenditure has been successfully editted!")


    }
    //Create alert with a Done button then send back to the Expenditure controller
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

//
//  AppDelegate.swift
//  Farooqui_QasimAli_BetaApp
//
//  Created by Qasim Ali Farooqui on 10/23/23.
//

import UIKit
import CoreData


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        addSampleDonationsIfNeeded()
        addSampleExpendituresIfNeeded()
        addSampleInitiativesIfNeeded()
        addSampleAppealsIfNeeded()
        return true
    }
    
    func addSampleDonationsIfNeeded() {
        // Check if sample donations exist
        if !sampleDonationsExist() {
            // Add sample donations
            addSampleDonations()
        }
    }

    func sampleDonationsExist() -> Bool {
        let fetchRequest: NSFetchRequest<Donations> = Donations.fetchRequest()

        do {
            let count = try persistentContainer.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for sample donations: \(error)")
            return false
        }
    }

    func addSampleDonations() {
        for i in 1...5 {
            let newDonation = Donations(context: persistentContainer.viewContext)
            // Set properties for the new donation
            newDonation.title = "Sample Donation \(i)"
            newDonation.amount = Double(Int.random(in: 100...2000))
            newDonation.date = Date()
            // ... Set other properties

            // Save the donation context
            saveContext()

            // Update or create the corresponding summary record
            updateSummaryForDonation(newDonation)
        }
    }

    func updateSummaryForDonation(_ donation: Donations) {
        let summaryFetchRequest: NSFetchRequest<Summary> = Summary.fetchRequest()
        summaryFetchRequest.predicate = NSPredicate(format: "title = %@", donation.title!)

        do {
            let results = try persistentContainer.viewContext.fetch(summaryFetchRequest)

            if let summary = results.first {
                // Update existing summary record
                summary.amount += donation.amount
                summary.date = donation.date
            } else {
                // Create new summary record
                let newSummary = Summary(context: persistentContainer.viewContext)
                newSummary.title = donation.title
                newSummary.amount = donation.amount
                newSummary.date = donation.date
                // ... Set other properties for summary

                // Save the summary context
                saveContext()
            }
        } catch {
            print("Error updating summary: \(error)")
        }
    }
    
    func addSampleExpendituresIfNeeded() {
        // Check if sample expenditures exist
        if !sampleExpendituresExist() {
            // Add sample expenditures
            addSampleExpenditures()
        }
    }

    func sampleExpendituresExist() -> Bool {
        let fetchRequest: NSFetchRequest<Expenditure> = Expenditure.fetchRequest()

        do {
            let count = try persistentContainer.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for sample expenditures: \(error)")
            return false
        }
    }

    func addSampleExpenditures() {
        for i in 1...5 {
            let newExpenditure = Expenditure(context: persistentContainer.viewContext)
            // Set properties for the new expenditure
            newExpenditure.title = "Sample Expenditure \(i)"
            newExpenditure.amount = Double(Int.random(in: 100...1900))
            newExpenditure.date = Date()
            newExpenditure.type = "Expenditure"
            // ... Set other properties

            // Save the expenditure context
            saveContext()

            // Update or create the corresponding summary record
            updateSummaryForExpenditure(newExpenditure)
        }
    }

    func updateSummaryForExpenditure(_ expenditure: Expenditure) {
        let summaryFetchRequest: NSFetchRequest<Summary> = Summary.fetchRequest()
        summaryFetchRequest.predicate = NSPredicate(format: "title = %@", expenditure.title!)

        do {
            let results = try persistentContainer.viewContext.fetch(summaryFetchRequest)

            if let summary = results.first {
                // Update existing summary record
                summary.amount -= expenditure.amount
                summary.date = expenditure.date
            } else {
                // Create new summary record
                let newSummary = Summary(context: persistentContainer.viewContext)
                newSummary.title = expenditure.title
                newSummary.amount = -expenditure.amount
                newSummary.date = expenditure.date
                newSummary.type = "Expenditure"
                // ... Set other properties for summary

                // Save the summary context
                saveContext()
            }
        } catch {
            print("Error updating summary: \(error)")
        }
    }
    
    func addSampleInitiativesIfNeeded() {
        // Check if sample initiatives exist
        if !sampleInitiativesExist() {
            // Add sample initiatives
            addSampleInitiatives()
        }
    }

    func sampleInitiativesExist() -> Bool {
        let fetchRequest: NSFetchRequest<Initiative> = Initiative.fetchRequest()

        do {
            let count = try persistentContainer.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for sample initiatives: \(error)")
            return false
        }
    }

    func addSampleInitiatives() {
        for i in 1...5 {
            let newInitiative = Initiative(context: persistentContainer.viewContext)
            // Set properties for the new initiative
            newInitiative.title = "Sample Initiative \(i)"
            newInitiative.amount = Double(Int.random(in: 100...1000))
            newInitiative.date = Date()
            // ... Set other properties

            // Save the initiative context
            saveContext()

        }
    }
    
    func addSampleAppealsIfNeeded() {
        // Check if sample appeals exist
        if !sampleAppealsExist() {
            // Add sample appeals
            addSampleAppeals()
        }
    }

    func sampleAppealsExist() -> Bool {
        let fetchRequest: NSFetchRequest<Appeal> = Appeal.fetchRequest()

        do {
            let count = try persistentContainer.viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for sample appeals: \(error)")
            return false
        }
    }

    func addSampleAppeals() {
        for i in 1...5 {
            let newAppeal = Appeal(context: persistentContainer.viewContext)
            // Set properties for the new appeal
            newAppeal.title = "Sample Appeal \(i)"
            newAppeal.amount = Double(Int.random(in: 100...1000))
            newAppeal.date = Date()
            // ... Set other properties

            // Save the appeal context
            saveContext()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FundCare")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

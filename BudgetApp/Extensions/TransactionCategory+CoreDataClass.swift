//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Yernazar on 12/20/22.
//

import Foundation
import CoreData


@objc(Transaction)
public class Transaction: NSManagedObject {
 
    public override func awakeFromInsert() {
        self.dateCreated = Date() 
    }
    
    static func byBudgetCategory(_ budget: BudgetCategory) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "category = %@", budget)
        return request
    }
}

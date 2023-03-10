//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Yernazar on 12/20/22.
//

import SwiftUI
import CoreData

struct TransactionListView: View {
    
    @FetchRequest var transactions: FetchedResults<Transaction>
    let onDelete: (Transaction) -> Void
    
    init(request: NSFetchRequest<Transaction>, onDelete: @escaping (Transaction) -> Void) {
        _transactions = FetchRequest(fetchRequest: request)
        self.onDelete = onDelete
    }
    
    var body: some View {
        let _ = print(Self._printChanges())
        
        if transactions.isEmpty {
            Text("No transactions.")
        } else {
//            типа лист всех транзакции там текст, HStack дегендерди озгерте аласын
            List {
                ForEach(transactions) { transaction in
                    HStack {
                        Text(transaction.name ?? "")
                        Spacer()
                        Text(transaction.total.formatAsCurrency())
                    }
                }.onDelete { offsets in
                    offsets.map { transactions[$0] }.forEach(onDelete)
                }
            }
        }
        
        
    }
}


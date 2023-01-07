//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Yernazar on 12/20/22.
//

import SwiftUI
import Firebase

enum Route: Hashable {
    case detail(BudgetCategory)
}

@main
struct BudgetAppApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .navigationDestination(for: Route.self, destination: { route in
                        switch route {
                        case .detail(let budgetCategory):
                            BudgetDetailView(budgetCategory: budgetCategory)
                        }
                    })
            }
            .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        }
    }
}

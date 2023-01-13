//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Yernazar on 12/20/22.
//

import SwiftUI
import Firebase

final class AppDelegate: NSObject,UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

enum Route: Hashable {
    case detail(BudgetCategory)
}

@main
struct BudgetAppApp: App {
    @StateObject var dataManager = DataManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var sessionService = SessionServiceImpl()
    var body: some Scene {
        
        WindowGroup {
//            UsersListView()
//                .environmentObject(dataManager)
                
            NavigationStack {
                ContentView()
                    .navigationDestination(for: Route.self, destination: { route in
                        switch route {
                        case .detail(let budgetCategory):
                            BudgetDetailView(budgetCategory: budgetCategory)
                        }
                    })
                    .environmentObject(dataManager)
            }
            .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
            
        }
    }
}

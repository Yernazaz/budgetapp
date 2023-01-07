//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Yernazar on 12/20/22.
//


import SwiftUI
import Firebase


enum SheetAction: Identifiable {
    
    var id: UUID {
        UUID()
    }
    
    case add
    case edit(BudgetCategory)
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: BudgetCategory.all) var budgetCategoryResults
    @State private var sheetAction: SheetAction?
    @State private var email = ""
    @State private var password = ""
    @State private var userIsloggedIn = false
    
    
    var total: Double {
        budgetCategoryResults.reduce(0) { result, budgetCategory in
            return result + budgetCategory.total
        }
    }
    
    var body: some View {
        if userIsloggedIn{
            let _ = print(Self._printChanges())
            
            Text(total as NSNumber, formatter: NumberFormatter.currency)
                .fontWeight(.bold)
            BudgetListView(budgetCategoryResults: budgetCategoryResults) { category in
                sheetAction = .edit(category)
            } onDelete: { category in
                viewContext.delete(category)
                do {
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
            .listStyle(.plain)
            .sheet(item: $sheetAction, content: { sheetAction in
                switch sheetAction {
                case .add:
                    AddBudgetCategoryView()
                case .edit(let category):
                    AddBudgetCategoryView(budgetCategoryToEdit: category)
                }
            })
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: CurrencyConverter()){
                        Text("Converter")
                    }
                }
                
                ToolbarItem() {
                    Button{
                        logout()
                        Auth.auth().addStateDidChangeListener{auth, user in
                            if user == nil{
                                userIsloggedIn.toggle()
                            }
                        }
                    }label: {
                        Text("out")
                            .padding(5.0)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Add Category") {
                        sheetAction = .add
                    }
                }
            }
            
        } else {
            content
        }
    }
    
    
    var content: some View {
        ZStack{
            VStack{
                Text("Welcome")
                TextField("Email", text: $email)
                    .frame(height: 50.0)
                    .foregroundColor(.blue)
                SecureField("Password", text:  $password)
                    .frame(height: 50.0)
                Button{
                    register()
                    Auth.auth().addStateDidChangeListener{auth, user in
                        if user != nil{
                            userIsloggedIn.toggle()
                        }
                    }
                }label: {
                    Text("Sign up")
                        .padding(5.0)
                }
                
                Button{
                    login()
                    Auth.auth().addStateDidChangeListener{auth, user in
                        if user != nil{
                            userIsloggedIn.toggle()
                        }
                    }
                }label: {
                    Text("Login")
                        .padding(9.0)
                }
            }
            .onAppear{
                Auth.auth().addStateDidChangeListener{auth, user in
                    if user != nil{
                        userIsloggedIn.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
    
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
        }
    }
    
    func logout(){
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
       } catch let signOutError as NSError {
         print("Error signing out: %@", signOutError)
       }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView().environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        }
    }
}

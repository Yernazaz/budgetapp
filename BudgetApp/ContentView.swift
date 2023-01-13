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
    
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: BudgetCategory.all) var budgetCategoryResults
    @State private var sheetAction: SheetAction?
    @State private var email = ""
    @State private var password = ""
    @State private var userIsloggedIn = false
    private var useremail: String? {
        return Auth.auth().currentUser?.email
    }
    private var userid: String? {
        return Auth.auth().currentUser?.uid
    }
    
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
//            это уже отдельный файл BudgetListView деген сонын ишинен карап озгертесин
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
//            всплывающее окно
            .sheet(item: $sheetAction, content: { sheetAction in
                switch sheetAction {
                case .add:
//                    тоже отдельный файл AddBudgetCategoryView
                    AddBudgetCategoryView()
                case .edit(let category):
                    AddBudgetCategoryView(budgetCategoryToEdit: category)
                }
            })
//            навбар сверху
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: CurrencyConverter()){
                        Text("Converter")
                    }
                }
                
                
                ToolbarItem( ) {
                    
                    Button("Add Category") {
                        sheetAction = .add
                    }
                }
                
                
                if userid == "qzBKyRM2KQYGCccMnsvtJjSjtNF3"{
                    ToolbarItem() {
                        NavigationLink(destination: UsersListView()
                                                    .environmentObject(dataManager)){
                            Text("List of Users")
                        }
                    }
                }
                
                
                ToolbarItem() {
                    NavigationLink(destination: AddComment()
                                                .environmentObject(dataManager)){
                        Text("Comments")
                    }
                }
                
                ToolbarItem() {
                    NavigationLink(destination: UserProfile()
                                                .environmentObject(dataManager)){
                        Text(email)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        logout()
                        Auth.auth().addStateDidChangeListener{auth, user in
                            if user == nil{
                                userIsloggedIn.toggle()
                            }
                        }
                    }label: {
                        Text("Log out")
                            .padding(5.0)
                    }
                    
                }
            }
            
        } else {
            content
        }
    }
    
//    conten чисто для логин регистрации
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
            dataManager.addUser(userEmail: email, userId: result?.user.uid ?? "")
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

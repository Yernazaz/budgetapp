//
//  SessionService.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 13.01.2023.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseDatabase
    
enum SessionState {
    case loggenIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func logout(){
        
    }
}

private extension SessionServiceImpl{
    
    func setupFirebaseAuthHandler(){
        handler = Auth
            .auth()
            .addStateDidChangeListener{[weak self] res, user in
                guard let self = self else {return}
                self.state = user == nil ? .loggedOut : .loggenIn
                if let uid = user?.uid{
                    self.handleRefresh(with: uid)
                }
            }
    }
    
    func handleRefresh(with uid: String) {
        
        Database
            .database()
            .reference()
            .child("users")
            .child(uid)
            .observe(.value) { [weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? NSDictionary,
                      let firstName = value[RegistrationKeys.firstName.rawValue] as? String,
                      let lastName = value[RegistrationKeys.lastName.rawValue] as? String,
                      let age = value[RegistrationKeys.age.rawValue] as? String else{
                    return
                }
                
                DispatchQueue.main.async {
                    self.userDetails = SessionUserDetails(firstName: firstName, lastName: lastName, age: age)
                }
                
            }
    }
    
}




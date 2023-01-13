//
//  DataManager.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 13.01.2023.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var userslist: [User] = []
    @Published var comment: [Comments] = []
    private var userid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    init() {
        fetchUsers()
    }
    
    
    func fetchUsers() {
        userslist.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("UsersList")
        ref.getDocuments { snapshot,error in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot{
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    
                    let user = User(id: id, email: email)
                    self.userslist.append(user)
                }
            }
            
        }
    }
    
    func addUser(userEmail: String, userId: String){
        let db = Firestore.firestore()
        let ref = db.collection("UsersList").document(userId)
        ref.setData(["id":userId, "email": userEmail]){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchComments(userId: String){
        comment.removeAll()
        let db = Firestore.firestore()
        
//        db.collection("Comments").whereField("id", isEqualTo: userId)
//            .getDocument() { (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
//                } else {
//                    print("Document does not exist")
//                }
//            }
        
        db.collection("Comments").whereField("id", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let id = data["id"] as? String ?? ""
                        let comment = data["comment"] as? String ?? ""

                        let comma = Comments(id: id, comment: comment)
                        self.comment.append(comma)
                    }
                }
        }
    }
    
    func addComment(userComment: String, userId: String){
        let db = Firestore.firestore()
        let ref = db.collection("Comments").document(userId)
        ref.setData(["id":userId, "comment": userComment]){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func setpass(){
        Auth.auth().currentUser?.updatePassword(to: "Aitu2021!") { error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(){
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
              print(error.localizedDescription)
          } else {
              Auth.auth().addStateDidChangeListener{auth, user in
                  if user != nil{
                      ContentView()
                  }
              }
          }
        }
    }
}

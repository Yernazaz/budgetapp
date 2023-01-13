//
//  AddComment.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 13.01.2023.
//

import SwiftUI
import Firebase

struct AddComment: View {
    @EnvironmentObject var dataManager: DataManager
    private var userid: String? {
        return Auth.auth().currentUser?.uid
    }
    @State private var comment = ""
    
    var body: some View {
        
        NavigationView{
            List(dataManager.comment, id: \.id){com in
                Text(com.comment)
            }
            .navigationTitle("Comment")
        }.onAppear{
            dataManager.fetchComments(userId: userid ?? "")
        }
//        List(dataManager.comment){comma in
//        Text(dataManager.comment)
                
//        }

        
        TextField("Write text there", text: $comment )
            .frame(height: 200.0)
            .foregroundColor(.blue)
        Button("Sumbit", action: {
            dataManager.addComment(userComment: comment, userId: userid ?? "")
        })
    }
}

struct AddComment_Previews: PreviewProvider {
    static var previews: some View {
        AddComment()
    }
}

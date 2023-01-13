//
//  UserProfile.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 13.01.2023.
//

import SwiftUI
import Firebase

struct UserProfile: View {
    @EnvironmentObject var dataManager: DataManager
    private var useremail: String? {
        return Auth.auth().currentUser?.email
    }
    private var userid: String? {
        return Auth.auth().currentUser?.uid
    }
    var body: some View {
        VStack{
            Text("ID:")
            Text(userid ?? "")
            Text("Email:")
            Text(useremail ?? "")
            
            Button("Reset Password to Aitu2021!", action: {
                dataManager.setpass()
            })
            
            Button("Delete profile", action: {
                dataManager.delete()
            })
        
        }
        
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}

//
//  UsersListView.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 13.01.2023.
//

import SwiftUI

struct UsersListView: View {
    @EnvironmentObject var dataManager: DataManager
    var body: some View {
//        лист всех пользователей admin@admin.com Aitu2021!
        NavigationView{
            List(dataManager.userslist, id: \.id){user in
                Text(user.email)
            }
            .navigationTitle("Users")
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}

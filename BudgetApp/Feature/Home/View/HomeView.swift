//
//  HomeView.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 12.01.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            VStack(alignment: .leading, spacing: 16){
                Text("First Name: ")
                Text("Second Name: ")
                Text("Age: ")
            }
            ButtonView(title: "Logout"){
                
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Main")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .environmentObject(SessionServiceImpl())
        }
    }
}

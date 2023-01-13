//
//  ForgotPassword.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 12.01.2023.
//

import SwiftUI

struct ForgotPassword: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            
            VStack(spacing: 16){
                InputTextFieldView(text: .constant(""), placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                
                ButtonView(title: "Send Password to Email"){
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal,15)
            .navigationTitle("Reset Password")
            .applyClose()

        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}

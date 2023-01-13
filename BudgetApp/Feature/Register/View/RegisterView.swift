//
//  RegisterView.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 12.01.2023.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = RegistrationViewModelImp1(service: RegistrationServiceImp1())
    
    var body: some View {
        NavigationView{
            VStack(spacing: 32){
                VStack(spacing: 16){
                    InputTextFieldView(text: $vm.userDetails.email, placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                    
                    InputPasswordView(password: $vm.userDetails.password, placeholder: "Password", sfSymbol: "lock")
                    
                    Divider()
                    
                    InputTextFieldView(text: $vm.userDetails.firstName, placeholder: "First Name", keyboardType: .namePhonePad, sfSymbol: nil)
                    
                    InputTextFieldView(text: $vm.userDetails.lastName, placeholder: "Second Name", keyboardType: .namePhonePad, sfSymbol: nil)
                    
                    InputTextFieldView(text: $vm.userDetails.age, placeholder: "Age", keyboardType: .numberPad, sfSymbol: nil)
                    
                }
                ButtonView(title: "Sign up"){
                    vm.register()
                }
                
            }
            .padding(.horizontal,15)
            .navigationTitle("Register")
            .applyClose()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

//
//  RegistrtionDetails.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 12.01.2023.
//

import Foundation

struct RegistrationDetails{
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var age: String
}

extension RegistrationDetails{
    
   static var new: RegistrationDetails {RegistrationDetails(email: "", password: "", firstName: "", lastName: "", age: "")}
}

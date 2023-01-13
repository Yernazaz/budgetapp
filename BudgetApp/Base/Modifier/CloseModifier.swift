//
//  CloseModifier.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 12.01.2023.
//

import SwiftUI

struct CloseModier: ViewModifier{
    @Environment(\.presentationMode) var presentationMode
    
    func body(content: Content) -> some View{
        content
            .toolbar{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
            }
    }
}

extension View{
    
    func applyClose() -> some View{
        self.modifier(CloseModier())
    }
}

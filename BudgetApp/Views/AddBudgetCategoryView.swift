//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by Yernazar on 12/20/22.
//

import SwiftUI

struct AddBudgetCategoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var total: Double = 100
    @State private var messages: [String] = []
    private var budgetCategoryToEdit: BudgetCategory?
    
    init(budgetCategoryToEdit: BudgetCategory? = nil) {
        self.budgetCategoryToEdit = budgetCategoryToEdit
    }
    
    var isFormValid: Bool {
        
        if name.isEmpty {
            messages.append("Name is required")
        }
        
        if total <= 0 {
            messages.append("Total should be greater than 1.")
        }
        
        return messages.count == 0
    }
    
    private func saveOrUpdate() {
        
        if isFormValid {
            
            if let budgetCategoryToEdit {
                // get the budget to update
                let budget = BudgetCategory.byId(budgetCategoryToEdit.objectID)
                budget.name = name
                budget.total = total
            } else {
                if !BudgetCategory.exists(name) {
                    let budgetCategory = BudgetCategory(context: viewContext)
                    budgetCategory.name = name
                    budgetCategory.total = total
                } else {
                    messages.append("Category name should be unique.")
                }
            }
            
            // save the context
            do {
                try viewContext.save()
                dismiss() 
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
//    вот тут фронтенд делается
    var body: some View {
        let _ = print(Self._printChanges())
        NavigationStack {
            Form {
//                инпут
                TextField("Name", text: $name)
//                млайдер
                Slider(value: $total, in: 0...10000, step: 50) {
                    Text("Total")
                } minimumValueLabel: {
                    Text("$0")
                } maximumValueLabel: {
                    Text("$10000")
                }
//                значение слайдера
                Text(total.formatAsCurrency())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ForEach(messages, id: \.self) { message in
                    Text(message)
                }
                
               
                
            }
            .onAppear {
               
                if let budgetCategoryToEdit {
                    self.name = budgetCategoryToEdit.name ?? ""
                    self.total = budgetCategoryToEdit.total
                }
            }
//            навбар
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveOrUpdate()
                    }
                }
            }
            .navigationTitle(budgetCategoryToEdit == nil ? "Add": "Edit")
        }
        
        
    }
}

struct AddBudgetCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBudgetCategoryView()
        }
    }
}

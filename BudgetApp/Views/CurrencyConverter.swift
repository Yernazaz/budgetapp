//
//  CurrencyConverter.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 05.01.2023.
//
//

import SwiftUI

struct CurrencyConverter: View {
    @State var currencyList = [String]()
        @State var input = "100"
        @State var base = "USD"
        @FocusState private var inputIsFocused: Bool
        
        func makeRequest(showAll: Bool, currencies: [String] = ["USD", "EUR", "KZT","RUB"]) {
            apiRequest(url: "https://api.exchangerate.host/latest?base=\(base)&amount=\(input)") { currency in
                //print("ContentView", currency.rates)
                var tempList = [String]()
                
                for currency in currency.rates {
                    
                    if showAll {
                        tempList.append("\(currency.key) \(String(format: "%.2f",currency.value))")
                    } else if currencies.contains(currency.key)  {
                        tempList.append("\(currency.key) \(String(format: "%.2f",currency.value))")
                    }
                    tempList.sort()
                }
                currencyList.self = tempList
                
            }
        }
        
        var body: some View {
            VStack() {
                List {
                    ForEach(currencyList, id: \.self) { currency in
                        Text(currency)
                    }
                }
                VStack {
                    Rectangle()
                        .frame(height: 8.0)
                        .foregroundColor(.blue)
                        .opacity(0.90)
                    TextField("Enter an amount" ,text: $input)
                        .padding()
                        .background(Color.gray.opacity(0.10))
                        .cornerRadius(20.0)
                        .padding()
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                    TextField("Enter a currency" ,text: $base)
                        .padding()
                        .background(Color.gray.opacity(0.10))
                        .cornerRadius(20.0)
                        .padding()
                        .focused($inputIsFocused)
                    Button("Convert!") {
                        makeRequest(showAll: false)
                        inputIsFocused = false
                    }.padding()
                }
                
            }.onAppear() {
                makeRequest(showAll: false)
            }
        }
    
}

struct CurrencyConverter_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverter()
    }
}

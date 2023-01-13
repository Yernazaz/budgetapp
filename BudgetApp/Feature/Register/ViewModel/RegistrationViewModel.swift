//
//  RegistrationViewModel.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 12.01.2023.
//

import Foundation
import Combine

enum RegistrationState {
    case succsesful
    case failed(error: Error)
    case na
}

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService {get}
    var state: RegistrationState {get}
    var userDetails: RegistrationDetails {get}
    
    init(service: RegistrationService)
}

final class RegistrationViewModelImp1: ObservableObject, RegistrationViewModel {
    
    let service: RegistrationService
    
    var state: RegistrationState = .na
    
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    
    private var subscriptions  = Set<AnyCancellable>()
    
    init(service: RegistrationService){
        self.service = service
    }
    
    func register() {
        
        service
            .register(with: userDetails)
            .sink{ [weak self] res in
                
                switch res{
                case .failure(let error):
                    self?.state = .succsesful
                default: break
                }
                
            } receiveValue: { [weak self] in
                self?.state = .succsesful
            }
            .store(in: &subscriptions)
            
    }
}

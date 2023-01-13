//
//  RegistrationService.swift
//  BudgetApp
//
//  Created by Yerulan Zhagiparov on 12.01.2023.
//

import Combine
import Foundation
import Firebase
import FirebaseDatabase

enum RegistrationKeys: String{
    case firstName
    case lastName
    case age
}

protocol RegistrationService{
    func register(with details: RegistrationDetails) -> AnyPublisher<Void,Error>
}

final class RegistrationServiceImp1: RegistrationService{
    
    func register(with details: RegistrationDetails) ->AnyPublisher<Void,Error>{
        
        Deferred{
            
            Future{ promise in
                Auth.auth()
                    .createUser(withEmail: details.email, password: details.password){ res, error in
                        if let err = error{
                            promise(.failure(err))
                        } else{
                            
                            if let uid = res?.user.uid{
                                let values = [RegistrationKeys.firstName.rawValue: details.firstName,
                                              RegistrationKeys.lastName.rawValue: details.lastName,
                                              RegistrationKeys.age.rawValue: details.age] as [String : Any]
                                
                                Database.database()
                                    .reference()
                                    .child("users")
                                    .child(uid)
                                    .updateChildValues(values) { error,ref in
                                        
                                        if let err = error{
                                            promise(.failure(err))
                                        } else {
                                            promise(.success(()))
                                        }
                                    }
                                  
                            } else {
                                promise(.failure(NSError(domain: "Invalid UID", code: 0,  userInfo: nil)))
                            }
                            
                            
                        }
                        
                    }
            }
            
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        
    }
}

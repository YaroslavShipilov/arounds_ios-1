//
//  FirstUpdateProfileViewModel.swift
//  Arounds
//
//  Created by Samvel Pahlevanyan on 5/2/18.
//  Copyright © 2018 Samvel Pahlevanyan. All rights reserved.
//
import Firebase
import Foundation

class FirstUpdateProfileViewModel: EditProfileViewModeling {
    
    var didFetchedSocial: ((ARSocial?) -> Void)?
    var didClick: ((ARButton) -> Void)?
    
    var isHiddendBackButton: Bool = true
    var user: ARUser?
    var social: ARSocial?
    
    
    required init(with newUser: ARUser) {
        user = newUser
        Database.Users.social(userID: user?.id ?? "") { [weak self] (social) in
            self?.social = social
            self?.didFetchedSocial?(social)
        }
    }
    
    func validate(fields fireID: String,
                  firstName: String,
                  lastName: String,
                  nicName: String,
                  gender: UserGender,
                  date: Date?,
                  aboute: String,
                  avatar: String,
                  phone: String,
                  insta:String,
                  completion handler: ((String?, ARUpdateUserBuilder?,[Int]) -> Void)?) {
        
        let result = ARValidation.validateUpdated(fields: fireID,
                                                  firstName: firstName,
                                                  lastName: lastName,
                                                  nicName: nicName,
                                                  gender: gender,
                                                  date: date,
                                                  aboute: aboute,
                                                  avatar: avatar,
                                                  phone: phone,
                                                  insta: insta)
        
        handler?(result.0, result.1, result.2)
    }
    
    func update(user builder:ARUpdateUserBuilder, completion handler:((Error? , Bool?)->Void)?) {
        ProfileApi().update(user: builder) { (error, success) in
            handler?(error, success)
        }
    }
    
    func updateSocial() {
        if let social = social {
            Database.Users.setSocial(social: social, userID: user?.id ?? "")
        }
    }
    
    deinit {
        if CLLocationManager.authorizationStatus() == .denied  {
            LocationRequired.shared.show()
        } else if UserDefaults.standard.bool(forKey: "askingAccess") == true {
            NotificationRequired.shared.show(hide:
                UIApplication.shared.isRegisteredForRemoteNotifications)
        }
    }
    
    
}


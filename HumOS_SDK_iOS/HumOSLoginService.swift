//
//  HumOSLoginService.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/9/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss

private struct Endpoints {
    static let createPatient = "/create_patient"
    static let createProvider = "/create_provider"
    static let createVerificationCode = "/create_verification_code"
    static let validateVerificationCode = "/validate_verification_code"
    static let createVerificationLink = "/create_verification_link"
    static let createUser = "/users"
    static let logout = "/logout"
    static let forgotPwd = "/forgot_password"
    static let login = "/login"


}

internal class HumOSLoginService : HumOSNetworkService{
    
    internal static func createPatient(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String, type:HumOSUserType, completion: (humOSUser:HumOSPatientUser?, error: NSError?)->()) {
        
        let body = [HumOSParamKeys.firstName:firstName,
                    HumOSParamKeys.lastName:lastName,
                    HumOSParamKeys.phone:countryCode+phoneNumber,
                    HumOSParamKeys.email:email];
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        var endpoint:String = ""
        if(type == HumOSUserType.Patient) {endpoint = Endpoints.createPatient}
        else {endpoint = Endpoints.createProvider}
        
        
        HumOSServerCommands.sharedInstance?.post(endpoint, headers: headers, params: [:], body: body, completion: { data, error in
            if(error == nil) {
                if(isResponseSuccess(data as! NSDictionary)) {
                    let dictionary = data as! NSDictionary
                    let status = dictionary[HumOSParamKeys.status] as! String
                    if(status == "Exists") {
                     completion(humOSUser:nil, error: NSError.init(type: HumOSErrorType.UserAlreadyExists))
                    }
                    else {
                        
                        let user = createUser(firstName, lastName:lastName, phoneNumber: phoneNumber, countryCode: countryCode, email: email, data: dictionary, type: type)
                        completion(humOSUser: user, error: nil)
                    }
                }else {
                    completion(humOSUser: nil, error: parseHumOSServerError(data as! NSDictionary))
                }
            } else {
                completion(humOSUser: nil, error: error!)
            }
        })
        
    }
    
    private static func createUser(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String, data:NSDictionary, type:HumOSUserType) -> HumOSPatientUser{
        
        var humOSUser: HumOSUser = HumOSUser()
        if(type == HumOSUserType.Patient) {
            humOSUser = HumOSPatientUser(json:data as! JSON)!
        }else {
            humOSUser = HumOSProviderUser(json:data as! JSON)!
        }
        humOSUser.firstName = firstName
        humOSUser.lastName = lastName
        humOSUser.email = email
        humOSUser.phone = phoneNumber
        let patient = HumOSPatient(json:data as! JSON)
        patient!.firstName = firstName
        patient!.lastName = lastName
        patient!.email = email
        patient!.phone = phoneNumber
        let user = humOSUser as! HumOSPatientUser
        user.patientProfile = patient;
        user.saveSession()
        return user
        
    }
    
    internal static func logout(accessToken:String, pushToken:String, completion:(NSError?)->()) {
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        let body = [HumOSParamKeys.accessToken:accessToken,
                    HumOSParamKeys.token:pushToken];

        HumOSServerCommands.sharedInstance?.post(Endpoints.logout, headers: headers, params: [:], body: body, completion: { data, error in
            if(error == nil) {
                completion(error)
            } else {
                print("\(data)")
            }
        })
    }
    
    internal static func forgotPassword(pushToken:String, newPassword:String, completion:(NSError?)->()) {
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        let body = [HumOSParamKeys.token:pushToken,
                    HumOSParamKeys.password:newPassword];
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.forgotPwd, headers: headers, params: [:], body: body, completion: { data, error in
            if(error == nil) {
                completion(error)
            } else {
                print("\(data)")
            }
        })
    }

    internal static func createVerificationLink(username:String, completion:(verificationToken:String?, message:String?, NSError?)->()) {
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        let body = [HumOSParamKeys.username:username];
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.createVerificationLink, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(verificationToken: nil, message: nil, error)
                
            } else {
                let dictionary = data as! NSDictionary
                completion(verificationToken: dictionary[HumOSParamKeys.token] as? String, message: dictionary[HumOSParamKeys.message] as? String, nil )
            }
        })
    }

    internal static func generateVerificationCode(documentID:String, userType:HumOSUserType, completion:( message:String?, NSError?)->()) {
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        let body = [HumOSParamKeys.documentID:documentID,
                    HumOSParamKeys.type:userType.rawValue];
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.createVerificationCode, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(message: nil, error)
                
            } else {
                if(isResponseSuccess(data as! NSDictionary)) {
                    let dictionary = data as! NSDictionary
                    completion(message: dictionary[HumOSParamKeys.message] as? String, nil )
                } else {
                    completion(message: nil, parseHumOSServerError(data as! NSDictionary) )
                }
            }
        })
    }
    
    internal static func validateVerificationCode(code:String, documentID:String, userType:HumOSUserType, completion:( message:String?, NSError?)->()) {
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        let body = [HumOSParamKeys.documentID:documentID,
                    HumOSParamKeys.type:userType.rawValue,
                    HumOSParamKeys.pin: code];
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.validateVerificationCode, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(message: nil, error)
                
            } else {
                if(isResponseSuccess(data as! NSDictionary)) {
                    let dictionary = data as! NSDictionary
                    completion(message: dictionary[HumOSParamKeys.message] as? String, nil )
                } else {
                    completion(message: nil, parseHumOSServerError(data as! NSDictionary) )
                }
            }
        })
    }


    internal static func registerUser(password:String, humOSUser: HumOSUser, completion:( NSError?)->()) {
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        var userType = HumOSUserType.Patient
        if(humOSUser is HumOSProviderUser) {userType = HumOSUserType.Provider}
        
        var languages:[String] = []
        if(userType == HumOSUserType.Patient) {
            let patientUser = humOSUser as! HumOSPatientUser
            languages = (patientUser.patientProfile?.languages)!
        }
        
        var specialities:[String] = []
        if(userType == HumOSUserType.Provider) {
            let providerUser = humOSUser as! HumOSProviderUser
            specialities = (providerUser.providerProfile?.specialities)!
        }
 
        
        let body = [HumOSParamKeys.firstName:humOSUser.firstName!,
                    HumOSParamKeys.lastName:humOSUser.lastName!,
                    HumOSParamKeys.email:humOSUser.email!,
                    HumOSParamKeys.type:userType.rawValue,
                    HumOSParamKeys.phone: humOSUser.phone!,
                    HumOSParamKeys.languages:languages,
                    HumOSParamKeys.specialities:specialities];
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.createUser, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(error)
                
            } else {
                //if(isResponseSuccess(data as! NSDictionary)) {
                    completion(nil )
                //} else {
                    //completion(parseHumOSServerError(data as! NSDictionary) )
                //}
            }
        })
    }
    
    
    internal static func login(username:String, password:String, accessToken:String, type:HumOSUserType, completion: (humOSUser:HumOSPatientUser?, error: NSError?)->()) {
        
        let body = [HumOSParamKeys.username:username,
                    HumOSParamKeys.password:password,
                    HumOSParamKeys.accessToken:accessToken,
                    HumOSParamKeys.type:type.rawValue];
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.login, headers: headers, params: [:], body: body, completion: { data, error in
            if(error == nil) {
                //if(isResponseSuccess(data as! NSDictionary)) {
 //                   let dictionary = data as! NSDictionary
  //                  let status = dictionary[HumOSParamKeys.status] as! String
 //                   if(status == "Exists") {
                        completion(humOSUser:nil, error: NSError.init(type: HumOSErrorType.UserAlreadyExists))
  //                  }
 //                   else {
  //                      completion(humOSUser: nil,error: nil)
                        
//                        let user = createUser(firstName, lastName:lastName, phoneNumber: phoneNumber, countryCode: countryCode, email: email, data: dictionary, type: type)
//                        completion(humOSUser: user, error: nil)
//                    }
//                }else {
//                    completion(humOSUser: nil, error: parseHumOSServerError(data as! NSDictionary))
//                }
            } else {
                completion(humOSUser: nil, error: error!)
            }
        })
        
    }

    
    
    

    
}
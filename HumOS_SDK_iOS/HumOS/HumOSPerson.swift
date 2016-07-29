//
//  HumOSPerson.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 5/2/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss



/** Idetifies a HumOS person. Encapsulates the basic data needed to identify a person
 */

public class HumOSPerson :Glossy {
    
    var firstName:String?
    var lastName:String?
    var phone:String?
    var email:String?
    var displayName: String?
    var documentId: String?
    var type:HumOSUserType?
    var userID:String?
    var sikkaID:String?
    var cell:String?
    var otherPhone:String?
    var languages:[String] = []
    var gender:String?

    
    
    public init(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String){
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phoneNumber
        self.email = email
        self.displayName = firstName+" "+lastName
    }
    
    internal init() {}

    internal init(json: NSDictionary) {
        self.documentId = json[HumOSParamKeys.documentID] as? String
        self.firstName = json[HumOSParamKeys.firstName] as? String
        self.lastName = json[HumOSParamKeys.lastName] as? String
        self.phone = json[HumOSParamKeys.phone] as? String
        self.email = json[HumOSParamKeys.email] as? String
        self.type = HumOSUserType(rawValue:(json[HumOSParamKeys.type] as? String)!)
        self.userID = json[HumOSParamKeys.userID] as? String
        self.sikkaID = json[HumOSParamKeys.sikkaID] as? String
        self.languages = (json[HumOSParamKeys.languages] as? [String])!
        self.cell = json[HumOSParamKeys.cell] as? String
    }

    
    public required init?(json: JSON) {
//        self.documentId = Keys.DocumentID.rawValue <~~ json
//        self.firstName = Keys.FirstName.rawValue <~~ json
//        self.lastName = Keys.LastName.rawValue <~~ json
//        self.phone = Keys.Phone.rawValue <~~ json
//        self.email = Keys.Email.rawValue <~~ json
//        self.type = HumOSUserType(rawValue:((Keys.UserType.rawValue <~~ json))!)
//        self.userID = Keys.UserID.rawValue <~~ json
//        self.sikkaID = Keys.SikkaID.rawValue <~~ json
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "firstName" ~~> self.firstName
            ])
    }
    
    
    internal func saveSession() {
        NSUserDefaults.standardUserDefaults().setObject(self.firstName, forKey:HumOSParamKeys.firstName);
        NSUserDefaults.standardUserDefaults().setObject(self.lastName, forKey:HumOSParamKeys.lastName);
        NSUserDefaults.standardUserDefaults().setObject(self.phone, forKey:HumOSParamKeys.phone);
        NSUserDefaults.standardUserDefaults().setObject(self.email, forKey:HumOSParamKeys.email);
        NSUserDefaults.standardUserDefaults().setObject(self.userID, forKey:HumOSParamKeys.userID);
        NSUserDefaults.standardUserDefaults().setObject(self.sikkaID, forKey:HumOSParamKeys.sikkaID);
    }
    
    internal func clearSession() {
        
    }
    
    class internal func populateFromCache(user:HumOSUser) {
        user.firstName = NSUserDefaults.standardUserDefaults().objectForKey(HumOSParamKeys.firstName) as? String;
        user.lastName = NSUserDefaults.standardUserDefaults().objectForKey(HumOSParamKeys.lastName) as? String;
        user.phone = NSUserDefaults.standardUserDefaults().objectForKey(HumOSParamKeys.phone) as? String;
        user.userID = NSUserDefaults.standardUserDefaults().objectForKey(HumOSParamKeys.userID) as? String;
        user.sikkaID = NSUserDefaults.standardUserDefaults().objectForKey(HumOSParamKeys.sikkaID) as? String;
    }
    
}

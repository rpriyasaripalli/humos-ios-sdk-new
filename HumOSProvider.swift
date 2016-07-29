//
//  HumOSProvider.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 5/2/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss

public class HumOSProvider: HumOSPerson {
    
    var latitude:String?
    var longitude:String?
    var address:HumOSAddress?
    var specialities:[String]?
    var practiceID:String?
    var bluecrossID:String?
    var providerID:String?
    var officeID:String?
    var medicareID:String?
    var otherID:String?
    var scheduleID:String?
    var feescheduleID:String?
    var provacctID:String?
    var status:String?
    var isVerified:Bool?
    var isSikkaProvider:Bool?
    var isUser:Bool?
    
    
    public override init(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String){
        super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode, email: email)
        
    }
    
//    public required init?(json: JSON) {
//        super.init(json: json)
//        self.specialities = (Keys.Specialities.rawValue <~~ json)!
//        self.address = HumOSAddress(json: json)
//        
//    }
    
    internal override init(json:NSDictionary) {
        super.init(json: json)
        self.specialities = json[HumOSParamKeys.specialities] as? [String]
        self.practiceID = json[HumOSParamKeys.practiceID] as? String
        self.provacctID = json[HumOSParamKeys.provacctID] as? String
        self.medicareID = json[HumOSParamKeys.medicareID] as? String
        self.providerID = json[HumOSParamKeys.providerID] as? String
        self.otherID = json[HumOSParamKeys.otherID] as? String
        self.feescheduleID = json[HumOSParamKeys.feescheduleID] as? String
        self.status = json[HumOSParamKeys.status] as? String
        self.scheduleID = json[HumOSParamKeys.scheduleID] as? String
        self.isVerified = json[HumOSParamKeys.isVerified] as? Bool
        self.isSikkaProvider = json[HumOSParamKeys.isSikkaProvider] as? Bool
        self.isUser = json[HumOSParamKeys.isUser] as? Bool
    }
    
    public required init?(json: JSON) {
        fatalError("init(json:) has not been implemented")
    }
    
}
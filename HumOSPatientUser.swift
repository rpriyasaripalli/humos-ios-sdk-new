//
//  HumOSPatientUser.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 5/5/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
/** Idetifies a user who is HumOS Patient.  */
import Gloss
public class HumOSPatientUser: HumOSUser {
    
    var _patientProfile:HumOSPatient?
    
    /** Initializes a HumOSPatientUser class with the given credentials. Not available for clients to instantiate. An internal api that only SDK have access to.
     - param:firstName lastName phoneNumber countryCode email
     */
    internal override init(firstName fisrtName:String, lastName:String, phoneNumber:String, countryCode:String, email:String) {
        super.init(firstName: fisrtName, lastName:lastName, phoneNumber:phoneNumber, countryCode:countryCode, email:email)
    }
    
    public required init?(json: JSON) {
        super.init(json: json)
        self.userName = self.phone
    }

    // MARK: Accessors
    internal var patientProfile:HumOSPatient? {
        get {
            return self._patientProfile
        }
        set {
            self._patientProfile = newValue
        }
    }

    
}
//
//  HumOSPatient.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 3/30/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss

/** Idetifies a HumOS Patient. Encapsulates the data needed to identify a patient
 */

public class HumOSPatient: HumOSPerson {

    
    public override init(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String){
        super.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode, email: email)
     }
    
    public required init?(json: JSON) {
        super.init(json: json)
    }
}
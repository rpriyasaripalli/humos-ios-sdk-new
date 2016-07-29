//
//  HumOSAddress.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/11/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

struct Location {
    let latitude: Double
    let longitude: Double
}

public class HumOSAddress {
    
    var city:String?
    var state:String?
    var country:String?
    var streetAddress:String?
    var zip:String?
    var location:Location
    
    internal init(json:NSDictionary) {
        
        self.city = json[HumOSParamKeys.city] as? String
        self.state = json[HumOSParamKeys.state] as? String
        self.country = json[HumOSParamKeys.country] as? String
        self.streetAddress = json[HumOSParamKeys.address] as? String
        self.zip = json[HumOSParamKeys.zip] as? String
        let location = json[HumOSParamKeys.location]
        self.location = Location(latitude: location![HumOSParamKeys.latitude] as! Double, longitude: location![HumOSParamKeys.longitude] as! Double)
        
    }
    
}
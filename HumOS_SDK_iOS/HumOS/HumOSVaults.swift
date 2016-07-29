//
//  HumOSVaults.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 3/29/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

enum HumOSVaultIds :String{
    case ACCOUNT = "TV_ACCOUNT_ID"
    case PROVIDER = "TV_VAULT_ID_PROVIDER"
    case PATIENT = "TV_VAULT_ID_PATIENT"
    case PROFILE_IMAGES = "TV_VAULT_ID_PROFILE_IMAGES"
}

internal class HumOSVaults : NSObject {
    
    var account:String = ""
    var provider:String = ""
    
}
//
//  HumOSNetworkService.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/3/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation


internal class HumOSNetworkService {
    
    func checkForHumOSErrors(data: NSDictionary) -> (NSError?) {
        return nil
    }
    
    internal static func isResponseSuccess(response: NSDictionary) -> Bool{
        let humOSCode = response[HumOSParamKeys.humOSCode] as? String
        if( humOSCode != HumOSServerErrorCodes.HumOS001.rawValue) { return false }
        return true
    }
    
    internal static func parseHumOSServerError(response: NSDictionary) -> NSError{
        let humOSCode = response[HumOSParamKeys.humOSCode] as? String
        let error =  HumOSServerErrorType(rawValue:humOSCode!)
        return NSError.init(type: error!, localizedMessage: response[HumOSParamKeys.shortMessage] as! String)
    }

}
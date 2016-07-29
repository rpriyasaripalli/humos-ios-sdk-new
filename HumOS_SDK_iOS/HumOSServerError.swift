//
//  HumOSServerError.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/1/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

public enum HumOSServerErrorType: String, ErrorType {
    case HumOS001 = "hum-0001"
    case HumOS0028 = "hum-0028"
    case JSONSerializationError
    case ClientError
    
    
    
    func localizedUserInfo() -> [String: String] {
        var localizedDescription: String = ""
        var localizedFailureReasonError: String = ""
        var localizedRecoverySuggestionError: String = ""
        
        switch self {
        case JSONSerializationError:
            localizedDescription = NSLocalizedString("Error.JSONSerializationError", comment: "Error during JSON serialization")
            break
        case .ClientError:
            localizedDescription = NSLocalizedString("Error.JSONSerializationError", comment: "Bad request by client")
            break

        default:
            localizedDescription = NSLocalizedString("Error.Unknown", comment: "Unknown error")
            
        }
        return [
            NSLocalizedDescriptionKey: localizedDescription,
            NSLocalizedFailureReasonErrorKey: localizedFailureReasonError,
            NSLocalizedRecoverySuggestionErrorKey: localizedRecoverySuggestionError
        ]
    }
    
    func getCode() -> Int{
        switch self {
        case .HumOS001:
            return 200
        case .HumOS0028:
            return 422
        default:
            return 200
        }
        
    }
    
    

}

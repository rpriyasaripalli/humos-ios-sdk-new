//
//  HumOSError.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 4/5/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

/** HumOSError class extends NSError and holds an error type specific to HumOS.
 */

private let ProjectErrorDomain = "HumOSErrorDomain"

extension NSError {
    
    internal convenience init(type: HumOSErrorType) {
        self.init(domain: ProjectErrorDomain, code: type.rawValue, userInfo: type.localizedUserInfo())
    }
    
    internal convenience init(type: HumOSServerErrorType, localizedMessage:String) {
        self.init(domain: ProjectErrorDomain, code: type.getCode(), userInfo: [NSLocalizedDescriptionKey :localizedMessage])
    }
    
    internal convenience init(type: HumOSServerErrorType) {
        self.init(domain: ProjectErrorDomain, code: type.getCode(), userInfo: type.localizedUserInfo())
    }


}
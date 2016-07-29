//
//  HumOSAppConfig.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 4/4/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

/** Defines HumOS User type.
 * Available types: Patient, Provider
 */
public enum HumOSUserType :String{
    case Patient = "patient"
    case Provider = "provider"
}

/** Defines Enviroment type.
 * Available types: Testing, Production
 */

public enum HumOSEnvironmentType : Int {
    case Testing
    case Production
}

/** Encapsulates data needed from the client like pushToken, enviroment etc. Client needs to intantiate this class with needed data and and send it while intantiating the HumOS class
 *
 */
typealias result = () throws ->()

public class HumOSAppConfig : NSObject {
    
    internal(set) var userType:HumOSUserType = HumOSUserType.Patient
    private var _pushToken:String = ""
    private var logPath:String = ""
    private var _environment:HumOSEnvironmentType = HumOSEnvironmentType.Testing
    private var peristData:Bool = false
    
    public init(userType:HumOSUserType, environment:HumOSEnvironmentType, persistData:Bool) {
        self.userType = userType;
        self._environment = environment;
        self.peristData = persistData
    }

    public init(userType:HumOSUserType, logPath:String, apiKey:String, environment:HumOSEnvironmentType, persistData:Bool) {
        self.userType = userType;
        self.logPath = logPath;
        self._environment = environment;
        self.peristData = persistData
    }
    
    internal func setupConfig() throws {
        HumOSConfig.sharedInstance().setBaseURL(_environment.rawValue)
        HumOSServerCommands.initializeServer(environment)
        
//        HumOSClient.setBaseConfigWithCompletion { error in
//            if let error = error {
//                // Create result block that throws an error
//               // result { throw error }
//                return
//            }
//        }
    }
    
    public var environment : HumOSEnvironmentType {
        get {
            return _environment
        }
        set {
            _environment = newValue
        }
    }
  
    public var pushToken : String {
        get {
            return _pushToken
        }
        set {
            _pushToken = newValue
            //update to server
        }
    }

}


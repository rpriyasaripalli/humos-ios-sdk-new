//
//  NetworkingUtil.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/2/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

class NetworkingUtil {
    
    static func dataToJSON (data:NSData) ->(json:NSObject?, error:NSError?) {
        do {
            guard let json:NSObject = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSObject else {
                print(data)
                return(nil, NSError.init(type: HumOSServerErrorType.JSONSerializationError))
            }
            return(json,nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return(nil,error)
        }

    }
    
    static func JSONToData (json:NSObject) ->(data:NSData?, error:NSError?) {
        do {
            guard let data:NSData = try NSJSONSerialization.dataWithJSONObject(json, options:[]) else {
                print(json)
                return(nil, NSError.init(type: HumOSServerErrorType.JSONSerializationError))
            }
            return(data,nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return(nil,error)
        }
        
    }
    
    static func decodeBase64String(base64EncodedString:String) -> String{
        let decodedData = NSData(base64EncodedString: base64EncodedString, options:NSDataBase64DecodingOptions(rawValue: 0))
        let decodedString = String(data: decodedData!, encoding: NSUTF8StringEncoding)
        return decodedString!
    }

    
}
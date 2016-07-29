//
//  HumOSBlobService.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/11/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

private struct Endpoints {
    static let blob = "/blobs"
}


internal class HumOSBlobService {
    
    internal func createBlob(filepath:String, accessToken:String) {
        
        let body: [String:AnyObject] = [HumOSParamKeys.accessToken : accessToken,
                                        HumOSParamKeys.file: filepath]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.blob, headers: headers, params: [:], body: body, completion: { data, error in
        })

        
    }
    
    internal func readBlob(blobID:String, accessToken:String) {
        
        let endpoint = Endpoints.blob+"/"+blobID
        let params = [HumOSParamKeys.accessToken:accessToken]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.get(endpoint, headers: headers, params: params, completion: { data, error in
        })
    }
    
    internal func deleteBlob(blobID:String, accessToken:String) {
        
        let endpoint = Endpoints.blob+"/"+blobID
        let params = [HumOSParamKeys.accessToken:accessToken]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.delete(endpoint, headers: headers, params: params, completion: { data, error in
        })
    }


}
//
//  HumOSCardsService.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/2/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

private struct Endpoints {
    static let cardsSearch = "/cards/search"
}

internal class HumOSCardsService {

    internal static func getCards(accessToken: String, userID: String, pageNumber : Int, completion:(data:NSDictionary?, error:NSError?) ->()) {

        let serachOptions = ["filter" : ["user_visibility" : ["type" : "in", "value" : userID]],
                             "filter_type" : "and",
                             "full_document": "true"]
        
//        let serachOptions = ["filter" : ["channel" : ["type" : "in", "value" : userID]],
//                             "filter_type" : "and","full_document": "true","page": pageNumber,
//                             "per_page": 500,
//                             "sort": [[ "timestamp": "desc"]]]


        let params : [String:AnyObject] = ["access_token" : accessToken,
                                           "search_option": serachOptions]
        let headers : [String: String] = ["Content-Type": "application/json"]

        HumOSServerCommands.sharedInstance?.post(Endpoints.cardsSearch, headers: headers, params: [:], body: params, completion: { data, error in
            if(error == nil) {
                let dictionary = data as? NSDictionary
                let humOSCode = dictionary!["humos_code"] as! String
                if( humOSCode != HumOSServerErrorCodes.HumOS001.rawValue) {
                    print("Error in getCards " + humOSCode)
                    completion(data: nil, error: NSError.init(type: HumOSErrorType.ServerError))
                } else {
                    completion(data: dictionary, error: nil)
                }
            } else {
                completion(data: nil, error: error!)
            }
        })

    }

//    private func isCommandSuccess(data: Dictionary) -> Bool {
//          let humOSCode = dictionary["humos_code"] as! String
//         if( humOSCode != HumOSServerErrorCodes.HumOS001.rawValue) {
//                print("Error " + humOSCode)
//          }
//
//    }

}


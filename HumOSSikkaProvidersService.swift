//
//  HumOSSikkaProvidersService.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 6/11/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
private struct Endpoints {
    static let searchProviders = "/search_sikka_providers"
    static let searchProviders2 = "/search_provider2"
    static let searchProviderCards = "/searchprovider_cards"
}


internal class HumOSSikkaProvidersService :HumOSNetworkService{
    
    internal static func serachProviders(sikkaPrefered:Bool, latitude:String, longitude:String, specialities:NSArray,  pageNum: Int, pageSize:Int, completion:(providers:[HumOSProvider]?, pagingInfo:PagingInfo?, error:NSError?) -> ()) {
        
        var endpoint:String
        if(sikkaPrefered) {endpoint = Endpoints.searchProviders}
        else {endpoint = Endpoints.searchProviders2}
        
        let body: [String:AnyObject] = [HumOSParamKeys.latitude : latitude,
                                        HumOSParamKeys.longitude: longitude,
                                        HumOSParamKeys.page: pageNum,
                                        HumOSParamKeys.perpage: pageSize,
                                        HumOSParamKeys.specialities: specialities]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        
        HumOSServerCommands.sharedInstance?.post(endpoint, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(providers: nil, pagingInfo: nil, error: error!)
            } else {
                //if(isResponseSuccess(data as! NSDictionary)) {
                    let dictionary = data as! NSDictionary
                    let result = parseSearchProvidersResponse(dictionary )
                    completion(providers: result.providers, pagingInfo: result.pagingInfo, error: nil)
                //}

            }
        })

    }
    
    private static func parseSearchProvidersResponse(data: NSDictionary) -> (providers:[HumOSProvider]?, pagingInfo:PagingInfo?) {
        
        let response = data[HumOSParamKeys.humOSResponse] as! NSDictionary
        let documents = response[HumOSParamKeys.documents] as! NSArray
        var providers:[HumOSProvider] = [HumOSProvider]()
        
        for document in documents {
            let document = document[HumOSParamKeys.document] as! NSDictionary
            let documentID = document[HumOSParamKeys.documentID] as! String
            let mutableJson = document.mutableCopy()
            //Add document id to json
            mutableJson.setObject(documentID, forKey:HumOSParamKeys.documentID)
            providers.append(HumOSProvider.init(json:mutableJson as! [String : AnyObject]))
        }
        let info = response[HumOSParamKeys.info] as! NSDictionary
        let pagingInfo = PagingInfo(currentPage: info[HumOSParamKeys.currentpage] as! Int, numOfPages: info[HumOSParamKeys.numPages] as! Int, pageSize: info[HumOSParamKeys.perpage] as! Int, countPerPage: info[HumOSParamKeys.totalResultCount] as! Int)
        return (providers, pagingInfo)
    }
    
    
    

    
}
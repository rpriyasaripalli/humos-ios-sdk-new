//
//  HumOSCloudAPI.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 5/31/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss

private struct Endpoints {
    static let messagesSearch = "/messages/search"
    static let messageCreate = "/messages"
    static let messageDelete = "/messages/"
    static let push = "/push_notification"
    static let invite = "/send_invite_email_sms"

}

private enum MessagingSserviceAPIType {
    case Search
    case add
    case delete
}


internal class HumOSMessagingService : HumOSNetworkService{
    
    internal static func searchMessages(accessToken: String, channels: [String], from: String, to: String?, pageNumber : Int, pageSize: Int, completion:(messages:[HumOSMessage]?, pagingInfo:PagingInfo?, error:NSError?) ->()) {
        
        let serachOptions = ["filter" : ["channel" : ["type" : "in", "value" : channels]],
                             "filter_type" : "and","full_document": "true","page": pageNumber,
                             "per_page": pageSize,
                             "sort": [[ "timestamp": "desc"]]]
        
        let body: [String:AnyObject] = [HumOSParamKeys.accessToken : accessToken,
                                           HumOSParamKeys.searchOption: serachOptions,
                                           HumOSParamKeys.fromuID: from,
                                           HumOSParamKeys.touID: to!]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.messagesSearch, headers: headers, params: [:], body: body, completion: { data, error in
            if(error == nil) {
                if(isResponseSuccess(data as! NSDictionary)) {
                    let dictionary = data as! NSDictionary
                    let result = parseSearchMessagesResponse(dictionary )
                    guard result.error == nil else {
                        completion(messages: nil, pagingInfo:nil, error: result.error)
                        return
                    }
                    completion(messages: result.messages, pagingInfo:result.pagingInfo, error: nil)
                }else {
                    completion(messages: nil, pagingInfo:nil, error: parseHumOSServerError(data as! NSDictionary))
                }
            } else {
                completion(messages: nil, pagingInfo:nil, error: error!)
            }
        })
        
    }
    
    
    private static func parseSearchMessagesResponse(data: NSDictionary) -> (messages:[HumOSMessage]?, pagingInfo:PagingInfo?, error:NSError?){
        
        let response = data[HumOSParamKeys.humOSResponse] as! NSDictionary
        let documents = response[HumOSParamKeys.documents] as! NSArray
        var messages:[HumOSMessage] = [HumOSMessage]()
        
        for document in documents {
            var encodedDocument = document[HumOSParamKeys.document] as! String
            let documentID = document[HumOSParamKeys.documentID] as! String
            // remove newline else decoding fails
            encodedDocument = encodedDocument.stringByReplacingOccurrencesOfString("\n", withString: "")
            let decodedDocument  = NetworkingUtil.decodeBase64String(encodedDocument)
            let result = NetworkingUtil.dataToJSON(decodedDocument.dataUsingEncoding(NSUTF8StringEncoding)!)
            if((result.error) != nil){ return (nil, nil, result.error) }
            let json = result.json as! NSDictionary
            let mutableJson = json.mutableCopy()
            //Add document id to return in json
            mutableJson.setObject(documentID, forKey:HumOSParamKeys.documentID)
            print ("Parsed Message\(json)")
            messages.append(HumOSMessage.init(json:mutableJson as! [String : AnyObject]))
        }
        let info = response[HumOSParamKeys.info] as! NSDictionary
        let pagingInfo = PagingInfo(currentPage: info[HumOSParamKeys.currentpage] as! Int, numOfPages: info[HumOSParamKeys.numPages] as! Int, pageSize: info[HumOSParamKeys.perpage] as! Int, countPerPage: info[HumOSParamKeys.totalResultCount] as! Int)
        return (messages, pagingInfo, nil)
    }
    
    
    internal static func createMessage(message:HumOSMessage, channel:String, fromID:String,  toID:String, accessToken: String, completion:(documentID:String?, error:NSError?) -> ()) {
        
        let document: [String:AnyObject] = [ HumOSParamKeys.channel:channel,
                                            HumOSParamKeys.fromID : fromID,
                                            HumOSParamKeys.timestamp: message.timestamp,
                                            HumOSParamKeys.text:message.text,
                                            HumOSParamKeys.type:"text"]
        

        
        let body: [String:AnyObject] = [HumOSParamKeys.accessToken : accessToken,
                                        HumOSParamKeys.document: document,
                                        HumOSParamKeys.fromuID: fromID,
                                        HumOSParamKeys.touID: toID]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.messageCreate, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(documentID: nil, error: error)
            } else {
                if(isResponseSuccess(data as! NSDictionary)) {
                    //print("\(data)")
                }
                print("\(data)")
             }
        })

    }
    
    internal static func deleteMessage(message:HumOSMessage, accessToken: String, completion:(documentID:String?, error:NSError?) -> ()) {
        
        let endpoint = Endpoints.messageDelete + message.documentID!
        let params = [HumOSParamKeys.accessToken : accessToken]
        
        
        HumOSServerCommands.sharedInstance?.delete(endpoint, headers: [:], params: params, completion: {
            data, error in
            if(error == nil) {
                completion(documentID: nil, error: nil)
            } else {
                completion(documentID: nil, error: error)
            }
        })
        
    }
    
    
    internal static func sendPushNotification(message:HumOSMessage, completion:(NSError?)->()) {
        
        let aps: [String:AnyObject] = [ HumOSParamKeys.badge:1,
                                        HumOSParamKeys.alert : "Message from"+message.fromID]
        
        let apns: [String:AnyObject] = [ HumOSParamKeys.timestamp:message.timestamp,
                                         HumOSParamKeys.channel : message.channel!,
                                         HumOSParamKeys.fromID: message.fromID,
                                         HumOSParamKeys.type: (message.type?.rawValue)!,
                                         HumOSParamKeys.aps: aps]

        
        let msg: [String:AnyObject] = [HumOSParamKeys.apns : apns]
        let body: [String:AnyObject] = [HumOSParamKeys.message : msg]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.push, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(error!)
            } else {
                completion(nil)
            }
        })
    }
    
    
    
    internal static func sendInviteEmailSMS(documentID:String, completion:(NSError?)->()) {
        
          let body: [String:AnyObject] = [HumOSParamKeys.documentID : documentID,
                                          HumOSParamKeys.origin: "HumOS"]
        
        let headers : [String: String] = ["Content-Type": "application/json"]
        
        
        HumOSServerCommands.sharedInstance?.post(Endpoints.invite, headers: headers, params: [:], body: body, completion: { data, error in
            if(error != nil) {
                completion(error!)
            } else {
                completion(nil)
            }
        })
    }
    
        

    


}

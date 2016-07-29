//
//  HumOSConnectedUser.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 4/5/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss


public class HumOSConnection {
    var person:HumOSPerson?
    var messages:[HumOSMessage] = [HumOSMessage]()
    var registeredChannel:String = ""
    var unRegisteredChannel:String = ""
    
    public init(person:HumOSPerson) {
        self.person = person
    }
    
    private func generateChannels(myUserId:String) {
        if(!person!.userID!.isEmpty) {
            self.registeredChannel = buildChannel(myUserId, otherId: person!.userID!)
        }
        if(person!.sikkaID != nil) {
            self.unRegisteredChannel = buildChannel(myUserId, otherId: person!.sikkaID!)
        }
    }
    
    private func buildChannel(myUserId:String, otherId:String) ->(String){
        let userArray : [String] = [myUserId,person!.userID!]
        let sortedNames : [String] = userArray.sort { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        return sortedNames.joinWithSeparator("_")
    }
    
    internal func getMessages(myUserId:String, accessToken:String, pageNumber:Int, pageSize:Int,completion:(pagingInfo:PagingInfo?, error: NSError?)->()) {
        
        generateChannels(myUserId)
        var channels:[String] = [String]()
        if(!registeredChannel.isEmpty) {channels.append(registeredChannel)}
        if(!unRegisteredChannel.isEmpty) {channels.append(unRegisteredChannel)}
        if(channels.count == 0) {
            completion(pagingInfo: nil, error: NSError.init(type: HumOSErrorType.NoChannelsFoundForMessage))
            return
        }
        HumOSMessagingService.searchMessages(accessToken, channels: [self.registeredChannel, self.unRegisteredChannel], from: myUserId, to: person!.userID!, pageNumber: pageNumber, pageSize:pageSize) { (messages, pagingInfo, error) in
            if((error) != nil) {
                completion(pagingInfo: nil, error: error)
            } else {
                self.messages += messages!
                completion(pagingInfo: pagingInfo, error:nil)
            }
        }
    }
    
    internal func addMessage(message:HumOSMessage, accessToken: String, myUserID:String, completion:(NSError)->()) {
        
        message.timestamp = round(NSDate().timeIntervalSince1970*1000)
        var channel:String = ""
        var toID:String = ""
        generateChannels(myUserID)
        if(person?.userID != nil) {
            channel = registeredChannel
            toID = (person?.userID)!
        }else {
            channel = unRegisteredChannel
            toID = (person?.sikkaID)!
        }
        if(channel.isEmpty) {
            completion(NSError.init(type: HumOSErrorType.NoChannelsFoundForMessage))
            return
        }

        HumOSMessagingService.createMessage(message, channel:channel, fromID:myUserID, toID:toID, accessToken: accessToken, completion:{
            documentID, error in
            if(error != nil) {
                completion(error!)
            }
            else {
                message.documentID = documentID!
                self.messages.append(message)
            }
                
        })
        
    }
    
    internal func deleteMessage(message:HumOSMessage, accessToken: String, index:Int, completion:(NSError)->()) {
        
        HumOSMessagingService.deleteMessage(message, accessToken: accessToken, completion: { (documentID, error) in
            if(error != nil) {
                completion(error!)
            }
            else {
                self.messages.removeAtIndex(index)
            }
        })
        
    }
    
}
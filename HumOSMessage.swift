//
//  HumOSMessage.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 4/27/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss


internal enum HumOSMessageType : String{
    case HumOSMessageTypeText = "text"
    case HumOSMessageTypeImage = "image"
    case HumOSMessageTypeVideo = "video"
    case HumOSMessageTypeAudio = "audio"
    case HumOSMessageTypePlay = "play"

}

private enum Keys : String {
    case Document = "fromId"
    case DocumentID = "document_id"
    case timeStamp = "timestamp"
    case channel = "channel"
    case text = "text"
    case type = "type"
}


/**
 *  Encapsulates a HumOS message.
 *
 */
public class HumOSMessage {
    
    var channel:String?
    var text:String=""
    var timestamp:Double=0.0
    var fromID: String=""
    var type: HumOSMessageType?
    var blobId:String?
    var thumbnailblobId:String?
    var documentID:String?
    var toID:String?
    
//    public required init?(json: JSON) {
      //  var document = (Keys.Document.rawValue <~~ json)!
        
//        document = document.stringByReplacingOccurrencesOfString("\n", withString: "")
//        let decodedDocument  = NetworkingUtil.decodeBase64String(document)
//        let result = NetworkingUtil.dataToJSON(decodedDocument.dataUsingEncoding(NSUTF8StringEncoding)!)
//        if((result.error) != nil){ return (nil, result.error) }
//
//        self.fromID = (Keys.fromID.rawValue <~~ json)!
//        documentID = (Keys..rawValue <~~ json)!
//        let message:JSON = decodeMessage(encodedMessage)!

//        
        
//    }
    
    public init(text:String) {
        self.text = text
        self.type = HumOSMessageType.HumOSMessageTypeText
    }
    
    internal init(json: [String : AnyObject]) {
        self.fromID = json[HumOSParamKeys.fromID] as! String
        self.channel = json[HumOSParamKeys.channel] as? String
        self.documentID = json[HumOSParamKeys.documentID] as? String
        self.timestamp = json[HumOSParamKeys.timestamp] as! Double
        self.text = json[HumOSParamKeys.text] as! String
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "" ~~> self.channel
            ])
    }


}
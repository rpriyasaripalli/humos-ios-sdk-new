
//
//  HumOSUser.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 3/29/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Gloss

private enum Keys : String {
    case AccessToken = "access_token"
    case ConnectedUserIds = "connected_users"
    case ConnectedProviderIds = "connected_providers_sikka_id"
    case Contacts = "contacts"
    case UserName = "username"
    case UserID = "user_id"
    case Connections = "connections"
}


typealias SikkaNetRequestCompletionType = (Bool?, NSDictionary?, NSURLResponse?, NSError?) -> (Void)

/** Added just to parse the user_ids from json. Can be removed once server side fixes to send the
 connections expanded.
 *
 */
struct connectedUser : Glossy{
    var userID:String
    internal init?(json: JSON) {
        self.userID = (Keys.UserID.rawValue <~~ json)!
    }
    internal init?(userID:String) {
        self.userID = userID
    }
    internal func toJSON() -> JSON? {
        return jsonify([
            Keys.UserID.rawValue ~~> self.userID
            ])
    }
}

public struct PagingInfo {
    var currentPage:Int
    var numOfPages:Int
    var pageSize:Int
    var countPerPage:Int
}

/** HumOSUser class represents a user in the HumOSystem.
 */
public class HumOSUser: HumOSPerson {
    
    var _connections:[HumOSConnection] = []
    var messages:NSArray?
    var contacts:NSArray?
    var cards:NSArray?
    var userName:String?
    var accessToken:String = ""
    var isVerified:Bool = false
    var connectedUserIds: [connectedUser]?
    var connectedSikkaIds: NSArray?

    /** Initializes a HumOSUser class with the given credentials. Not available for clients to instantiate. An internal api that only SDK have access to.
        - param:firstName lastName phoneNumber countryCode email
     */
    internal override init(firstName fisrtName:String, lastName:String, phoneNumber:String, countryCode:String, email:String) {
        super.init(firstName: fisrtName, lastName:lastName, phoneNumber:phoneNumber, countryCode:countryCode, email:email)
    }
    
    internal override init() { super.init()}
    
    public required init?(json: JSON) {
        let attributes:JSON = ("attributes" <~~ json)!
        super.init(json: attributes)
        set(json)
    }
    
    private func set(json: JSON) {
        self.accessToken = (Keys.AccessToken.rawValue <~~ json)!
        let attributes:JSON = ("attributes" <~~ json)!
        let userIds:[JSON] = ("connected_users" <~~ attributes)!
        self.connectedUserIds = [connectedUser].fromJSONArray(userIds)
        self.connectedSikkaIds = Keys.ConnectedProviderIds.rawValue <~~ attributes
        self.userName = Keys.UserName.rawValue <~~ json
        self.userID = Keys.UserID.rawValue <~~ json
        self.populateConnections({error in
            if(error != nil) {print("error"+(error?.localizedDescription)!)}
        })
    }
    
    public override func toJSON() -> JSON? {
        super.toJSON()
        return jsonify([
            "id" ~~> self.firstName
            ])
    }
    
    /** Generates a verification code. This method needs to be called after preregistration.
        - param: completionBlock returning error
     */
    public func generateVerificationCode(completion: (message:String?, error: NSError?)->()){
        
        var type = HumOSUserType.Patient
        if(self is HumOSProviderUser) {type = HumOSUserType.Provider}
        HumOSLoginService.generateVerificationCode(self.documentId!, userType: type, completion: completion)
        
    }
    
    /** Validates the given verification code. This method needs to be called after generating a verification code.
        - param: verificationCode completionBlock returning error
     */
    public func validateVerificationCode(verificationCode: String, completion: (message:String?, error: NSError?)->()){
    
        var type = HumOSUserType.Patient
        if(self is HumOSProviderUser) {type = HumOSUserType.Provider}
        HumOSLoginService.validateVerificationCode(verificationCode, documentID: self.documentId!, userType: type, completion: completion)

    }
    
    
    
    /** Finishes registering the user with the given password,
     - param: password completionBlock returning error
     */
    public func setPassword(password: String, completion: (error: NSError?)->()){
        
        HumOSLoginService.registerUser(password, humOSUser: self, completion: completion)
    }
    
    
    /** Reutuns all the messages for a given connection
     - param: HumOSConnection, completionBlock either Array of messages or error
     */
    public func getMessages(connection:HumOSConnection, pageNumber:Int, pageSize:Int, completion:(pagingInfo:PagingInfo?, error: NSError?)->() ) {
        connection.getMessages(self.userID!, accessToken: self.accessToken, pageNumber: pageNumber, pageSize: pageSize, completion:completion)
    }
    
    /** Adds a message for a given connection and updates the server
     - param: HumOSConnection, completionBlock returning error
     */
    public func addMessage(humosConnectedUser:HumOSConnection, message:HumOSMessage, completion: (error: NSError?)->()) {
        humosConnectedUser.addMessage(message, accessToken: self.accessToken, myUserID:self.userID!,   completion: completion)
    }

    /** deletes a message for a given connection and updates the server
     - param: HumOSConnection, completionBlock either Array of messages or error
     */
    public func deleteMessage(humosConnection:HumOSConnection, message:HumOSMessage, index:Int,completion: (error: NSError?)->()) {
        humosConnection.deleteMessage(message, accessToken: accessToken, index: index, completion: completion)
    
    }

    /** Reutuns all the connections
     - param: completionBlock either Array of connections or error
     */
    public func getConnections(completion: (messages:NSArray, error: NSError?)->()) {}
    
    /** Adds a connection and updates the server
     - param: HumOSConnection, completionBlock returning error
     */
    public func addConnection(humosConnectedUser:HumOSConnection, completion: (error: NSError?)->()) {}
    
    /** deletes a connection and updates the server
     - param: HumOSConnection, completionBlock either Array of messages or error
     */
    public func deleteConnection(humosConnectedUser:HumOSConnection, completion: (error: NSError?)->()) {}

    /** Reutuns all the connections
     - param: completionBlock either Array of connections or error
     */
    public func getCards(completion: (messages:NSArray, error: NSError?)->()) {}
    
    /** Adds a connection and updates the server
     - param: HumOSConnection, completionBlock returning error
     */
    public func addCard(humosConnectedUser:HumOSCard, completion: (error: NSError?)->()) {}
    
    /** deletes a connection and updates the server
     - param: HumOSConnection, completionBlock either Array of messages or error
     */
    public func deleteCard(humosConnect:HumOSCard, completion: (error: NSError?)->()) {}

    /** Updates the account details like name, phone number etc on the server.
     - param: completionBlock returning error
     */
    private func updateAccount(completion: (error: NSError?)->()){}

    /** Retieves all the user details from server
     - param: completionBlock returning error
     */
    private func fetchDetails(completion: (error: NSError?)->()){}
    
    
    private func initSecureMessagingServices() {}
    
    internal override func saveSession() {
        super.saveSession()
        NSUserDefaults.standardUserDefaults().setObject(self.accessToken, forKey:Keys.AccessToken.rawValue);
        var ids = Array<String>()
        for index in self.connectedUserIds! {
            ids.append(index.userID)
        }
        NSUserDefaults.standardUserDefaults().setObject(ids, forKey:Keys.ConnectedUserIds.rawValue);
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    internal override func clearSession() {
        do {
        try HumOS.getSharedInstance().logout({ error in })
        } catch{
            print ()
        }
        super.clearSession()
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.AccessToken.rawValue);
        NSUserDefaults.standardUserDefaults().synchronize();
    }

    
    /** Gets the user details from server
     */
    private func fetch() {
        if(self.phone!.isEmpty) {return}
        HumOSCloud.searchUserWithPhone(self.phone, withSuccessHandler:{data in
                
            },
            andFailure:{ error in
            })
    }
    
    internal func populateConnections(completion:(error: NSError?)->()) {
        var temp = Array<String>()
        for index in self.connectedUserIds! {
            temp.append(index.userID)
        }
            HumOSCloud.searchForUserWithIds(temp as AnyObject as! [AnyObject], accessToken: self.accessToken, withSucessHandler:{data in
                for user in data as NSArray{
                    if(user.objectForKey("type") as! String == HumOSUserType.Patient.rawValue) {
                        let patient:HumOSPatient = HumOSPatient.init(json: user as! JSON)!
                        let connection:HumOSConnection = HumOSConnection.init(person: patient)
                        self._connections.append(connection)
//                        connection.populateMessages(self.userID!, accessToken: self.accessToken, completion: {error in
//                                if(error != nil) {NSLog((error?.localizedDescription)!)}
//                            })
                    }
                    else {
                        if(user.objectForKey("type") as! String == HumOSUserType.Provider.rawValue) {
                            let provider:HumOSProvider = HumOSProvider.init(json: user as! JSON)
                            let connection:HumOSConnection = HumOSConnection.init(person: provider)
                            self._connections.append(connection)
//                            connection.populateMessages(self.userID!, accessToken: self.accessToken, completion: {error in
//                                if(error != nil) {NSLog((error?.localizedDescription)!)}
//                            })
                        }
                    }

                }
                self.saveSession()
                    completion(error: nil)
                },andFailure: { error in
                    completion(error: error)
            })
    }
    
    public var connections: [HumOSConnection] {
        get {
            return _connections
        }
    }
    
    public func populateCards(completion:(error: NSError?)->()) {
        HumOSCardsService.getCards(self.accessToken, userID:self.userID!, pageNumber: 1)
        { (data, error) in
            if((error) != nil) {
                completion(error: error)
            } else {
               // HumOSCard.init()
                print("succcess")
            }
        }
    }
    
    static internal func populateFromCache() -> HumOSUser {
        let user:HumOSUser = HumOSUser.init()
        user.accessToken = NSUserDefaults.standardUserDefaults().objectForKey(Keys.AccessToken.rawValue) as! String;
        let ids = NSUserDefaults.standardUserDefaults().objectForKey(Keys.ConnectedUserIds.rawValue) as! NSArray
        user.connectedUserIds = []
        for item in ids {user.connectedUserIds?.append(connectedUser(userID: item as! String)!)}
        user.populateConnections({
            error in
            if(error != nil){
                print("\(error)")
            }
        })
        HumOSPerson.populateFromCache(user)
        return user
    }
    
    
    
     
    
    


}
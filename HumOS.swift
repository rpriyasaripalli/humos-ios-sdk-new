//
//  HumOS.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 3/28/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//


import Foundation
import Gloss

/** HumOS is a singleton class which will provide an appentry point to the Client. It encapulates  the app configuration set by the client and provides apis for registration, login and search apis.
 */
//For running test cases until server makes it optional.
internal var pushToken:String = "B9805BC498BA6B62F1C005EF372677D983FFB0FAB381B7629A0D01BFC628D46D"

private enum Keys : String {
    case Registered = "registered"
    case LastActiveTime = "last_active_time"
}


public class HumOS :NSObject {
    
    var appConfig:HumOSAppConfig!
    var _humOSUser:HumOSUser?
    var _userRegistered:Bool = true
    var _userLoggedIn:Bool?
    var _verificationToken:String?
    
    static private var sdkInitialized:Bool = false;
    static private var sharedInstance:HumOS?
    
    internal init(appConfig:HumOSAppConfig) {
        super.init();
        self.appConfig = appConfig
    }
    
    /**
     *  Returns the shared instance of the SDK.
     *
     *  - param: HumOSAppConfig
     *
     */
    public static func getSharedInstance() throws -> HumOS {
        if(!sdkInitialized) {
            throw NSError.init(type: HumOSErrorType.SDKNotInitialized)
        }
        return sharedInstance!
    }
    
    /**
     *  Initializes the SDK with the client's app configuration.
     *
     *  - param: HumOSAppConfig
     *
     */
//    public static func initializeSDK(appConfig:HumOSAppConfig) {
//        if(sharedInstance == nil) {
//            sharedInstance = HumOS(appConfig: appConfig);
//        }
//        sdkInitialized = true;
//    }
    
    
    public class func initializeSDK(appConfig:HumOSAppConfig) throws {
        if(HumOS.sharedInstance == nil) {
            HumOS.sharedInstance = HumOS(appConfig: appConfig);
            try appConfig.setupConfig();
        }
        HumOS.sdkInitialized = true;
    }
    
    /**
     *  Register Patient. Validates and creates and HumOSUser with the provided data.
     *
     * - param: fistname lastname phoneNumbe r countryCode email completionblock that returns either error or HumOSUser object.
     *
     *
     * - throws: HumOSError
     */
    public func registerPatient(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String, completion: (humOSUser:HumOSPatientUser?, error: NSError?)->()) throws  {
        
        //Validate inputs
        try self.validateRegistrationInputs(firstName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode,email: email)
        
        //Set the user type
        appConfig.userType = HumOSUserType.Patient
        
        //register
        register(firstName, lastName:lastName, phoneNumber:phoneNumber, countryCode:countryCode, email:email, type:HumOSUserType.Patient, completion:completion)
    }
    
    /**
     *  Register Provider. Validates and creates and HumOSUser with the provided data.
     *
     * - param: fistname lastname phoneNumber countryCode email completionblock that returns either error or HumOSUser object.
     *
     *
     * - throws: HumOSError
     */
    public func registerProvider(fisrtName:String, lastName:String, phoneNumber:String, countryCode:String, email:String, completion: (humOSUser:HumOSProviderUser, error: NSError?)->()) throws  {
        try self.validateRegistrationInputs(fisrtName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode, email: email)
        //Create patient or provider. reutrns EXIST if user already exists.
    }

    /**
     *  Login Patient.
     *
     *  - param: fistname lastname phoneNumber countryCode email completionblock
     *   HumOSUser
     *
     */
    public func loginPatient(userName:String, password:String, completion: (humOSUser:HumOSPatientUser?, error: NSError?)->()) {
        
//        HumOSCloud.loginUser(userName, password: password, token:self.appConfig.pushToken , usertype: self.appConfig.userType.rawValue, success: {data in
//                let result = data["response"]!["result"] as! String
//                if(result == "error") {
//                    completion(humOSUser: (self.humOSUser as? HumOSPatientUser), error: NSError.init(type: HumOSErrorType.CouldNotLoginUser))
//                } else {
//                    let status = data["response"]!["user"]!!["status"] as! String
//                    if(status != "ACTIVATED") {
//                        completion(humOSUser: (self.humOSUser as? HumOSPatientUser), error: NSError.init(type: HumOSErrorType.UserNotActivated))
//                    }
//                    self._humOSUser = HumOSPatientUser.init(json: data["response"]!["user"]! as! JSON)
//                    self.saveSession()
//                    completion(humOSUser: self._humOSUser as? HumOSPatientUser, error: nil)
//            }
//            }, andFailure: { (error) in
//                completion(humOSUser: self.humOSUser as? HumOSPatientUser, error: error)
//        })
        
        HumOSLoginService.login(userName, password: password, accessToken: self.appConfig.pushToken, type:HumOSUserType.Patient, completion:completion)
        
    }
    
    /**
     *  Login Provider
     *
     *  - param: fistname lastname phoneNumber countryCode email completionblock
     *   HumOSUser
     *
     */
    public func loginProvider(userName:String, password:String, completion: (error: NSError?)->()) {}
    
    /**
     *  Logout
     *
     *  - param: accessToken completionblock
     *   HumOSUser
     *
     */
    public func logout(completion: (error: NSError?)->()) throws{
        
        if(self._humOSUser == nil || (self._humOSUser?.accessToken)! == nil) {
            throw NSError.init(type: HumOSErrorType.UserNotLoggedIn)
        }
        
        HumOSLoginService.logout((self._humOSUser?.accessToken)!, pushToken: self.appConfig.pushToken, completion:completion)
    }
    
    
    /** Validates the given verification code. This method needs to be called after generating a verification code.
     - param: verificationCode completionBlock returning error
     */
    public func createVerificationLink(username:String, completion: (message:String?, error: NSError?)->()){
        
        HumOSLoginService.createVerificationLink(username, completion:{ token, message, error in
            if(error != nil) {
                completion(message: nil, error: error)
            } else {
                self._verificationToken = token
                completion(message: message, error: nil)
            }
        })
    }


    /** Finishes resets the password with new password.
     - param: password completionBlock returning error
     */
    public func resetPassword(newPassword: String, completion: (error: NSError?)->()) throws {
        if(self._verificationToken == nil || (self._verificationToken?.isEmpty)!) {
            throw NSError.init(type: HumOSErrorType.UserNotVerified)
        }
        if(newPassword.isEmpty) {
            throw NSError.init(type: HumOSErrorType.EmptyPassword)
        }
        HumOSLoginService.forgotPassword(self._verificationToken!, newPassword:newPassword, completion: completion)
    }

    /**
     *  Search for Providers by page.
     *
     *  - param: pageNumber specialites phoneNumber latitude longitude completionblock that returns either error or an array of HumOSProvider objects
     *
     *
     */
    public func findProviders(sikkaPreferred:Bool, specialites:NSArray, latitude:String, longitude:String, pageNumber:Int, pageSize:Int, completion: (providers:[HumOSProvider]?, pagingInfo:PagingInfo?, error: NSError?)->()){
        
        HumOSSikkaProvidersService.serachProviders(sikkaPreferred, latitude: latitude, longitude: longitude, specialities: specialites, pageNum: pageNumber, pageSize: pageSize, completion:completion)
    
    }

    
    /**
     *  Returns the User object saved.
     *
     *  - return: HumOSUser
     *
     *  - throws: HumOSError
     */
    public func getUser() throws -> HumOSUser{
        //If the session is active return User, else create a new User.
        if((humOSUser.accessToken.isEmpty)) {
            throw NSError.init(type: HumOSErrorType.SessionExpired)
        }
        return humOSUser
    }
    
    /**
     *  Client needs to call this methhod whenever a push notification for SDK is recieved.
     *
     *  - return: HumOSUser
     *
     *  - throws: HumOSError
     */
    public func handlePushNotification() throws -> HumOSUser{
        //If the session is active return User, else create a new User.
        if((humOSUser.accessToken.isEmpty)) {
            throw NSError.init(type: HumOSErrorType.SessionExpired)
        }
        return humOSUser
    }
    
    /**
     *  Start logging.
     *
     *
     *
     *  - throws: HumOSError
     */
    public func startLogging() throws {
        //If nog path throw error
     }

    /**
     *  Stop logging.
     *
     *
     *
     *  - throws: HumOSError
     */
    public func stopLogging() throws {
        //If nog path throw error
    }
    /**
     *  Stop logging.
     *
     *
     *
     *  - throws: HumOSError
     */
    public func enableLogging(enable:Bool) throws {
        //If nog path throw error
    }
    
    public func getUser() {
    }
    
    //MARK: - validation methods
    internal func validateRegistrationInputs(fisrtName:String, lastName:String, phoneNumber:String, countryCode:String, email:String) throws {
        
        if(fisrtName.isEmpty) {
            throw NSError.init(type: HumOSErrorType.FirstNameRequired)
        }
        if(lastName.isEmpty) {
            throw NSError.init(type: HumOSErrorType.LastNameRequired)
        }
        if(phoneNumber.isEmpty) {
            throw NSError.init(type: HumOSErrorType.PhoneNumberRequired)
        }
        if(countryCode.isEmpty) {
            throw NSError.init(type: HumOSErrorType.CountryCodeRequired)
        }
        if(!email.isEmpty && email.rangeOfString("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", options:NSStringCompareOptions.RegularExpressionSearch) == nil) {
            throw NSError.init(type: HumOSErrorType.invalidEmail)
        }
    }
    
    private func register(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String, type:HumOSUserType, completion: (humOSUser:HumOSPatientUser?, error: NSError?)->()) {
        
        //create the dictionary with required data
//        let paramDict = ["first_name":firstName, "last_name":lastName, "phone":countryCode+phoneNumber, "email":email];
        switch type {
            case HumOSUserType.Patient:
//                HumOSCloud.createPatient(paramDict, withSuccessHandler: { data , status in
//                    if(status != nil) {
//                        var errorType: HumOSErrorType
//                        if(status == "EXISTS") {
//                            errorType = HumOSErrorType.UserAlreadyExists
//                        }
//                        else {
//                            errorType = HumOSErrorType.ServerError
//                        }
//                        completion(humOSUser: self.humOSUser as! HumOSPatientUser, error: NSError.init(type: errorType))
//                    }
//                    let user = self.createPatientUser(firstName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode, email: email, data: data)
//                   // self.userRegistered()
//                    completion(humOSUser: user, error: nil)
//                    }, andFailure: { error in
//                        completion(humOSUser: self.humOSUser as! HumOSPatientUser, error: error)
//                        NSLog("error - %s", error.description)
//                        
//                })
                HumOSLoginService.createPatient(firstName, lastName: lastName, phoneNumber: phoneNumber, countryCode: countryCode, email: email, type:HumOSUserType.Patient, completion: { (humOSUser, error) in
                    if(error != nil) {
                        completion(humOSUser: nil, error: error)
                    }
                    else {
                        completion(humOSUser: humOSUser, error: error)
                    }
                })
                break
            case HumOSUserType.Provider: break
        }
        
    }
    
    
    private func createPatientUser(firstName:String, lastName:String, phoneNumber:String, countryCode:String, email:String, data:NSDictionary) -> HumOSPatientUser{
        
        _humOSUser = HumOSPatientUser(json:data as! JSON)
        _humOSUser?.firstName = firstName
        _humOSUser?.lastName = lastName
        _humOSUser?.email = email
        _humOSUser?.phone = phoneNumber
        let patient = HumOSPatient(json:data as! JSON)
        patient!.firstName = firstName
        patient!.lastName = lastName
        patient!.email = email
        patient!.phone = phoneNumber
        let user = self.humOSUser as! HumOSPatientUser
        user.patientProfile = patient;
        user.saveSession()
        return user

    }
    
    internal func clearSession() {
        self.humOSUser.clearSession()
        _humOSUser = nil
    }

    internal func saveSession() {
        _humOSUser!.saveSession()
    }
    
    internal func isUserRegistered() -> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey(Keys.Registered.rawValue) as! Bool;
    }
    
//    internal func userRegistered() {
//        NSUserDefaults.standardUserDefaults().setObject(true, forKey:Keys.Registered.rawValue);
//        NSUserDefaults.standardUserDefaults().synchronize();
//    }
    
    public func updateLastActiveTime() {
        NSUserDefaults.standardUserDefaults().setObject(NSDate.init(), forKey:Keys.LastActiveTime.rawValue);
    }

    public func isSessionExpired() -> Bool{
        if(!isUserRegistered()) {return false}
        if(humOSUser.accessToken == "") {return true}
        let lastActiveTime = NSUserDefaults.standardUserDefaults().objectForKey(Keys.LastActiveTime.rawValue) as! NSDate
        let now=NSDate.init();
        let components:NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: lastActiveTime, toDate:now, options:NSCalendarOptions.WrapComponents)
        if (components.minute>15) {return true}
        return false;
    }
    
    
    public var userRegistered: Bool {
        get {
            if(NSUserDefaults.standardUserDefaults().objectForKey(Keys.Registered.rawValue) != nil) {
                _userRegistered = (NSUserDefaults.standardUserDefaults().objectForKey(Keys.Registered.rawValue) as? Bool)!
            }
            return _userRegistered
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(true, forKey:Keys.Registered.rawValue);
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    }
    
    public var humOSUser:HumOSUser {
        get {
            if(self.userRegistered && _humOSUser == nil) {
                _humOSUser = HumOSUser.populateFromCache()
            }
            return _humOSUser!
        }
    }

    
}

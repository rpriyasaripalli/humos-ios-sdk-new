//
//  HumOSServerCommnds.swift
//  HumOS_SDK_iOS
//
//  Created by Ratna.Saripalli on 5/30/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation
import Alamofire
struct HumOSServerConfig {
    static let productionURL = "https://sikkacfprovider.mybluemix.net"
    static  let stagingURL = "https://humos-staging.mybluemix.net"
    static let apiVersion = "/api/v2"
    static let requestTimeout = 120.0
}

internal class HumOSServerCommands: NSObject {
    
    static var sharedInstance:HumOSServerCommands?
    var environment:HumOSEnvironmentType
    var baseURL:String
    
    init(environment:HumOSEnvironmentType) {
        self.environment = environment
        switch self.environment {
            case HumOSEnvironmentType.Production:
                baseURL = HumOSServerConfig.productionURL
            default:
                baseURL = HumOSServerConfig.stagingURL
        }
        super.init()
    }
    
    internal class func initializeServer(environment:HumOSEnvironmentType) {
        if(HumOSServerCommands.sharedInstance == nil) {
            HumOSServerCommands.sharedInstance = HumOSServerCommands(environment: environment);
        }
    }
    
    internal func get(endpoint:String, headers:[String: String]?, params:[String: AnyObject]?, completion:(json:NSObject?, error:NSError?)->()) {
        
        let url = createURL(endpoint, params: params)
        print("Request URL \(url)")
        
        let request = NSMutableURLRequest(URL: url, cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval:HumOSServerConfig.requestTimeout)
        request.HTTPMethod = "GET";
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        sendDataRequest(request, completion:completion)
//        let response = sendRequest(request)
//        completion(json: response.json, error: response.error)
    }

    
    internal func delete(endpoint:String, headers:[String: String]?, params:[String: AnyObject]?, completion:(json:NSObject?, error:NSError?)->()) {
        
        let url = createURL(endpoint, params: params)
        print("Request URL \(url)")
        
        let request = NSMutableURLRequest(URL: url, cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval:HumOSServerConfig.requestTimeout)
        request.HTTPMethod = "DELETE";
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //sendDataRequest(request, completion:completion)
        let response = sendRequest(request)
        completion(json: response.json, error: response.error)
    }
    
    internal func post(endpoint:String, headers:[String: String]?, params:[String: AnyObject]?, body:NSDictionary?, completion:(json:NSObject?, error:NSError?)->()) {
        
//         Alamofire.request(
//            .POST,
//            self.baseURL+HumOSServerConfig.apiVersion+endpoint,
//            parameters: params,
//            encoding:.JSON,
//            headers: headers)
//            .validate()
//            .responseJSON{ (response) -> Void in
//                guard response.result.isSuccess else {
//                    print("Error posting data: \(response.result.error)")
//                    completion(json: nil, error: response.result.error)
//                    return
//                }
//                guard let json = response.result.value as? [String: AnyObject] else {
//                    completion(json: [String](), error: nil)
//                    return
//                }
//                completion(json: json, error: nil)
//            }
        
        let url = createURL(endpoint, params: params)
        print("Request URL \(url)")

        let request = NSMutableURLRequest(URL: url, cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval:HumOSServerConfig.requestTimeout)
        request.HTTPMethod = "POST";
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(body!, options: [])
            let postBody = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
            request.HTTPBody = postBody.dataUsingEncoding(NSUTF8StringEncoding);
            print("Request Body \(postBody)")

        }catch {
            print("json error: \(error)")
        }

//        let result = NetworkingUtil.JSONToData(body!)
//        guard result.error == nil else {
//            completion(json: nil, error: result.error)
//            return
//        }
//        for (key, value) in headers! {
//            request.addValue(value as String, forHTTPHeaderField: key)
//        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        sendDataRequest(request, completion:completion)
//        let response = sendRequest(request)
//        completion(json: response.json, error: response.error)
    }
    
    
    private func createURL(endpoint:String, params:NSDictionary?) -> NSURL {
        var firstParam = true
        var urlString = self.baseURL+HumOSServerConfig.apiVersion+endpoint
        for (key, value) in params! {
            if(firstParam) {
                urlString += "?" + (key as! String) + "=" + (value as! String)
                firstParam = false
            } else {
                urlString += "&" + (key as! String) + "=" + (value as! String)
            }
        }
        return  NSURL(string: urlString)!
    }
    
//    private func sendRequest(request:NSURLRequest, completion: (json:NSObject?, error:NSError?)->()) {
//        var response: NSURLResponse?
//        var data:NSData = NSData.init()
//        
//        
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
////            do {
////                NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:{ data, response, error in
////                    //No error
////                    if ((response as! NSHTTPURLResponse).statusCode  >= 200 && (response as! NSHTTPURLResponse).statusCode < 300) {
////                        if(data != nil) {
////                            do try{
////                                
////                            }
////                        }
////                    
////                    });
//
//                data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
//                do {
//                    let json = try NSJSONSerialization.JSONObjectWithData(data, options:[])
//                        print("Response from DISPATCH ASYNC \(json)")
//                        completion(json: json as? NSObject, error: nil)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                    completion(json: nil,error: error)
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//                completion(json: nil,error: error)
//            }
//        }
//    }
    
    
    private func sendRequest(request:NSURLRequest) -> (json:NSDictionary?, response:NSURLResponse?, error:NSError?) {
        var response: NSURLResponse?
        var data:NSData = NSData.init()
        
        do {
            data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as? AnyObject {
                    print("Response from DISPATCH ASYNC \(json)")
                    print (json.isKindOfClass(NSArray))
                    if (json.isKindOfClass(NSArray)) {
                        let arrayOfJson = ["array":json]
                        return (arrayOfJson, response, nil)
                    }
                    return(json as? NSDictionary,response, nil)
                } else{
                    print(data)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                return(nil,nil,error)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return(nil,nil,error)
        }
        return(nil, nil, nil)
    }
    
    
    private func sendDataRequest(request:NSMutableURLRequest, completion:(json:NSObject?, error:NSError?)->()){
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:{ data, response, error in

            //No error
            let httpSatusCode = (response as? NSHTTPURLResponse)!.statusCode
            if (httpSatusCode  >= 200 && httpSatusCode < 300) {
                if(data != nil && data?.length > 0) {
                    let result = NetworkingUtil.dataToJSON(data!)
                    print("Response from server \(result.json)")
                    completion(json: result.json, error: result.error)
                }
                else {
                    completion(json: nil, error: nil)
                }
            }
            
            if (httpSatusCode  >= 400 && httpSatusCode < 500) {
                completion(json: nil, error: NSError.init(type: HumOSServerErrorType.ClientError, localizedMessage: NSHTTPURLResponse.localizedStringForStatusCode(httpSatusCode)))
            }
        });
        
        task.resume()
    }
    
    
    


    
}
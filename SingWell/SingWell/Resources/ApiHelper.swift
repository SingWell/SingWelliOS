//
//  ApiHelper.swift
//  
//
//  Created by Travis Siems on 11/8/17.
//

import Foundation
import Alamofire
import SwiftyJSON

let PRODUCTION_ENV = "http://ec2-34-215-244-252.us-west-2.compute.amazonaws.com/"



class ApiHelper {
    static var userId = "4"
    static var AUTH_TOKEN = ""
    
    //Had to create new post method in order to save userID value
    static func login(_ user: String, _ password: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (JSON?, Error?) -> ()){
        let parameters = [
            "email": user,
            "password": password
        ]
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(environment + "login/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("LOGIN - ",JSON(value))
                    completionHandler(JSON(value), nil)
                    AUTH_TOKEN = JSON(value)["token"].stringValue
                case .failure(let error):
                    print("ERROR LOGGING IN!", error)
                    completionHandler(nil, error)
                }
        }
    }
    
    //Had to create new post method in order to save userID value
    static func register(email: String, firstname: String, lastname: String, password: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (JSON?, Error?) -> ()){
        let parameters = [
            "email": email,
            "first_name":firstname,
            "last_name":lastname,
            "password": password
        ]
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(environment + "register", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completionHandler(JSON(value), nil)
                    print("REGISTER VALUE:", value)
//                    AUTH_TOKEN = JSON(value)["token"].stringValue
                case .failure(let error):
                    print("ERROR REGISTERING!", error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makeGetCall(_ section: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        print("\(section)")
        let headers = ["Authorization": "Token \(AUTH_TOKEN)"]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        
        Alamofire.request(environment+"\(section)", headers:headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("VALUE FOR \(section)",value)
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    print("ERROR FOR \(section)",error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makePostCall(_ section: String, environment:String=PRODUCTION_ENV, _ parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
        //let params = ["consumer_key":"key", "consumer_secret":"secret"]
        //TODO: NEED PARAMS AS FUNCTION PARAMETER
        let headers = ["Authorization": "Basic \(AUTH_TOKEN)"]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        print("\(parameters)")
        
        Alamofire.request(environment+"\(section)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
//    static func makePutCall(_ section: String, environment:String=PRODUCTION_ENV, _ parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
//        //let params = ["consumer_key":"key", "consumer_secret":"secret"]
//        //TODO: NEED PARAMS AS FUNCTION PARAMETER
//        let headers = ["Authorization": "Basic \(AUTH_TOKEN)"]
//        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
//        print("\(parameters)")
//
//        Alamofire.request(environment+"\(section)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .responseString { response in
//                switch response.result {
//                case .success(let value):
//                    print("VALUE FOR \(section)",value)
//                    completionHandler(JSON(value), nil)
//                case .failure(let error):
//                    print("ERROR FOR \(section)",error)
//                    completionHandler(nil, error)
//                }
//        }
////            .responseString { response in
////                guard response.result.error == nil else {
////                    // got an error in getting the data, need to handle it
////                    print("error calling PUT on /profile")
////                    print(response.result.error!)
////                    return
////                }
////                // make sure we got some JSON since that's what we expect
////                guard (response.result.value as? [String: Any]) != nil else {
////                    print("didn't get todo object as JSON from API")
////                    print("Error: \(String(describing: response.result.error))")
////                    return
////                }
////        }
//    }
    
    static func makePutCall(_ section: String, environment:String=PRODUCTION_ENV, _ parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
        //let params = ["consumer_key":"key", "consumer_secret":"secret"]
        //TODO: NEED PARAMS AS FUNCTION PARAMETER
        let headers = ["Content-Type": "application/json", "Authorization" : "Token \(AUTH_TOKEN)"]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        print("\(parameters)")
        
        Alamofire.request(environment+"\(section)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    print("VALUE FOR \(section)",value)
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    print("ERROR FOR \(section)",error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makeDeleteCall(_ section: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        print("\(section)")
        let headers = ["Authorization": "Basic \(AUTH_TOKEN)"]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        
        Alamofire.request(environment+"\(section)", method: .delete, headers:headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    
    //this will get user for a specific id
    static func getUser(userId:String=userId, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("users/\(userId)/", completionHandler: completionHandler)
    }
    
    //this will edit user for a specific id
    static func editUser(userId:String=userId, parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makePutCall("profile/", parameters, completionHandler: completionHandler)
    }
    
    //this is for testing edit user TO BE DELETED later
    static func getProfile(userId:String=userId, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("profile/",completionHandler: completionHandler)
    }
    
    //this will get all organizations
    static func getOrganizations( completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations", completionHandler: completionHandler)
    }
    
    //this will get a specific organization
    static func getOrganization(orgId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations/\(orgId)/", completionHandler: completionHandler)
    }
    
    //this will get choirs for a specific organization
    static func getChoirs(orgId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("choirs/", completionHandler: completionHandler)
    }
    
    //this will get choirs for a user
    static func getChoirs(userId:String=userId, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("users/\(userId)/choirs", completionHandler: completionHandler)
    }
    
    //this will get a specific choir
    static func getChoir(orgId:String, choirId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("choirs/\(choirId)/", completionHandler: completionHandler)
    }
    
    //this will get events for a organization
    static func getEvents(orgId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations/\(orgId)/events/", completionHandler: completionHandler)
    }
    
    //this will get a roster for a specific choir
    static func getRoster(orgId:String, choirId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("choirs/\(choirId)/roster/", completionHandler: completionHandler)
    }
    
    //this will get musicRecords for a organization
    static func getMusicRecords(orgId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("/musicRecords", completionHandler: completionHandler)
    }
    
    
}

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
            "username": user,
            "password": password
        ]
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(environment + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completionHandler(JSON(value), nil)
                    AUTH_TOKEN = JSON(value)["token"].stringValue
                case .failure(let error):
                    print("ERROR LOGGING IN!", error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makeGetCall(_ section: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        print("\(section)")
        let headers = ["Authorization": "Basic \(AUTH_TOKEN)"]
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
    
    
    //this will get choirs for a specific organization
    static func getUser(userId:String=userId, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("users/\(userId)/", completionHandler: completionHandler)
    }
    
    //this will get all organizations
    static func getOrganizations( completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations", completionHandler: completionHandler)
    }
    
    //this will get a specific organization
    static func getOrganization(orgId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations/\(orgId)", completionHandler: completionHandler)
    }
    
    //this will get choirs for a specific organization
    static func getChoirs(orgId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations/\(orgId)/choirs", completionHandler: completionHandler)
    }
    
    //this will get choirs for a user
    static func getChoirs(userId:String=userId, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("users/\(userId)/choirs", completionHandler: completionHandler)
    }
    
    //this will get a specific choir
    static func getChoir(orgId:String, choirId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations/\(orgId)/choirs/\(choirId)", completionHandler: completionHandler)
    }
    
    //this will get a roster for a specific choir
    static func getRoster(orgId:String, choirId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations/\(orgId)/choirs/\(choirId)/roster", completionHandler: completionHandler)
    }
    
}

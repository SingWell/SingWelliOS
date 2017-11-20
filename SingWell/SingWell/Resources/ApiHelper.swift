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
    static var userId = "1"
    
    //TODO: Replace userID with actual userID value sent in body of request
    //Had to create new post method in order to save userID value
//    static func login(_ section: String, _ user: String, _ password: String, completionHandler: @escaping (JSON?, Error?) -> ()){
//        //let params = ["consumer_key":"key", "consumer_secret":"secret"]
//        let parameters = [
//            "username": user,
//            "password": password
//        ]
//
//        //sets timeout
//        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
//        Alamofire.request("http://ec2-34-209-20-30.us-west-2.compute.amazonaws.com/API/\(section)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    completionHandler(JSON(value), nil)
//                    print(JSON(value)[0]["userID"])
//                case .failure(let error):
//                    completionHandler(nil, error)
//                }
//        }
//    }
    
    static func makeGetCall(_ section: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (JSON?, Error?) -> ()) {
        //let params = ["consumer_key":"key", "consumer_secret":"secret"]
        print("\(section)")
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(environment+"\(section)")
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
        //let params = ["consumer_key":"key", "consumer_secret":"secret"]
        print("\(section)")
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        
        Alamofire.request(environment+"\(section)", method: .delete)
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
    
    //this will get a specific choir
    static func getChoir(orgId:String, choirId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("organizations/\(orgId)/choirs/\(choirId)", completionHandler: completionHandler)
    }
    
}

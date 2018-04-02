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
    static var userId = "77"
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
                    
                    if JSON(value)["token"] != JSON.null {
                        print("setting AUTH_TOKEN and userId")
                        AUTH_TOKEN = JSON(value)["token"].stringValue
                        ApiHelper.userId = JSON(value)["user_id"].stringValue
                        UserDefaults.standard.set(AUTH_TOKEN, forKey: kToken)
                        UserDefaults.standard.set(ApiHelper.userId, forKey: kUserId)
                        print("USER ID IS NOW: ", ApiHelper.userId)
                    }
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    print("ERROR LOGGING IN!", error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func logout() {
        AUTH_TOKEN = ""
        ApiHelper.userId = ""
        UserDefaults.standard.removeObject(forKey: kToken)
        UserDefaults.standard.removeObject(forKey: kUserId)
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
                    print("REGISTER - ", value)
//                    AUTH_TOKEN = JSON(value)["token"].stringValue
                case .failure(let error):
                    print("ERROR REGISTERING!", error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makeGetCall(_ section: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
//        print("\(section)")
        let headers = ["Authorization": "Token \(AUTH_TOKEN)"]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        
        Alamofire.request(environment+"\(section)", headers:headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
//                    print("VALUE FOR \(section)",value)
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    print("ERROR FOR \(section)",error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makePostCall(_ section: String, environment:String=PRODUCTION_ENV, _ parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
        let headers = ["Content-Type": "application/json", "Authorization" : "Token \(AUTH_TOKEN)"]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
//        print("\(parameters)")
        
        Alamofire.request(environment+"\(section)", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makePutCall(_ section: String, environment:String=PRODUCTION_ENV, _ parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
        let headers = ["Content-Type": "application/json", "Authorization" : "Token \(AUTH_TOKEN)"]
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
//        print("\(parameters)")
        
        Alamofire.request(environment+"\(section)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                switch response.result {
                case .success(let value):
//                    print("VALUE FOR \(section)",value)
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    print("ERROR FOR \(section)",error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makePatchCall(_ section: String, environment:String=PRODUCTION_ENV, _ parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
        let headers = ["Content-Type": "application/json", "Authorization" : "Token \(AUTH_TOKEN)"]
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: [.prettyPrinted]) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        //        print("\(parameters)")
        
        Alamofire.request(environment+"\(section)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    //                    print("VALUE FOR \(section)",value)
                    completionHandler(JSON(value), nil)
                case .failure(let error):
                    print("ERROR FOR \(section)",error)
                    completionHandler(nil, error)
                }
        }
    }
    
    static func makeFileCall(_ section: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (String?, Error?) -> ()) {
        //        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        Alamofire.request(environment+"\(section)", encoding: JSONEncoding.default).responseString { response in
            //            print(response)
            completionHandler(response.value, response.error)
            
        }
    }
    
    static func getProfilePic(_ section: String, environment:String=PRODUCTION_ENV, completionHandler: @escaping (String?, Error?) -> ()) {
        //        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        let headers = ["Content-Type": "application/json", "Authorization" : "Token \(AUTH_TOKEN)"]
        
        Alamofire.request(environment+"\(section)", encoding: JSONEncoding.default, headers: headers).responseString { response in
            //            print(response)
            completionHandler(response.value, response.error)
            
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
    
    static func uploadImage(image: UIImage, fileName:String, completionHandler: @escaping (String?, Error?) -> ()){
        //        let imageData = UIImagePNGRepresentation(image)!
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let parameters = [
            "id": userId,
            "picture_type" : "profile"
        ]
        
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 10
        let url = "http://ec2-34-215-244-252.us-west-2.compute.amazonaws.com/pictures/"
        
        Alamofire.upload(
        
            multipartFormData: { (multipartFormData) in
                
                multipartFormData.append(imageData! as Data, withName: fileName, fileName: "profilePic.jpg", mimeType: "image/jpg")
                
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
        },
            to: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
//                        debugPrint(response)
                        completionHandler(response.data?.base64EncodedString(),nil)
                    }
                    
                    
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        //   var section = "users/\(userId)/classes/\(courseId)/\(material)/\(materialId)/files/"
    }
    
    static func downloadPDF(path:String, resourceID:String, recordID:String, completionHandler: @escaping (String?, Error?) -> ()) {
        makeFileCall("resource/?resource_id=\(resourceID)&record_id=\(recordID)", completionHandler: completionHandler)
    }
    
    static func getPicture(path:String, id:String, type:String, completionHandler: @escaping (String?, Error?) -> ()) {
        getProfilePic("pictures/?id=\(id)&picture_type=\(type)", completionHandler: completionHandler)
    }
    
    //this will get user for a specific id
    static func getUser(userId:String=userId, completionHandler: @escaping (JSON?, Error?) -> ()) {
        print("GETTING USER!!",userId)
        makeGetCall("users/\(userId)/", completionHandler: completionHandler)
    }
    
    //this will edit user for a specific id
    static func editUser(userId:String=userId, parameters: Parameters, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makePatchCall("users/\(userId)/", parameters, completionHandler: completionHandler)
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
        makeGetCall("choirs/?organization=\(orgId)", completionHandler: completionHandler)
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
        makeGetCall("events/", completionHandler: completionHandler)
    }
    
    //this will get a roster for a specific choir
    static func getRoster(orgId:String, choirId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("choirs/\(choirId)/roster/", completionHandler: completionHandler)
    }
    
    //this will get musicRecords for a organization
    static func getMusicRecords(orgId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("/musicRecords", completionHandler: completionHandler)
    }
    
    //this will get a specific musicRecord
    static func getMusicRecord(musicId:String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        makeGetCall("/musicRecords/\(musicId)", completionHandler: completionHandler)
    }
    
    
}

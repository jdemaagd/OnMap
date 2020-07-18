//
//  Client.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/28/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

import Foundation

class Client: NSObject {
    
    struct Auth {
        static var firstName = ""
        static var key = ""
        static var lastName = ""
        static var objectId = ""
        static var sessionId: String? = nil
    }
       
    enum Endpoints {
       
        static let base = "https://onthemap-api.udacity.com/v1"
       
        case addLocation
        case login
        case signup
        case studentLocations
        case updateLocation
        case userProfile

        var stringValue: String {
            switch self {
                case .addLocation:
                    return Endpoints.base + "/add-location"
                case .login:
                    return Endpoints.base + "/session"
                case .signup:
                    return "https://auth.udacity.com/sign-up"
                case .studentLocations:
                    return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
                case .updateLocation:
                    return Endpoints.base + "/update-location"
                case .userProfile:
                    return Endpoints.base + "/users/" + Auth.key
            }
        }
       
        var url: URL {
            return URL(string: stringValue)!
        }
    }
   
    override init() {
        super.init()
    }

    class func shared() -> Client {
        struct Singleton {
            static var shared = Client()
        }
        return Singleton.shared
    }

    class func addLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        taskForPOSTRequest(url: Endpoints.addLocation.url, apiType: "Parse", responseType: PostResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response, response.createdAt != nil {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    
    class func getLoggedInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.userProfile.url, apiType: "Udacity", responseType: UserProfile.self) { (response, error) in
            if let response = response {
                print("First Name : \(response.firstName) && Last Name : \(response.lastName) && Full Name: \(response.nickname)")
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                print("Failed to get user's profile.")
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentInformation]?, Error?) -> Void) {
        
        taskForGETRequest(url: Endpoints.studentLocations.url, apiType: "Parse", responseType: StudentLocation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
   
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        taskForPOSTRequest(url: Endpoints.login.url, apiType: "Udacity", responseType: LoginResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                getLoggedInUserProfile(completion: { (success, error) in
                    if success {
                        print("Logged in user's profile fetched.")
                    }
                })
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error logging out.")
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }

    class func taskForGETRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue(K.ApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(K.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, body: String, httpMethod: String, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        if httpMethod == "POST" {
            request.httpMethod = "POST"
        } else {
            request.httpMethod = "PUT"
        }
        if apiType == "Udacity" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                if apiType == "Udacity" {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } else {
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

    class func updateLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"
        taskForPOSTRequest(url: Endpoints.updateLocation.url, apiType: "Parse", responseType: PutResponse.self, body: body, httpMethod: "PUT") { (response, error) in
            if let response = response, response.updatedAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
    }
}

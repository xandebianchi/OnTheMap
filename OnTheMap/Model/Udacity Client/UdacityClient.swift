//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 11/01/21.
//

import Foundation

class UdacityClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        struct Auth {
            static var uniqueKey = ""
        }
        
        case getUdacitySignUpPage
        case login
        case getStudentLocations
        case postStudentLocation
        case getPublicUserData
        
        var stringValue: String {
            switch self {
            case .getUdacitySignUpPage:
                return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            case .login:
                return Endpoints.base + "/session"
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .getPublicUserData:
                return Endpoints.base + "/users/\(Auth.uniqueKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if error != nil { // Handle error…
                return
            }
            let decoder = JSONDecoder()
            print(String(data: data, encoding: .utf8))
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, AppError(message: "Invalid Response."))
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, AppError(message: "Invalid Response."))
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: LoginRequest(username: username, password: password)) { (response, error) in
            if let response = response {
                Endpoints.Auth.uniqueKey = response.account.key
                completion(response.account.registered, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, response: StudentLocationResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostLocationResponse.self, body: PostLocationRequest(uniqueKey: Endpoints.Auth.uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longituede: longitude)) { (response, error) in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getPublicUserData(completion: @escaping (String?, String?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getPublicUserData.url, response: UserDataResponse.self) { (response, error) in
            if let response = response {
                completion(response.user.firstName, response.user.lastName, nil)
            } else {
                completion(nil, nil, error)
            }
        }
    }
    
}

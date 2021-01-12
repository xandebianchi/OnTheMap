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
        
        case getUdacitySignUpPage
        case login
        
        var stringValue: String {
            switch self {
            case .getUdacitySignUpPage:
                return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            case .login:
                return Endpoints.base + "session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (Bool?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(false, error)
//                }
//                return
//            }
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count
            //let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(responseObject, nil)
//                }
//            } catch {
//                do {
//                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(nil, errorResponse)
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(nil, error)
//                    }
//                }
//            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: LoginRequest(username: username, password: password)) { (response, error) in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
}

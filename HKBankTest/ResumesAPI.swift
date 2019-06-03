//
//  ResumesAPI.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-05-31.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import Foundation

enum ResumesAPI {
    
    enum RequestMethod: String {
        case get     = "GET"
        case post    = "POST"
        case put     = "PUT"
    }
    
    enum RequestErrors: Error {
        case invalidURL
        case jsonProcessingFailed
        case netConnectionFailed
        case returnedDataNil
    }
    
    case resumes(queryParas: [String:String]?, bodyParas: [String:String]?)
    case imgData(path: String)
    
    // MARK: - base URL
    var baseURL: String {
        switch self {
        default:
            return "https://gist.githubusercontent.com/mmrobert"
        }
    }
    
    // MARK: - RequestMethod
    var method: RequestMethod {
        switch self {
        case .resumes( _, _):
            return .get
        case .imgData( _):
            return .get
        }
    }
    
    // MARK: - path string
    var path: String {
        switch self {
        case .resumes( _, _):
            return "/57ecbb85421f97515a6d49a81b4c256e/raw/e8491c1f950c0b0e4c25fc9823b5969e9d5d2299/resumes"
        case .imgData(let urlPath):
            return urlPath
        }
    }
    
    // like ...?key=value
    var queryItems: [URLQueryItem]? {
        switch self {
        case .resumes(let queryParas, _):
            if let _queryParas = queryParas {
                return _queryParas.map({
                    URLQueryItem(name: $0.key, value: $0.value)
                })
            } else {
                return nil
            }
        case .imgData( _):
            return nil
        }
    }
    
    // MARK: - Parameters for body
    var bodyParameters: [String:String]? {
        switch self {
        case .resumes( _, let bodyParas):
            return bodyParas
        case .imgData( _):
            return nil
        }
    }
    
    // MARK: - URLRequest creating
    func getURLRequest() throws -> URLRequest {
        
        guard var urlComponent = URLComponents(string: baseURL + path) else { throw RequestErrors.invalidURL }
        
        if let query = queryItems {
            urlComponent.queryItems = query
        }
        
        guard let url = urlComponent.url else { throw RequestErrors.invalidURL }
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Parameters
        if let _bodyParameters = bodyParameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: _bodyParameters, options: [])
            } catch {
                throw RequestErrors.jsonProcessingFailed
            }
        }
        return urlRequest
    }
    
    // MARK: - network by urlsession
    func netWorks(request: URLRequest, completion: @escaping (Result<Data, RequestErrors>) -> Void) {
        let defaultSession = URLSession(configuration: .default)
        
        let dataTask = defaultSession.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(Result.failure(RequestErrors.netConnectionFailed))
                }
            } else if let data = data {
                DispatchQueue.main.async {
                    completion(Result.success(data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(Result.failure(RequestErrors.returnedDataNil))
                }
            }
        }
        dataTask.resume()
    }
}



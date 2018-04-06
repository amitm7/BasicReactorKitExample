//
//  AlogorythmaNetworkLayer.swift
//  Algorythma
//
//  Created by Amit Mishra on 26/03/18.
//  Copyright © 2018 Amit Mishra. All rights reserved.
//



import Foundation
import Moya

// MARK: - Provider setup

import UIKit
import Moya
import RxSwift
import Mapper
import Moya_ModelMapper



struct NetworkAdapterSigned {
 
    static let rskProvider = MoyaProvider<Algorythma>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    
    static func request(target: Algorythma, success successCallback: @escaping (Observable<Response>) -> (), error errorCallback: @escaping (RSError) -> (), failure failureCallback: @escaping (MoyaError) ->  ()) {
        
         rskProvider.rx.request (target)
        .asObservable()
        .do( onNext: {
            ( response) in
            print( "index %d - progress %lf", index, response)
            let observableResponse:Observable<Response> = Observable<Response>.from(optional: response)
            successCallback(observableResponse)
        }, onError: { error in
            let resultError  = RSError.errorResponseFromServer(domain: "Algorythma", code: 300, description: "Data Not availiable", statusKey: "none")
            errorCallback(resultError)
            print( error.localizedDescription)
            
            
        }, onCompleted: {
            print("process Done")
        }, onSubscribe: {
            print("process subscrib")
            
        }, onSubscribed: {
           
            
        }, onDispose: {
            print("process disposed")
            
        }).subscribe(onNext: { subscriberesponse in
            let observableResponse:Observable<Response> = Observable<Response>.from(optional: subscriberesponse)
           // successCallback(observableResponse)
        }, onError: {error in print(error)}, onCompleted:  {print("subscribe process subscribed")}, onDisposed:  {print(" subscribeprocess disposed")})

  }
    static func request1(_ token: Algorythma) -> Observable<Response> {
        
        // Creates an observable that starts a request each time it's subscribed to.
        return rskProvider.rx.request (token)
.debug()
            .map { response -> Response in
                guard let responseDict = try? response.mapJSON() as! [AnyHashable:Any],
                    let owner: AnyObject = responseDict["movies"] as AnyObject,
                    let newData = try? JSONSerialization.data(withJSONObject: owner, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                        return response
                }
                
                let newResponse = Response(statusCode: response.statusCode, data: newData, response: response.response)
                return newResponse
            }.asObservable()
        
    }
    
  static func request(
        _ target: Algorythma,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) -> Single<Response> {
        let requestString = "\(target.method) \(target.path)"
        return rskProvider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                   // log.debug(message, file: file, function: function, line: line)
            },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                           // log.warning(message, file: file, function: function, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            //log.warning(message, file: file, function: function, line: line)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                           // log.warning(message, file: file, function: function, line: line)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                       // log.warning(message, file: file, function: function, line: line)
                    }
            },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
            }
        )
    }
    
    
    
    
    
    static func requestWithObservable(_ target: Algorythma) ->  Observable<Response>{
      return  rskProvider.rx.request (target)
            .asObservable()
    }
    
}
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}


// MARK: - Provider support

//private extension String {
//    var urlEscaped: String {
//        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//    }
//}

public enum Algorythma {
    
    case searchMovie(searchText: String)
    
}

extension Algorythma: TargetType {
    public var baseURL: URL { return URL(string: "http://api.themoviedb.org")! }
    public var path: String {
        switch self {
        case .searchMovie:
            return "3/search/movie"
       
            
        }
    }
    public var method: Moya.Method {
        switch self {
        
        default:
            return .get
            
        }
    }
    
    public var task: Task {
        switch self {
        case .searchMovie(let searctext):
            return .requestParameters(parameters: ["api_key" : "2696829a81b1b5827d515ff121700838","query" : searctext], encoding: URLEncoding.queryString)
        default:
        return .requestPlain
        }
    }
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    public var sampleData: Data {
        switch self {
        
        default:
            return "{\"login\": \"Amit\", \"id\": 100}".data(using: String.Encoding.utf8)!
            
        }
    }
    public var headers: [String: String]? {
        return ["Content-Type":"application/json"]
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}



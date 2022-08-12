//
//  AppUrlRequest.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import Foundation
import Alamofire
enum AppUrlRequest: URLRequestConvertible {
    case getListNews(page: Int, searchString: String?)
    
    private var baseUrl: String {
        return APIConstant.baseUrl
    }
    
    private var path: String? {
        switch self {
        case .getListNews:
            return "everything"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getListNews:
            return .get
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .getListNews(let page, let searchString):
            return ["q": "\(searchString ?? "iOS")",
                    "page": page,
                    "pageSize": 10,
                    "apiKey": APIConstant.apiKey]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path ?? ""))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                print("Encoding fail")
            }
        }
        
        return urlRequest
    }
}


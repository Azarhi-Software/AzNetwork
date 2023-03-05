//
//  AzAuthorization.swift
//  AZNetwork
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public enum AzAuthorization {
    case basic(String, String)
    case bearer(String)
    case custom(String)
}

extension AzAuthorization
{
    func encoded() throws -> String
    {
        switch self
        {
            case .basic(let username, let password):
                let token = "\(username):\(password)".data(using: .utf8)
                guard let token = token else {
                    throw AzAuthorizationError.invalidBasicToken
                }
                return "Basic \(token.base64EncodedString())"
                
            case .bearer(let token):
                return "Bearer \(token)"
                
            case .custom(let custom):
                return custom
        }
    }
}

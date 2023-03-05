//
//  AzHTTPMethod.swift
//  AzNetwork
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public enum AzHTTPMethod: String
{
    case delete, get, patch, post, put
}

extension AzHTTPMethod
{
    var value: String
    {
        return rawValue.uppercased()
    }
    
}

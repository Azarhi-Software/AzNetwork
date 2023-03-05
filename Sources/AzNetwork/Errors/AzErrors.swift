//
//  AzErrors.swift
//  AzNetwork
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public enum AzAuthorizationError: Error
{
    case invalidBasicToken
}


public enum AzURLRequestError: Error
{
    case invalidHost
    case invalidPath
    case invalidMethod
    case invalidURL
    case invalidFormData
}


public enum AzURLSessionError: Error
{
    case unknown
}

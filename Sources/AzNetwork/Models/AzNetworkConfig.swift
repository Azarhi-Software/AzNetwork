//
//  AzNetworkConfig.swift
//  AZNetwork
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public struct AzNetworkConfig
{
    public var host: String
    public var decoder: JSONDecoder
    public var encoder: JSONEncoder
    public var authorization: AzAuthorization?
    
    public init(host: String, decoder: JSONDecoder = .normal, encoder: JSONEncoder = .normal, authorization: AzAuthorization? = nil)
    {
        self.host = host
        self.decoder = decoder
        self.encoder = encoder
        self.authorization = authorization
    }
}

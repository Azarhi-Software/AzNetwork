//
//  JSONEncoder+.swift
//  AZNetwork
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public extension JSONEncoder
{
    static var normal: JSONEncoder
    {
        return JSONEncoder()
    }
    
    static var snakeCase: JSONEncoder
    {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

//
//  JSONDecoder+.swift
//  AZNetwork
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public extension JSONDecoder
{
    static var normal: JSONDecoder
    {
        return JSONDecoder()
    }
    
    static var snakeCase: JSONDecoder
    {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

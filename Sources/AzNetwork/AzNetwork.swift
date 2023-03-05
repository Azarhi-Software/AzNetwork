//
//  AzNetwork.swift
//  AzNetowrk
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public class AzNetwork
{
    public private(set) var version = "0.0.1"
    
    public var builder = AzRequestBuilder()
    public var config: AzNetworkConfig
    
    
    public init(_ config: AzNetworkConfig)
    {
        self.config = config
    }
    
    public init(host: String, decoder: JSONDecoder = .normal, encoder: JSONEncoder = .normal, authorization: AzAuthorization? = nil)
    {
        self.config = AzNetworkConfig(host: host, decoder: decoder, encoder: encoder, authorization: authorization)
    }
    
    
    public func setAuthorization(_ auth: AzAuthorization)
    {
        self.config .authorization = auth
    }
    
     
    public func send<T: Decodable>(request: URLRequest, decoder: JSONDecoder) async throws -> T
    {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    continuation.resume(throwing: error ?? AzURLSessionError.unknown)
                    return
                }
                
                do {
                    let result = try decoder.decode(T.self, from: data)
                    continuation.resume(returning: result)
                }
                catch
                {
                    continuation.resume(throwing: error)
                }
            }
            .resume()
        }
    }
    
    public func get<T: Decodable>(from path: String) async throws -> T
    {
        let request = try builder(for: .get, with: path)
            .build()
        
        return try await send(request: request, decoder: config.decoder)
    }
    
    public func get<T: Decodable>(with parameters: [String: String], from path: String) async throws -> T
    {
        let queries = parameters.map(URLQueryItem.init)
        let request = try builder(for: .get, with: path)
            .set(queries: queries)
            .build()
        
        return try await send(request: request, decoder: config.decoder)
    }
    
    public func post<T: Decodable>(_ form: [String: String], to path: String) async throws -> T
    {
        let request = try builder(for: .post, with: path)
            .set(body: form)
            .build()
        
        return try await send(request: request, decoder: config.decoder)
    }
    
    public func post<T: Encodable, U: Decodable>(_ request: T, to path: String) async throws -> U
    {
        let request = try builder(for: .post, with: path)
            .set(body: request, encoder: config.encoder)
            .build()
        
        return try await send(request: request, decoder: config.decoder)
    }
    
    public func put<T: Decodable>(_ form: [String: String], to path: String) async throws -> T
    {
        let request = try builder(for: .put, with: path)
            .set(body: form)
            .build()
        
        return try await send(request: request, decoder: config.decoder)
    }
    
    public func put<T: Encodable, U: Decodable>(_ request: T, to path: String) async throws -> U
    {
        let request = try builder(for: .put, with: path)
            .set(body: request, encoder: config.encoder)
            .build()
        
        return try await send(request: request, decoder: config.decoder)
    }
    
    public func builder(for method: AzHTTPMethod, with path: String) throws -> AzRequestBuilder
    {
        let builder = AzRequestBuilder()
            .set(host: config.host)
            .set(path: path)
            .set(method: method)
        
        if let authorization = config.authorization
        {
            return try builder
                .add(authorization: authorization)
        }
        
        return builder
    }
}

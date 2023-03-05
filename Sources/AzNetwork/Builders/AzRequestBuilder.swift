//
//  AzRequestBuilder.swift
//  AzNetwork
//
//  Created by Jon Flowers on 3/4/23.
//

import Foundation


public struct AzRequestBuilder
{
    var scheme: String = "https"
    var host: String?
    var path: String?
    var queries: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var method: AzHTTPMethod?
    var body: Data?
    
    public init() {}
    
    public func set(scheme: String) -> AzRequestBuilder
    {
        var builder = self
        builder.scheme = scheme
        return builder
    }
    
    public func set(host: String) -> AzRequestBuilder
    {
        var builder = self
        builder.host = host
        return builder
    }
    
    public func set(path: String) -> AzRequestBuilder
    {
        var builder = self
        builder.path = path
        return builder
    }
    
    public func set(queries: [URLQueryItem]) -> AzRequestBuilder
    {
        var builder = self
        builder.queries = queries
        return builder
    }
    
    public func add(query: URLQueryItem) -> AzRequestBuilder
    {
        var builder = self
        builder.queries.append(query)
        return builder
    }
    
    public func add(query name: String, value: String) -> AzRequestBuilder
    {
        let query = URLQueryItem(name: name, value: value)
        return add(query: query)
    }
    
    public func set(headers: [String: String]) -> AzRequestBuilder
    {
        var builder = self
        builder.headers = headers
        return builder
    }
    
    public func add(header name: String, value: String) -> AzRequestBuilder
    {
        var builder = self
        builder.headers[name] = value
        return builder
    }
    
    public func set(method: AzHTTPMethod) -> AzRequestBuilder
    {
        var builder = self
        builder.method = method
        return builder
    }
    
    public func set(body: Data) -> AzRequestBuilder
    {
        var builder = self
        builder.body = body
        return builder
    }
    
    public func set<T: Encodable>(body: T, encoder: JSONEncoder = .normal) throws -> AzRequestBuilder
    {
        let data = try encoder.encode(body)
        return set(body: data).add(contentType: "application/json")
    }
    
    public func set(body: [String: String]) throws -> AzRequestBuilder
    {
        let form = body.reduce([String]()) { (result, entry) in
            result + ["\(entry.key)=\(entry.value)"]
        }.joined(separator: "&")
        
        guard let formData = form.data(using: .utf8) else { throw AzURLRequestError.invalidFormData }
        
        return set(body: formData).add(contentType: "application/x-www-form-urlencoded")
    }
    
    public func build() throws -> URLRequest
    {
        let url = try buildURL()
        guard let method = method else {
            throw AzURLRequestError.invalidMethod
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.value
        request.httpBody = body
        return request
    }
    
    func buildURL() throws -> URL
    {
        guard let host = host else { throw AzURLRequestError.invalidHost }
        guard let path = path else { throw AzURLRequestError.invalidPath }
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queries.isEmpty ? nil : queries
        guard let url = components.url else { throw AzURLRequestError.invalidURL }
        
        return url
    }
    
}

public extension AzRequestBuilder
{
    func add(contentType: String) -> AzRequestBuilder
    {
        return add(header: "Content-Type", value: contentType)
    }
    
    func add(authorization: AzAuthorization) throws -> AzRequestBuilder
    {
        return add(header: "AzAuthorization", value: try authorization.encoded())
    }
    
}

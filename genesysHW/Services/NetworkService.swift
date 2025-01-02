//
//
//
//  NetworkService.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decodingError: return "Failed to decode response"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchFeed(limit: Int, skip: Int) async throws -> [FeedItem]
}
final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://dummyjson.com/products"
    
    func fetchFeed(limit: Int, skip: Int) async throws -> [FeedItem] {
        guard limit > 0, skip >= 0 else {
            throw NetworkError.invalidURL
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(skip)")
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let response = try JSONDecoder().decode(FeedResponse.self, from: data)
            return response.products
        } catch {
            throw NetworkError.decodingError
        }
    }
}

//
//  MockNetworkService.swift
//  genesysHWTests
//
//  Created by Arnur Sakenov on 01.01.2025.
//

@testable import genesysHW
import Foundation

class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed = true
    var mockItems: [FeedItem] = []
    
    func fetchFeed(limit: Int, skip: Int) async throws -> [FeedItem] {
        if shouldSucceed {
            return [FeedItem(command: "TEST FEED")]
        } else {
            throw NetworkError.noData
        }
    }
}

//
//  NetworkServiceTests.swift
//  genesysHWTests
//
//  Created by Arnur Sakenov on 01.01.2025.
//

import XCTest
@testable import genesysHW

final class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    
    override func setUp() {
        super.setUp()
        sut = NetworkService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetchFeed_withValidParameters_shouldReturnItems() async {
        // Given
        let limit = 1
        let skip = 0
        
        // When
        do {
            let items = try await sut.fetchFeed(limit: limit, skip: skip)
            
            // Then
            XCTAssertFalse(items.isEmpty)
            XCTAssertEqual(items.count, 1)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_fetchFeed_withInvalidParameters_shouldHandleError() async {
        // Given
        let limit = -1
        let skip = -1
        
        // When/Then
        do {
            _ = try await sut.fetchFeed(limit: limit, skip: skip)
            XCTFail("Should throw an error for negative parameters")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

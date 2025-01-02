//
//  FeedManagerTests.swift
//  genesysHWTests
//
//  Created by Arnur Sakenov on 01.01.2025.
//

import XCTest
import Combine
@testable import genesysHW

final class FeedManagerTests: XCTestCase {
    var sut: FeedManager!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = FeedManager(networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_executeStartCommand_shouldStartFetching() {
        // Given
        let expectation = expectation(description: "Start fetching")
        var receivedItems: [FeedItem] = []
        
        sut.$newItems
            .sink { items in
                receivedItems = items
                if !items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.execute(.start)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(receivedItems.isEmpty)
    }
    
    func test_executeStartCommandTwice_shouldIgnoreSecond() {
        // Given
        let expectation = expectation(description: "Start command executed")
        var itemsReceived = 0
        
        sut.$newItems
            .sink { items in
                if !items.isEmpty {
                    itemsReceived += 1
                }
                if itemsReceived == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.execute(.start)
        sut.execute(.start) // Should be ignored
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(itemsReceived, 1)
    }
    
   
    func test_executePauseCommand_shouldHoldItems() {
        // Given
        let expectation = expectation(description: "Items held during pause")
        var receivedItems: [FeedItem] = []
        
        sut.$newItems
            .sink { items in
                receivedItems = items
            }
            .store(in: &cancellables)
        
        // When
        sut.execute(.start)
        sut.execute(.pause)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(receivedItems.isEmpty)
    }
    
    func test_executeResumeWithoutPause_shouldDoNothing() {
        // Given
        let expectation = expectation(description: "Resume without pause")
        var receivedItems: [FeedItem] = []
        
        sut.$newItems
            .sink { items in
                receivedItems = items
            }
            .store(in: &cancellables)
        
        // When
        sut.execute(.resume)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(receivedItems.isEmpty)
    }
    
    func test_executePauseResumeSequence_shouldReleaseHeldItems() {
        // Given
        let expectation = expectation(description: "Pause-Resume sequence")
        var receivedItems: [FeedItem] = []
        
        sut.$newItems
            .sink { items in
                receivedItems = items
                if !items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.execute(.start)
        sut.execute(.pause)
        sut.execute(.resume)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(receivedItems.isEmpty)
    }
}

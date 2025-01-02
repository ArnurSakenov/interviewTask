//
//  FeedViewModelTests.swift
//  genesysHWTests
//
//  Created by Arnur Sakenov on 01.01.2025.
//

import XCTest
import Combine
@testable import genesysHW

final class FeedViewModelTests: XCTestCase {
    var sut: FeedViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = FeedViewModel(networkService: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // Test all valid commands
    func test_processStartCommand_shouldAddToItems() {
        testCommand("start", expectedOutput: "START")
    }
    
    func test_processStopCommand_shouldAddToItems() {
        testCommand("stop", expectedOutput: "STOP")
    }
    
    func test_processPauseCommand_shouldAddToItems() {
        testCommand("pause", expectedOutput: "PAUSE")
    }
    
    func test_processResumeCommand_shouldAddToItems() {
        testCommand("resume", expectedOutput: "RESUME")
    }
    
    func test_processCommandCaseInsensitive_shouldWork() {
        testCommand("StArT", expectedOutput: "START")
    }
    
    func test_processInvalidCommand_shouldNotAddToItems() {
        // Given
        let expectation = expectation(description: "Items should remain empty")
        var receivedItems: [FeedItem] = []
        
        sut.$items
            .sink { items in
                receivedItems = items
            }
            .store(in: &cancellables)
        
        // When
        sut.processCommand("invalid_command")
        
        // Then
        XCTAssertTrue(receivedItems.isEmpty)
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_processEmptyCommand_shouldNotAddToItems() {
        testCommand("", expectedOutput: nil)
    }
    
    func test_processWhitespaceCommand_shouldNotAddToItems() {
        testCommand("   ", expectedOutput: nil)
    }
    private func testCommand(_ input: String, expectedOutput: String?) {
        // Given
        let expectation = expectation(description: "Command processed")
        var receivedItems: [FeedItem] = []
        
        sut.$items
            .sink { items in
                receivedItems = items
                if expectedOutput == nil && items.isEmpty {
                    expectation.fulfill()
                } else if !items.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.processCommand(input)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        if let expected = expectedOutput {
            XCTAssertEqual(receivedItems.count, 1)
            XCTAssertTrue(receivedItems.first?.isCommand ?? false)
            XCTAssertEqual(receivedItems.first?.description, expected)
        } else {
            XCTAssertTrue(receivedItems.isEmpty)
        }
    }
}

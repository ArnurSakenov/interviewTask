//
//  FeedManager.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//

import Foundation
import Combine
enum FeedCommand: String {
    case start
    case stop
    case pause
    case resume
}
final class FeedManager {
    @Published private(set) var newItems: [FeedItem] = []
    @Published private(set) var error: Error?
    
    private let networkService: NetworkServiceProtocol
    private var timer: Timer?
    private var currentSkip = 0
    private var isActive = false
    private var isPaused = false
    private var pausedItems: [FeedItem] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func execute(_ command: FeedCommand) {
        switch command {
        case .start:
            guard !isActive else { return }
            isActive = true
            startFetching()
            
        case .stop:
            isActive = false
            isPaused = false
            stopTimer()
            currentSkip = 0
            pausedItems.removeAll()
            
        case .pause:
            isPaused = true
            
        case .resume:
            guard isPaused else { return }
            isPaused = false
            newItems = pausedItems
            pausedItems.removeAll()
        }
    }
    
    private func startFetching() {
        fetchFeed()
        startTimer()
    }
    
    private func fetchFeed() {
        Task {
            do {
                let items = try await networkService.fetchFeed(limit: 1, skip: currentSkip)
                currentSkip += 1
                
                await MainActor.run {
                    if isPaused {
                        pausedItems.append(contentsOf: items)
                    } else {
                        newItems = items
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.fetchFeed()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
}

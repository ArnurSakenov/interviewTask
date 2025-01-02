//
//  FeedViewModel.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//

import Foundation
import Combine

final class FeedViewModel {
    @Published private(set) var items: [FeedItem] = []
    @Published private(set) var error: String?
    
    private let networkService: NetworkServiceProtocol
    private let feedManager: FeedManager
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.feedManager = FeedManager(networkService: networkService)
        setupBindings()
    }
    
    private func setupBindings() {
        feedManager.$newItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.items.append(contentsOf: items)
            }
            .store(in: &cancellables)
        
        feedManager.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.error = error?.localizedDescription
            }
            .store(in: &cancellables)
    }
    
    func processCommand(_ text: String) {
        guard let command = FeedCommand(rawValue: text.lowercased()) else { return }
        let commandItem = FeedItem(command: text.uppercased())
        items.append(commandItem)
        feedManager.execute(command)
    }
}

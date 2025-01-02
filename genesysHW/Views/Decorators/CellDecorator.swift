//
//  CellDecorator.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//

import UIKit

struct CellDecorator {
    let text: String
    let timestamp: String?
    let isCommand: Bool
    
    var backgroundColor: UIColor {
        isCommand ? .systemYellow : .systemGreen
    }
    
    var textAttributes: [NSAttributedString.Key: Any] {
        [
            .font: isCommand ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
    }
    
    var timestampAttributes: [NSAttributedString.Key: Any] {
        [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.darkGray
        ]
    }
    
    var attributedText: NSAttributedString {
        NSAttributedString(string: text, attributes: textAttributes)
    }
    
    var attributedTimestamp: NSAttributedString? {
        guard let timestamp = timestamp else { return nil }
        return NSAttributedString(string: timestamp, attributes: timestampAttributes)
    }
}

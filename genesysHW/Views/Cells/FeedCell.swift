//
//  FeedCell.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//

import UIKit

final class FeedCell: UITableViewCell {
    static let identifier = "FeedCell"
    // Add imageView
      private let thumbnailImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.translatesAutoresizingMaskIntoConstraints = false
          imageView.contentMode = .scaleAspectFit
          imageView.clipsToBounds = true
          imageView.layer.cornerRadius = 4
          return imageView
      }()
      
      // Update stack view to horizontal for image and content
      private let horizontalStackView: UIStackView = {
          let stack = UIStackView()
          stack.translatesAutoresizingMaskIntoConstraints = false
          stack.axis = .horizontal
          stack.spacing = 8
          stack.alignment = .center
          return stack
      }()
 
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
            selectionStyle = .none
            backgroundColor = .clear
            
            contentView.addSubview(containerView)
            containerView.addSubview(horizontalStackView)
            
            // Configure image size
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            horizontalStackView.addArrangedSubview(thumbnailImageView)
            horizontalStackView.addArrangedSubview(contentStackView)
            
            contentStackView.addArrangedSubview(messageLabel)
            contentStackView.addArrangedSubview(timestampLabel)
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                
                horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
                horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
                horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
                horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
            ])
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            thumbnailImageView.image = nil
        }
        
        func configure(with item: FeedItem) {
            messageLabel.text = item.description
            timestampLabel.text = item.timestamp.formatted(date: .omitted, time: .standard)
            containerView.backgroundColor = item.isCommand ? .systemYellow : .systemGreen
            
            // Load image if available
            if let thumbnailURL = item.thumbnail {
                ImageLoader.shared.loadImage(from: thumbnailURL) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.thumbnailImageView.image = image
                    }
                }
            } else {
                thumbnailImageView.image = nil
            }
        }
    }

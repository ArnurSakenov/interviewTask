//
//  CommandCell.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//
import UIKit

final class CommandCell: UITableViewCell {
    static let identifier = "CommandCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemYellow
        view.clipsToBounds = true
        return view
    }()
    
    private let commandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(commandLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            commandLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            commandLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            commandLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            commandLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with command: String) {
        commandLabel.text = command.uppercased()
    }
}

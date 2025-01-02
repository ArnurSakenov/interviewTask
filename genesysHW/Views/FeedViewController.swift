//
//  FeedViewController.swift
//  genesysHW
//
//  Created by Arnur Sakenov on 29.12.2024.
//
import UIKit
import Combine

final class FeedViewController: UIViewController {
    private let viewModel = FeedViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
        table.register(CommandCell.self, forCellReuseIdentifier: CommandCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private lazy var commandTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Enter command (start/stop/pause/resume)"
        field.borderStyle = .roundedRect
        field.delegate = self
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .send
        return field
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardHandling()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Feed Display"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(commandTextField)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            commandTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            commandTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commandTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commandTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            commandTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupBindings() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(error)
            }
            .store(in: &cancellables)
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Helper Methods
    private func scrollToBottom() {
        guard !viewModel.items.isEmpty else { return }
        let lastIndex = IndexPath(row: viewModel.items.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        tableView.contentInset.bottom = keyboardFrame.height + 44
        tableView.scrollIndicatorInsets.bottom = keyboardFrame.height + 44
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        tableView.contentInset.bottom = 44
        tableView.scrollIndicatorInsets.bottom = 44
    }
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        
        if item.isCommand {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CommandCell.identifier,
                for: indexPath
            ) as! CommandCell
            cell.configure(with: item.description)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: FeedCell.identifier,
                for: indexPath
            ) as! FeedCell
            cell.configure(with: item)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITextFieldDelegate
extension FeedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let command = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !command.isEmpty else {
            return false
        }
        
        viewModel.processCommand(command)
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}

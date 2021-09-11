//
//  ListViewController.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import UIKit

class ListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableView.self,
                           forCellReuseIdentifier: ListUserTableViewCell.identifier)
        return tableView
    }()
    enum ListType {
        case followers(user: User)
        case following(user: User)
        case likers(usernames: [String])
        
        var title: String{
            switch self {
            case .followers:
                return "Followers"
            case .following:
                return ""
            case .likers:
                return "Liked by"
            }
        }
    }
    
    let type: ListType
    private var viewModels: [ListUserTableViewCellViewModel] = []
    
    //MARK: - init
    
    init(type: ListType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        title = type.title
        tableView.delegate = self
        tableView.dataSource = self
        configureViewModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func configureViewModels() {
        switch type {
        case .followers(user: let targetUser):
            DatabaseManager.shared.followers(for: targetUser.username) { [weak self] usernames in
                self?.viewModels = usernames.compactMap ({
                    ListUserTableViewCellViewModel(imageUrl: nil, username: $0)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

            }
        case .following(user: let targetUser):
            DatabaseManager.shared.following(for: targetUser.username) { [weak self] usernames in
                self?.viewModels = usernames.compactMap ({
                    ListUserTableViewCellViewModel(imageUrl: nil, username: $0)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        case .likers(usernames: let usernames):
            viewModels = usernames.compactMap({
                ListUserTableViewCellViewModel(imageUrl: nil, username: $0)
            })
            tableView.reloadData()
        }
    }
    
}
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListUserTableViewCell.identifier,
                                                       for: indexPath) as? ListUserTableViewCell  else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let username = viewModels[indexPath.row].username
        DatabaseManager.shared.findUser(with: username) { [weak self] user in
            if let user = user {
                DispatchQueue.main.async {
                    let vc = ProfileViewController(user: user)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

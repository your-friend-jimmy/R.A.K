//
//  NotificationViewController.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import UIKit

class NotificationViewController: UIViewController {
    
    private let noActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notification"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        tableView.register(FollowNotificationTableViewCell.self, forCellReuseIdentifier: FollowNotificationTableViewCell.identifer)
        tableView.register(LikeNotificationTableViewCell.self, forCellReuseIdentifier: LikeNotificationTableViewCell.identifer)
        tableView.register(CommentNotificationTableViewCell.self, forCellReuseIdentifier: CommentNotificationTableViewCell.identifer)
        return tableView
    }()
    
    private var viewModels: [NotificationCellType] = []
    private var models: [RAKNotification] = []
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotifications()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noActivityLabel.sizeToFit()
        noActivityLabel.center = view.center
    }
    
    func fetchNotifications()  {
        NotificationsManager.shared.getNotifications {[weak self] notifications in
            DispatchQueue.main.async {
                self?.models = self!.models
                self!.createViewModels()
            }
        }
        noActivityLabel.isHidden = false
    }
    
    func createViewModels() {
        models.forEach { model  in
            guard let type = NotificationsManager.RAKType(rawValue: model.notificationType)else {return}
            let username = model.username
            guard let profilePictureUrl = URL(string: model.profilePictureUrl),
                  let date = model.dateString else {return}
            switch type {
            
            case .like:
                guard let postUrl = URL(string: model.postUrl ?? "") else {return}
                viewModels.append(.like(viewModel: LikeNotificationCellViewModel(
                                            username: username,
                                            profilePictureUrl: profilePictureUrl,
                                            postUrl: postUrl,
                                            date: date)))
            case .comment:
                guard let postUrl = URL(string: model.postUrl ?? "") else {return}
                viewModels.append(.comment(viewModel: CommentNotificationCellViewModel(
                                            username: username,
                                            profilePictureUrl: profilePictureUrl,
                                            postUrl: postUrl,
                                            date: date)))
            case .follow:
                guard let isFollowing = model.isFollowing else {return}
                viewModels.append(.follow(viewModel: FollowNotificationCellViewModel(
                                            username: username,
                                            profilePictureUrl: profilePictureUrl,
                                            isCurrentUserFollowing: isFollowing,
                                            date: date)))
            }
        }
        if viewModels.isEmpty {
            noActivityLabel.isHidden = false
            tableView.isHidden = true
        }else {
            noActivityLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func mockData() {
        tableView.isHidden = false
        guard let postUrl = URL(string: "https://iosacademy.io/assets/images/courses/swiftui.png") else {
            return
        }
        guard let iconUrl = URL(string: "https://iosacademy.io/assets/images/brand/icon.jpg") else {
            return
        }
        
        viewModels = [
            .like(
                viewModel: LikeNotificationCellViewModel(
                    username: "kyliejenner",
                    profilePictureUrl: iconUrl,
                    postUrl: postUrl,
                    date: "March 12"
                )
            ),
            .comment(
                viewModel: CommentNotificationCellViewModel(
                    username: "jeffbezos",
                    profilePictureUrl: iconUrl,
                    postUrl: postUrl,
                    date: "March 12"
                )
            ),
            .follow(
                viewModel: FollowNotificationCellViewModel(
                    username: "zuck21",
                    profilePictureUrl: iconUrl,
                    isCurrentUserFollowing: true,
                    date: "March 12"
                )
            )
        ]
        
        tableView.reloadData()
    }
}

//MARK: - Table
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .follow(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? FollowNotificationTableViewCell else {fatalError()}
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .like(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? LikeNotificationTableViewCell else {fatalError()}
            cell.configure(with: viewModel)
            return cell
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as? CommentNotificationTableViewCell else {fatalError()}
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let username: String
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .follow( let viewModel):
            username = viewModel.username
        case .like(let viewModel):
            username = viewModel.username
        case .comment( let viewModel):
            username = viewModel.username
        }
        //MARK: - Fix update
        DatabaseManager.shared.findUser(with: username) {[weak self] user in
            guard let user = user else {
                //MARK: - Show error alert here.
                return
                
            }
            
            DispatchQueue.main.async {
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
//MARK: - Actions
extension NotificationViewController: LikeNotificationTableViewCellDelegate, CommentNotificationTableViewCellDelegate, FollowNotificationTableViewCellDelegate {
    func likeNotificationTableViewCell(_ cell: LikeNotificationTableViewCell, didTapPostWith viewModel: LikeNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {switch $0 {
        case .follow, .comment:
            return false
        case .like(let current):
            return current == viewModel
        }
        }) else {
            return
        }
        
        openPost(with: index, username: viewModel.username, postID: nil)
    }
    
    func commentNotificationTableViewCell(_ cell: CommentNotificationTableViewCell, didTapPostWith viewModel: CommentNotificationCellViewModel) {
        guard let index = viewModels.firstIndex(where: {switch $0 {
        case .follow, .like:
            return false
        case .comment(let current):
            return current == viewModel
        }
        }) else {
            return
        }
        openPost(with: index, username: viewModel.username, postID: nil )
        
    }
    func followNotificationTableViewCell(_ cell: FollowNotificationTableViewCell, didTapButton isFollowing: Bool, viewModel: FollowNotificationCellViewModel) {
        let username = viewModel.username
        DatabaseManager.shared.updateRelationship(state: isFollowing ? .follow : .unfollow, for: username) { [weak self] success in
            if !success{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Whoops", message: "Unble to perform action.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    func openPost(with index: Int,username: String, postID: String?){
        print(index)
        guard index < models.count else {
            return
        }
        let model = models[index]
        let username = username
        guard let postID = model.postId else { return }
        // find post by id from particular user
        DatabaseManager.shared.getPost(
            with: username,
            from: postID
        ) {[weak self] post  in
            DispatchQueue.main.async {
                guard let post = post else {
                    let alert = UIAlertController(
                        title: "Ooops",
                        message: "We are unable to open this post",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    return
                }
                let vc = PostViewController(post: post)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

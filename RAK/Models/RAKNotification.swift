//
//  Notification.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import Foundation

struct RAKNotification: Codable {
    let identifer: String
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let profilePictureUrl: String
    let username: String
    let dateString: String
    // Follow/Unfollow
    let isFollowing: Bool?
    // Like/Comment
    let postId: String?
    let postUrl: String?
}

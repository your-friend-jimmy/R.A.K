//
//  NotificationsManager.swift
//  RAK
//
//  Created by James Phillips on 8/6/21.
//

import Foundation

final class NotificationsManager{
    static let shared = NotificationsManager()
    
    enum RAKType: Int {
        case like = 1
        case comment = 2
        case follow = 3
    }
    
    private init(){}
    
    public func getNotifications(completion: @escaping ([RAKNotification])-> Void){
        DatabaseManager.shared.getNotifications(completion: completion)
    }
    
    public func create(
        notification: RAKNotification,
        for username: String
    ){
        
    }
}

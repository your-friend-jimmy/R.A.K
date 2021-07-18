//
//  DatabaseManager.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import FirebaseFirestore
import Foundation

final class DatabaseManager {
    static var shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
}

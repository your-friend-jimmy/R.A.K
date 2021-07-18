//
//  StorageManager.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import FirebaseStorage
import Foundation

final class StorageManger {
    static var shared = StorageManger()
    
    private init() {}
    
    let storage = Storage.storage()
}


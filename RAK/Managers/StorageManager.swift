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
    
    private let storage = Storage.storage().reference()
    
    
    public func downloadURL(for post: Post, completion: @escaping (URL?) -> Void){
        guard let ref = post.storageReference else {
            completion(nil)
            return
        }
        
        storage.child(ref).downloadURL { url,_ in
            completion(url)
        }
    }
    
    public func profilePictureURL(for username: String, completion: @escaping (URL?) -> Void){
        storage.child("username/profile_picture.png").downloadURL { url,_ in
            completion(url)
        }
    }
    
    
    public func uploadPost(
        data: Data?,
        id: String,
        completion: @escaping (URL?)-> Void
    ){
        guard let data = data,
              let username = UserDefaults.standard.string(forKey: "username")  else { return }
        
        let ref = storage.child("\(username)/posts/\(id).png")
        ref.putData(data, metadata: nil) { _, error in
            ref.downloadURL { (url,_) in
                completion(url)
            }
        }
    }
    
    public func uploadProfilePicture(
        username: String,
        data: Data?,
        completion: @escaping (Bool)-> Void
    ){
        guard let data = data else { return }
        storage.child("\(username)/profile_picture.png").putData(data, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
}


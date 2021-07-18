//
//  AuthManager.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//
import FirebaseAuth
import Foundation

final class AuthManager {
    static var shared = AuthManager()
    
    private init() {}
    
    let auth = Auth.auth()
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(email: String,
                       password: String,
                       completion: @escaping (Result<User,Error>)->Void){
        
    }
    
    public func signUp(email: String,
                       password: String,
                       profilePicture:Data?,
                       completion: @escaping (Result<User,Error>)->Void){
        
    }
    
    public func signOut(completion: @escaping (Bool)-> Void) {
        
    }
}

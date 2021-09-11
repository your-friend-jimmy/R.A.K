//
//  PostViewController.swift
//  instagram
//
//  Created by James Phillips on 7/17/21.
//

import UIKit

class PostViewController: UIViewController {
    let post: Post
    
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

}

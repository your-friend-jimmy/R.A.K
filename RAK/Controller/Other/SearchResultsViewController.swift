//
//  SearchResultsViewController.swift
//  
//
//  Created by James Phillips on 8/6/21.
//

import UIKit

protocol SearchResultsiewControllerDelegate: AnyObject {
    func searchResultsviewController(_ vc: SearchResultsViewController, didSelectResultWith user: User)
}


class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableView.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var user = [User]()
    
    public weak var delegate: SearchResultsiewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with results: [User])  {
        self.user = results
        tableView.reloadData()
        tableView.isHidden = user.isEmpty
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsviewController(self,
                                              didSelectResultWith: user[indexPath.row])
    }
}

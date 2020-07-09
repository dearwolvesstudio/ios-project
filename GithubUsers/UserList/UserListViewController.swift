//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by dearwolves on 7/8/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import UIKit
import PaginatedTableView

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: PaginatedTableView!
    
    let service = UserRestService()
    
    var list = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        
        
        tableView.loadData(refresh: true)
        
    }

}

extension UserListViewController: PaginatedTableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        if(pageNumber == 1) {
            self.list = [User]()
        }
        
        let startFrom = (self.list.last?.id ?? 0)
        
        service.getUsers(since: startFrom) { (users) in
            self.list.append(contentsOf: users)
            DispatchQueue.main.async {
                onSuccess?(!users.isEmpty)
            }
            
        }
        
    }
}

extension UserListViewController: PaginatedTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if((self.list[indexPath.row].note) != nil) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.label.text = "\(self.list[indexPath.row])"
            return cell
        } else if(indexPath.row != 0 && (indexPath.row + 1) % 4 == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InvertTableViewCell", for: indexPath) as? InvertTableViewCell else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.label.text = "\(self.list[indexPath.row])"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell", for: indexPath) as? NormalTableViewCell else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.label.text = "\(self.list[indexPath.row])"
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//    }
}

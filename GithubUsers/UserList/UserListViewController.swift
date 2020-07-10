//
//  UserListViewController.swift
//  GithubUsers
//
//  Created by dearwolves on 7/8/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import UIKit
import PaginatedTableView
import CoreData

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: PaginatedTableView!
    
    let service = UserRestService()
    
    var list = [User]()
    var users: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        
        
        tableView.loadData(refresh: true)
        
        self.fetchUsers()
        
    }

}

extension UserListViewController: PaginatedTableViewDelegate {
    // will create service for this
    func save(users: [User]) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let entity = NSEntityDescription.entity(forEntityName: "UserDAO", in: managedContext)!
            
            for user in users {
                let data = NSManagedObject(entity: entity, insertInto: managedContext)
                data.setValue(user.login, forKey: "login")
                data.setValue(user.id, forKey: "id")
                data.setValue(user.html_url, forKey: "html_url")
                data.setValue(user.avatar_url, forKey: "avatar_url")
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchUsers() {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDAO")
            
            do {
                let users: [NSManagedObject] = try managedContext.fetch(fetchRequest)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
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
            self.save(users: users)
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
            cell.setCell(user: self.list[indexPath.row])
            return cell
        } else if(indexPath.row != 0 && (indexPath.row + 1) % 4 == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InvertTableViewCell", for: indexPath) as? InvertTableViewCell else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.setCell(user: self.list[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell", for: indexPath) as? NormalTableViewCell else {
                fatalError("The dequeued cell is not an instance of TableViewCell.")
            }
            cell.setCell(user: self.list[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "UserProfileViewController") as! UserProfileViewController
        
        vc.user = list[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

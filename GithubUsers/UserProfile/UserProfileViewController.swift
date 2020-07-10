//
//  UserProfileViewController.swift
//  GithubUsers
//
//  Created by dearwolves on 7/10/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var note: UITextView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var save: UIButton!
    
    var user: User?
    
    let service = UserRestService()
    
    convenience init() {
        self.init(user: nil)
    }
    
    init(user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user?.login
        
        
        service.getUser(username: user!.login) { (user) in
            self.user = user
            self.initView()
            
        }
    }
    
    func initView() {
        DispatchQueue.main.async {
            self.follower.text = "\(self.user?.followers ?? 0)"
            self.following.text = "\(self.user?.following ?? 0)"
            
        }
        
        
        if let url = URL(string: user!.avatar_url) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let unwrappedError = error {
                    print(unwrappedError)
                    return
                }
                
                if let unwrappedData = data {
                    let image = UIImage(data: unwrappedData)
                    DispatchQueue.main.async(execute: {
                        self.avatarImageView.image = image
                    })
                }
                
            }
            dataTask.resume()
        }
    }


}

//
//  NormalTableViewCell.swift
//  GithubUsers
//
//  Created by dearwolves on 7/9/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import UIKit

class NormalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setCell(user: User) {
        usernameLabel.text = user.login
        urlLabel.text = user.html_url
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        
        if let url = URL(string: user.avatar_url) {
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

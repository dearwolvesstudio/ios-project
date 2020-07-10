//
//  InvertTableViewCell.swift
//  GithubUsers
//
//  Created by dearwolves on 7/9/20.
//  Copyright © 2020 dearwolves. All rights reserved.
//

import UIKit

class InvertTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                        let img = CoreImage.CIImage(cgImage: (image?.cgImage)!)
                        
                        let filter = CIFilter(name: "CIColorInvert")
                        filter?.setDefaults()
                        
                        filter?.setValue(img, forKey: "inputImage")
                        
                        let invert = UIImage(ciImage: (filter?.outputImage)!)
                        
                        self.avatarImageView.image = invert
                        
                    })
                }
                
            }
            dataTask.resume()
        }
    }

}

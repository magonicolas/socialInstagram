//
//  PrefCell.swift
//  devslopessocial
//
//  Created by Mago Nicolas Palacios on 8/12/16.
//  Copyright © 2016 Mago Nicolas Palacios. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell (post: Post, img: UIImage? = nil)
    {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil
        {
            self.postImg.image = img
        } else
        {
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil
                    {
                        print("Mago: Unable to download image from firebase storage")
                    } else
                    {
                        print("Mago: Image downloaded from firebase storage")
                        if let imageData = data
                        {
                            if let img = UIImage(data: imageData)
                            {
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageURL)
                                print("Mago: Save Cache")
                            }
                        }
                    }
                })
        }
    }


}

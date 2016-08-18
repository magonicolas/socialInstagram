//
//  FeedVC.swift
//  devslopessocial
//
//  Created by Mago Nicolas Palacios on 8/12/16.
//  Copyright © 2016 Mago Nicolas Palacios. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageAdd: CircleView!
    
    @IBOutlet weak var captionField: FancyField!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: Cache<NSString, UIImage> = Cache()
    var imageSelected = false
    
    @IBAction func postBtnTapped(_ sender: AnyObject)
    {
        guard let caption = captionField.text, caption != "" else {
            print("Mago: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("Mago: An Image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2)
        {
            let imageUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_iMAGES.child(imageUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil
                {
                    print("Mago: Unable to upload image to firebase storage")
                } else
                {
                    print("Mago: Succesfully uploaded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL
                    {
                        self.postToFirebase(imgUrl: url)
                    }
                    
                }
            }
        }
    }
    
    func postToFirebase (imgUrl: String)
    {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text!,
            "imageUrl": imgUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    @IBAction func addImagedTapped(_ sender: AnyObject)
    {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: AnyObject)
    {
        let keychainResult = KeychainWrapper.removeObjectForKey(key_uid)
        print("Mago: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignin", sender: nil)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot
                {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject>
                    {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            imageAdd.image = image
            imageSelected = true
        } else
        {
            print("Mago: A valid image wasn`t selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
        {

            if let img = FeedVC.imageCache.object(forKey: post.imageURL)
            {
                print("Mago: Load Cache")
                cell.configureCell(post: post, img: img)
                return cell
            } else
            {
                cell.configureCell(post: post, img: nil)
                return cell
            }
           
        } else
        {
            return PostCell()
        }
        
    }


}

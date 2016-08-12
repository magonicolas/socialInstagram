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

class FeedVC: UIViewController {

    @IBAction func signOutTapped(_ sender: AnyObject)
    {
        let keychainResult = KeychainWrapper.removeObjectForKey(key_uid)
        print("Mago: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignin", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

  


}

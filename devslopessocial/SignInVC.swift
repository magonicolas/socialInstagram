//
//  ViewController.swift
//  devslopessocial
//
//  Created by Mago Nicolas Palacios on 8/10/16.
//  Copyright © 2016 Mago Nicolas Palacios. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbButtonTapped(_ sender: AnyObject)
    {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil
            {
                print("Mago: Unable to authenticate with Facebook: \(error.debugDescription)")
            } else if result?.isCancelled == true
            {
                print("Mago: User Cancelled Facebook authentication")
            } else
            {
                print("Mago: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential)
    {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil
            {
                print("Mago: Unable to authenticate with Firebase: \(error.debugDescription)")
            } else
            {
                print("Mago: Successfully authenticated with Firebase")
            }
        })
    }

}


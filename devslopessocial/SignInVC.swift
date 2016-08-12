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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.stringForKey(key_uid)
        {
            print("Mago: ID found in Keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func signInTapped(_ sender: AnyObject)
    {
        if let email = emailField.text, let password = passwordField.text
        {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil
                {
                    print("Mago: Email user authenticated with Firebase")
                    if let user = user
                    {
                        self.completeSignIn(id: user.uid)
                    }
                } else
                {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil
                        {
                            print("Mago: Unable to authenticate with Firebase using email: \(error.debugDescription)")
                        } else
                        {
                            print("Mago: Successfully created and authenticated with Firebase email")
                            if let user = user
                            {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
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
                if let user = user
                {
                    self.completeSignIn(id: user.uid)
                }

            }
        })
    }
    
    func completeSignIn (id: String)
    {
        let keychainResult = KeychainWrapper.setString(id, forKey: key_uid)
        print("Mago: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}


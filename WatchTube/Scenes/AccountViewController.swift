//
//  AccountViewController.swift
//  WatchTube
//
//  Created by Florian Hebrard on 30/12/2017.
//  Copyright © 2017 Florian Hebrard. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class AccountViewController: UIViewController {
    
    @IBOutlet var notLoggedInView: UIView!
    @IBOutlet var loggedInView: UIView!
    @IBOutlet var signInButton: GIDSignInButton!
    @IBOutlet var signOutButton: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        self.signOutButton.layer.cornerRadius = 10
        self.signOutButton.layer.masksToBounds = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkLoginStatus()
    }
    
    func checkLoginStatus() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            DispatchQueue.main.async {
                self.loggedInView.isHidden = false
                self.notLoggedInView.isHidden = true
            }
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
            iPhoneSessionManager.sharedManager.sendAccessToken(accessToken: accessToken!)
        } else {
            DispatchQueue.main.async {
                self.loggedInView.isHidden = true
                self.notLoggedInView.isHidden = false
            }
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
        //self.loggedInView.isHidden = true
        //self.notLoggedInView.isHidden = false
        
    }
}

extension AccountViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.checkLoginStatus()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.checkLoginStatus()
    }
}

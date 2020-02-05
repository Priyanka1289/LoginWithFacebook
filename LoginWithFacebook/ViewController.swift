//
//  ViewController.swift
//  LoginWithFacebook
//
//  Created by Pari on 05/02/20.
//  Copyright © 2020 Priyanka. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        switch result {
        case .cancelled: break
            
            
        case .failed(let error): break
            
            
        case .success(let grantedPermissions, _, _):
            self.imgView.isHidden = false
            self.lblUserName.isHidden = false
            self.btnLogout.isHidden = false
            self.btnLogin.isHidden = true
            fetchUserData()
        }
    }
    
    private func fetchUserData() {
        
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.width(480).height(480)"])
        graphRequest.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Error",error!.localizedDescription)
            }
            else{
                let field = result! as? [String:Any]
                self.lblUserName.text = field!["name"] as? String
                if let imageURL = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    print(imageURL)
                    let url = URL(string: imageURL)
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    self.imgView.image = image
                }
            }
        })
    }
    
    @IBAction private func loginWithReadPermissions() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .email],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }
    
    @IBAction private func logOut() {
        let loginManager = LoginManager()
        loginManager.logOut()
        self.imgView.isHidden = true
        self.lblUserName.isHidden = true
        self.btnLogout.isHidden = true
        self.btnLogin.isHidden = false
    }
    
    
}


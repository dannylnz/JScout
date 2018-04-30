//
//  LoginViewController.swift
//  joscout ipad
//
//  Created by Daniele Lanzetta on 10.11.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField


class LoginViewController: UIViewController,UITextFieldDelegate{
    // OUTLET VAR LET
    
    

    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var pwField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    /// FUNCTIONS
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard emailField.text != "", pwField.text != "" else { return }
        Auth.auth().signIn(withEmail: emailField.text! , password: pwField.text!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                
            }
            /// Successfully Authenticated
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://joscoutingsystem.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["email": self.emailField.text!]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err!)
                    return
                }
                print("saved User Successfully!")
            })
            
            
            if let user = user {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarIdentifier")
                self.present(vc, animated: true, completion: nil)
                
            }
            
            
            
        })
        
    }
    
    
    
}

extension UIViewController {
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}



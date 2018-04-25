//
//  SignupViewController.swift
//  Login - Creating and signing users with Firebase
//
//  Created by Daniele Lanzetta on 23.03.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //Outlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var comPwField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    // Var & Let
    
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    
    
    
    // ViewDidLoad (what is loaded before app is fully loaded)
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        let storage = Storage.storage().reference(forURL: "gs://joscoutingsystem.appspot.com")
        ref = Database.database().reference()
        userStorage = storage.child("users")
        
    }
    
    
    //Actions
    
    @IBAction func selectImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            signUpBtn.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        guard nameField.text != "", emailField.text != "" , passwordField.text != "",comPwField.text != "" else {
            
            return
            
        }
        
        if passwordField.text == comPwField.text {
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if let error = error {
                    
                    print(error.localizedDescription)
                    
                    
                    if let user = user {
                        
                        
                        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                        changeRequest.displayName = self.nameField.text!
                        changeRequest.commitChanges(completion: nil)
                        
                        let imageRef =  self.userStorage.child("\(user.uid).jpg")
                        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                            if err != nil {
                                print(err!.localizedDescription)
                                
                                
                            }
                            
                            imageRef.downloadURL(completion: { (url, er) in
                                if er != nil {
                                    print(er!.localizedDescription)
                                }
                                
                                if let url = url {
                                    
                                    let userInfo : [String: Any] = ["uid": user.uid,
                                                                    "full name" : self.nameField.text!,
                                                                    "urlToImage": url.absoluteString]
                                    
                                    self.ref.child("users").child(user.uid).setValue(userInfo)
                                    
                                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                    
                                    self.present(vc, animated: true, completion: nil)
                                    
                                    self.performSegue (withIdentifier: "loginSegue", sender: self)
                                    
                                    
                                    
                                    
                                }
                                
                                
                            })
                            
                        })
                        
                        uploadTask.resume()
                        
                        
                        
                    }
                }
            })
            
        } else {
            let alert = UIAlertController(title: "Warning", message: "Password does not match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("password does not match")
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
}


//
//  PopUpViewController.swift
//  JScout
//
//  Created by Daniele Lanzetta on 17.11.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit
import Firebase


let matchVC = ViewController()


class PopUpViewController: UIViewController {

    
    
    
    @IBOutlet weak var popUpLayer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpLayer.layer.cornerRadius = 10
        
    }
    //// Outlets & Var
    
    @IBOutlet weak var teamATextField: UITextField!
    @IBOutlet weak var teamBTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func createNewMatchBtnPressed(_ sender: Any) {
        createNewMatch()
        
    }
    
    
    //// End of Outlets & Var
    
    
    //Func Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let matchVC = segue.destination as! ViewController
        
       
    }
    
    
    
    
    /// Functions

    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func createNewMatch() {
        
        let userID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        let thisUserRef = usersRef.child(userID!).child("matches")
        
        
        var newMatch = [
            "matchId" : "",
            "team A Name": teamATextField.text!,
            "team B Name": teamBTextField.text!,
            "date": dateTextField.text!,
            "location": locationTextField.text!
            ] as [String : Any]
        
       let thisUserMatchRef = thisUserRef.childByAutoId()
        let key = thisUserMatchRef.key
        newMatch["matchId"] = key
        thisUserMatchRef.setValue(newMatch)
        
        
        print(key)
        print("new Match added")
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "matchVC") as? ViewController
        {
            vc.matchId = key
            present(vc, animated: true, completion: nil)
        }
       
        
     
        
      
        
        /// Set names and location, date to match view controller
        
        //Go To Match View Controller
        
        
        
        
    }
    
    
    func fetchEntireListOfmatch() {
        
        let userID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        let thisUserRef = usersRef.child(userID!).child("matches")
        
        thisUserRef.observe(.childAdded) { (snapshot) in
            var listOfMatch = [DataSnapshot]()
            
            for item in snapshot.children {
                listOfMatch.append(item as! DataSnapshot)
                
        
    }

            
}

}


}



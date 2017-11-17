//
//  ViewController.swift
//  JScout
//
//  Created by Daniele Lanzetta on 15.11.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // ViewDidLoad - WillAppear-----------------------------------------------------------------------------
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    // end of ViewDidLoad - WillAppear--------------------------------------------------------------------
    
    
    //Outlets---------------------------------------------------------------------------------------------
    
    @IBOutlet weak var tableViewA: UITableView!
    @IBOutlet weak var tableViewB: UITableView!
    
    
    
    //End Of Outlets-------------------------------------------------------------------------
    
    
    // Func ---------------------------------------------------------------------------------------------

    func checkIfUserIsLoggedIn(){
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            print (snapshot)
        }, withCancel: nil)
        
        
    }
        
        
        // End of Func -----------------------------------------------------------------------
        
    
    
    
    
    // Table Views Settings---------------------------------------------------------------
    // TABLE VIEW LEFT == tableViewA,TableViewAName(Label Of Table view cell A),TableViewCellA (Cell Class)
    // TABLE VIEW RIGHT == tableviewB,TableViewBName(Label Of Table view cell B),TableViewCellB (Cell Class)
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableViewA){
            
            return 1  /// TEAM A PLAYERS
            
        }else if (tableView == tableViewB){
            return 1
            
        }else {
            
            return 0
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableViewA) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellA", for: indexPath) as! TableViewCellA
            cell.TableViewAName?.text = "Player A"
            return cell
            
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellB", for: indexPath) as! TableViewCellB
            cell.TableViewBName?.text = "Player B"
            return cell
            
        }
    }
    
    
    // End of Settings Table Views ---------------------------------------------------------------


}


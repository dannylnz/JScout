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
        super.viewDidLoad()
        
        // date
        
        dateLabel.text = match["date"] as? String
        
        // location
        
        locationLabel.text = match["location"] as? String
        
        // team A Name
        
        teamANameLabel.text = match["team A Name"] as? String
        
        // team B Name
        
        teamBNameLabel.text = match["team B Name"] as? String
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    // end of ViewDidLoad - WillAppear--------------------------------------------------------------------
    
    
    //Outlets---------------------------------------------------------------------------------------------
    
    @IBOutlet weak var tableViewA: UITableView!
    @IBOutlet weak var tableViewB: UITableView!
    
    @IBOutlet weak var teamANameLabel: UILabel!
    @IBOutlet weak var teamBNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var matchId = ""
    var teamAname = ""
    var match = [String:Any]()
    
    @IBAction func backBtn(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialView") as? MatchCollectionViewController
        {
            
            present(vc, animated: true, completion: nil)
        }
    
    }
    //End Of Outlets-------------------------------------------------------------------------
    
   
    
    
    
    // Func ---------------------------------------------------------------------------------------------

    func checkIfUserIsLoggedIn(){
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
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


//
//  ViewController.swift
//  JScout
//
//  Created by Daniele Lanzetta on 15.11.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit
import Firebase

private let userID = Auth.auth().currentUser?.uid
private let usersRef = Database.database().reference().child("users")
private let thisUserRef = usersRef.child(userID!).child("matches")


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // ViewDidLoad - WillAppear-----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        print(matchId!)
        populateMatch()
        
        // Design of text Fields
        designTextFields()
        populateTableViewAFromFirebase()
        populateTableViewBFromFirebase()

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
    @IBOutlet weak var textFieldA: UITextField!
    @IBOutlet weak var textFieldB: UITextField!
    
    
    // End Of Outlets--------------------------------------------------------------------------
    
    //Actions
    @IBAction func addPlayerBtnA(_ sender: Any) {
        createNewPlayerinA()
    }
    
    @IBAction func addPlayerBtnB(_ sender: Any) {
        createNewPlayerinB()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialTabBarView") as? MatchCollectionViewController
        {
            
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    // End of Actions
    
    // Var & Let
    var matchKey:String?
    var matchId:String?
    var teamAname = ""
    var match = [String:Any]()
    var playersA: [[String: Any]] = []
    var playersB: [[String: Any]] = []
    
   // End Var & Let
   
    
    // Func ---------------------------------------------------------------------------------------------
    
    func checkIfUserIsLoggedIn(){
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
        }, withCancel: nil)
        
    }
    
    func designTextFields() {
        
        /// Design of textfield A
        textFieldA.borderStyle = .none
        textFieldA.layoutIfNeeded()
        let font = UIFont(name: "Avenir", size: 20)!
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font : font]
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.yellow.cgColor
        textFieldA.attributedPlaceholder = NSAttributedString(string: "insert player name",
                                                              attributes:attributes)
        
        border.frame = CGRect(x: 0, y: textFieldA.frame.size.height - width, width:  textFieldA.frame.size.width, height: textFieldA.frame.size.height)
        border.borderWidth = width
        textFieldA.layer.addSublayer(border)
        textFieldA.layer.masksToBounds = true
        
        ///Design of textfield B
        textFieldB.borderStyle = .none
        textFieldB.layoutIfNeeded()
        textFieldB.attributedPlaceholder = NSAttributedString(string: "insert player name",
                                                              attributes:attributes)
        
        border.frame = CGRect(x: 0, y: textFieldB.frame.size.height - width, width:  textFieldB.frame.size.width, height: textFieldB.frame.size.height)
        border.borderWidth = width
        
        textFieldB.layer.addSublayer(border)
        textFieldB.layer.masksToBounds = true
        
        
        
        
    }
    
        func createNewPlayerinA() {
    
            let userID = Auth.auth().currentUser?.uid
            let usersRef = Database.database().reference().child("users")
            let thisUserRef = usersRef.child(userID!).child("matches")
            let thisUserMatchRef =  thisUserRef.child(matchId!).child("teamAPlayers").childByAutoId()
            
            
            if (textFieldA.text?.isEmpty)! {
                print("Please add a value")
            } else {
                
             
            var newPlayer = [
                "playerId": "",
                "name": textFieldA.text!,
                "date of birth": "",
                "position": "",
                "height": "",
                "nationality": ""
                ] as [String : Any]
                

                
                ///Get the key of the player and set it
                let key = thisUserMatchRef.key
                newPlayer["playerId"] = key
                
               
                /// Create new player and append it to playersA[dict]
                thisUserMatchRef.setValue(newPlayer)
                playersA.append(newPlayer)
                
                /// add to the tableview
                let indexPath = IndexPath(row: playersA.count - 1, section: 0)
                
                tableViewA.beginUpdates()
                tableViewA.insertRows(at: [indexPath], with: .automatic)
                tableViewA.endUpdates()
                
                textFieldA.text = ""
                view.endEditing(true)
                
                
            print("new player added in team A")
            
            }
    
            }
    func createNewPlayerinB() {
        
        let userID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        let thisUserRef = usersRef.child(userID!).child("matches")
        let thisUserMatchRef =  thisUserRef.child(matchId!).child("teamBPlayers").childByAutoId()
        
        
        if (textFieldB.text?.isEmpty)! {
            print("Please add a value")
        } else {
            
            
            var newPlayer = [
                "playerId": "",
                "name": textFieldB.text!,
                "date of birth": "",
                "position": "",
                "height": "",
                "nationality": ""
                ] as [String : Any]
            
            
            let key = thisUserMatchRef.key
            newPlayer["playerId"] = key
            thisUserMatchRef.setValue(newPlayer)
            playersB.append(newPlayer)
            
            
            let indexPath = IndexPath(row: playersB.count - 1, section: 0)
            
            tableViewB.beginUpdates()
            tableViewB.insertRows(at: [indexPath], with: .automatic)
            tableViewB.endUpdates()
            
            textFieldB.text = ""
            view.endEditing(true)
            
            
            print("new player added in team B")
            
        }
        
    }
  
    func populateTableViewAFromFirebase() {
        
        let teamAPlayersList =  thisUserRef.child(matchId!).child("teamAPlayers")
        
        ///retrieve all data from firebase
        teamAPlayersList.observe(.value, with: { snapshot in // we walked from user to matches
            
            var teamAPlayersList: [[String: Any]] = [] 
            
            for child in snapshot.children { // loop through children (players)
                
                guard let playerSnapshot = child as? DataSnapshot, // cast child as snapshot
                    var player = playerSnapshot.value as? [String: Any] else { // convert snapshot to dictionary
                        continue // skip if it doesn't work
                }
                
                teamAPlayersList.append(player)
                self.tableViewA.reloadData()
                print("this is team A player Snapshot of match")
                print(playerSnapshot)
                print("this is players A array Snapshot")
                print(self.playersA)
            }
            self.playersA = teamAPlayersList
            
            self.tableViewA.reloadData()
        })
        
        
    }
    func populateTableViewBFromFirebase() {
        
        let teamBPlayersList =  thisUserRef.child(matchId!).child("teamBPlayers")
        
        ///retrieve all data from firebase
        teamBPlayersList.observe(.value, with: { snapshot in // we walked from user to matches
            
            var teamBPlayersList: [[String: Any]] = []
            
            for child in snapshot.children { // loop through children (players)
                
                guard let playerSnapshot = child as? DataSnapshot, // cast child as snapshot
                    var player = playerSnapshot.value as? [String: Any] else { // convert snapshot to dictionary
                        continue // skip if it doesn't work
                }
                
                teamBPlayersList.append(player)
                self.tableViewB.reloadData()
                print("this is team A player Snapshot of match")
                print(playerSnapshot)
                print("this is players A array Snapshot")
                print(self.playersB)
            }
            self.playersB = teamBPlayersList
            
            self.tableViewB.reloadData()
        })
        
        
    }
    
    
    func populateMatch() {
        
        let populateRef = thisUserRef.child(matchId!)
        
        populateRef.observeSingleEvent(of: .value) { (snapshot) in
            
            var matchSpecs = snapshot.value as! [String: Any]
            let nameOfTeamA = matchSpecs["team A Name"] as! String
            self.teamANameLabel.text = nameOfTeamA
            let nameOfTeamB = matchSpecs["team B Name"] as! String
            self.teamBNameLabel.text = nameOfTeamB
            let location = matchSpecs["location"] as! String
            self.locationLabel.text = location
            let date = matchSpecs["date"] as! String
            self.dateLabel.text = date
            
            
            print("this is the snapshot of populate match")
            print(snapshot)
        }
            
            //read the user data from the snapshot and do whatever with it
        
        
        
    }
    
    
    // End of Func -----------------------------------------------------------------------
    

    // Table Views Settings---------------------------------------------------------------
    // TABLE VIEW LEFT == tableViewA,TableViewAName(Label Of Table view cell A),TableViewCellA (Cell Class)
    // TABLE VIEW RIGHT == tableviewB,TableViewBName(Label Of Table view cell B),TableViewCellB (Cell Class)
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == tableViewA){
            
            return playersA.count  /// TEAM A PLAYERS
            
        }else if (tableView == tableViewB){
            
            return playersB.count
            
        }else {
            
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == tableViewA) {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellA", for: indexPath) as! TableViewCellA
            
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.darkGray
            cell.TableViewAName?.text = playersA[indexPath.row]["name"] as? String
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellB", for: indexPath) as! TableViewCellB
            
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.darkGray
            cell.TableViewBName?.text = playersB[indexPath.row]["name"] as? String
            return cell
            
        }
    }
    
    // .Delete of TableViewCells
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView (_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (tableView == tableViewA)
        {
            if (editingStyle == .delete){
                let teamAPlayersList =  thisUserRef.child(matchId!).child("teamAPlayers")
                let playerId = playersA[indexPath.row]["playerId"] as? String
                
                /// remove from playerArray
                playersA.remove(at: indexPath.row)
                /// remove also from DB
                teamAPlayersList.child(playerId!).removeValue()
                tableViewA.beginUpdates()
                tableViewA.deleteRows(at: [indexPath], with: .automatic)
                tableViewA.endUpdates()
                
                
            }
            
        } else if (tableView == tableViewB)
        {
            if (editingStyle == .delete){
                let teamBPlayersList =  thisUserRef.child(matchId!).child("teamBPlayers")
                let playerId = playersB[indexPath.row]["playerId"] as? String
                /// remove from playerArray
                playersB.remove(at: indexPath.row)
                /// remove also from DB
                teamBPlayersList.child(playerId!).removeValue()
                tableViewB.beginUpdates()
                tableViewB.deleteRows(at: [indexPath], with: .automatic)
                tableViewB.endUpdates()
                
                
                /// remove also from DB
            }
            
            
        } else {
            
            return
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView == tableViewA){
            
            let teamAPlayersList =  thisUserRef.child(matchId!).child("teamAPlayers")
            let playerId = playersA[indexPath.row]["playerId"] as? String
            let playerDetailsVC = PlayerDetail()
            
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerDetail") as? PlayerDetail
            {
                vc.playerName = playersA[indexPath.row]["name"] as? String
                vc.matchId = matchId!
                
                print ("this is players A in VC")
                print (vc.playersA)
                
                vc.playerId = playersA[indexPath.row]["playerId"] as? String
                present(vc, animated: true, completion: nil)
            
            }
            
        }
        else if (tableView == tableViewB) {
            
            
        } else {
            return
            
        }
        
        
        
        
    }
    /// End of .Delete TableViewCells
    
    
    
    // End of Settings Table Views ---------------------------------------------------------------
    
    
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


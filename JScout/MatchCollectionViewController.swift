//
//  MatchCollectionViewController.swift
//  JScout
//
//  Created by Daniele Lanzetta on 16.11.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"


private let userID = Auth.auth().currentUser?.uid
private let usersRef = Database.database().reference().child("users")
private let thisUserRef = usersRef.child(userID!).child("matches")

class MatchCollectionViewController: UICollectionViewController {
    
    
    
    /// ViewDidLoad -----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBar()
     
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMatches()
        
    }
    
    
    /// END of ViewDidLoad ---------------------------------
    
    
    /// Outlets and Vars
    var countOfMatch = [match]()
    var matches: [[String: Any]] = []
    
    
    /// End of Outlets And Vars
    
    
    
    
    //// FUNCTIONS -------------------------------------
//    func getNumberOfMatches() {
//
//        thisUserRef.observe(.value, with: {  snapshot in
//
//            var tempMatches = [String]()
//            for match in snapshot.children {
//                tempMatches.append((match as AnyObject).key)
//            }
//            DispatchQueue.main.async{
////                matches = tempMatches
//
//                self.collectionView!.reloadData()
//            }
//        })
//    }
    
    
    
    func addNavigationBar() {
        
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        navbar.barStyle = UIBarStyle.black
        navbar.tintColor = UIColor.white
        navbar.delegate = self as? UINavigationBarDelegate
        let navItem = UINavigationItem()
        navItem.title = "Match Collection"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Add new match", style: .plain, target: self, action: #selector(addNewMatch))
        navbar.items = [navItem]
        view.addSubview(navbar)
        collectionView?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    
    func presentPopUp() {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpVC") as? PopUpViewController
        {
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    @objc func addNewMatch() {
        
        presentPopUp()
    }
    
    
    @objc func signOut() {
        
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "loginPage") as! LoginViewController
            self.present(vc, animated: false, completion: nil)
          
        }
        
    }
    
    func fetchMatches() {
        
        thisUserRef.observe(.value, with: { snapshot in // we walked from user to matches
            
            var matches: [[String: Any]] = [] // setup empty array of dictionaries
            
            for child in snapshot.children { // loop through children (matches)
                
                guard let matchSnapshot = child as? DataSnapshot, // cast child as snapshot
                    var match = matchSnapshot.value as? [String: Any] else { // convert snapshot to dictionary
                        continue // skip if it doesn't work
                }
                
                // let's add the id to the dictionary
                
                var matchId = matchSnapshot.key // get the id
                match["id"] = matchId
                
                
                matches.append(match) // add to array
             
                self.collectionView!.reloadData()
            }
            self.collectionView!.reloadData()
            
            
            
            self.matches = matches
            
        })
        
    }
    
    
    
    //// END OF FUNCTIONS -------------------------------------
    
    
    
   
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return matches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        cell.backgroundColor = UIColor.black
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// Handle The Taps
       
      let match = matches[indexPath.item]
        let matchVC = ViewController()
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "matchVC") as? ViewController
        {
            
        
            vc.match = match
            vc.matchId = match["id"] as? String
            present(vc, animated: true, completion: nil)
            
        }
     
        
        
        
    }
    
    }
    



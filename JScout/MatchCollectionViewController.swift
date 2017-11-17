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

var numberOfMatchesInView = 0
var matches = [String]()


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
        
        getNumberOfMatches()
        
    }
    
    
    /// END of ViewDidLoad ---------------------------------
    
    
    /// Outlets and Vars
    var countOfMatch = [match]()
    
    
    /// End of Outlets And Vars
    
    
    
    
    //// FUNCTIONS -------------------------------------
    func getNumberOfMatches() {
        
        thisUserRef.observe(.value, with: {  snapshot in
            
            var tempMatches = [String]()
            for match in snapshot.children {
                tempMatches.append((match as AnyObject).key)
            }
            DispatchQueue.main.async{
                matches = tempMatches
//                self.collectionView?.selectItem(at:IndexPath(item:1, section:0), animated:true, scrollPosition:.bottom)
                self.collectionView!.reloadData()
            }
        })
    }
    
    
    func fetchMatches() {
        
        let userID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        let thisUserRef = usersRef.child(userID!).child("matches")
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
        }
        
    }
    
    
    func addNavigationBar() {
        
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self as? UINavigationBarDelegate
        let navItem = UINavigationItem()
        navItem.title = "Title"
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
    
    
    
    
    //// END OF FUNCTIONS -------------------------------------
    
    
    
   
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let userID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        let thisUserRef = usersRef.child(userID!).child("matches")
        
        
        
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
       
        
        
        
        print("You selected cell #\(indexPath.item)!")
    }
    
}


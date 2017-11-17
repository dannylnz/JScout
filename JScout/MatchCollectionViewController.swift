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


class MatchCollectionViewController: UICollectionViewController {

    /// ViewDidLoad -----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBar()
        fetchMatches()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    /// END of ViewDidLoad ---------------------------------
    
    
    /// Outlets and Vars
    var countOfMatch = [match]()
    
    var items = ["1", "2", "3"]
    
    /// End of Outlets And Vars
    
   
   
    
    //// Functions
    
     func fetchMatches() {

        let userID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        let thisUserRef = usersRef.child(userID!).child("matches")
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            print (snapshot)
            print(userID!)
        }
    }
    

    func addNavigationBar() {
        
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self as? UINavigationBarDelegate
        let navItem = UINavigationItem()
        navItem.title = "Title"
//        navItem.leftBarButtonItem = UIBarButtonItem(title: "Left Button", style: .plain, target: self, action: nil)
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
    
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
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


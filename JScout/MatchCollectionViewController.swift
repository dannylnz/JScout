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

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMatches()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
  
   
    
    //// Functions
    
    func fetchMatches() {
//    Database.database().reference().child("users")
        
        
        let userID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        let thisUserRef = usersRef.child(userID!).child("matches")
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            print (snapshot)
            print(userID!)
            
        }
        
    }
    

        
        
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    
}


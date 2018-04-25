//
//  PlayerDetail.swift
//  JScout
//
//  Created by Daniele Lanzetta on 20.11.17.
//  Copyright © 2017 Daniele Lanzetta. All rights reserved.
//

import UIKit

class PlayerDetail: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        playerNameLabel.text = playerName
//        playerAgeLabel.text = playerAge
//        playerHeightLabel.text = playerHeight
//        playerNationalityLabel.text = playerNationality
        print (playersA)
        print(matchId)
        
    }
    // OUTLETS
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerAgeLabel: UILabel!
    @IBOutlet weak var playerHeightLabel: UILabel!
    @IBOutlet weak var playerNationalityLabel: UILabel!
    //END OF OUTLETS
    
    //VAR & LET
    var matchId:String?
    var playerName: String?
    var playerAge: String?
    var playerHeight: String?
    var playerNationality: String?
    var playerId:String?
    var playersA: [[String: Any]] = []
    var playersB: [[String: Any]] = []
    //END OF VAR & LET
    
    
    // Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
        if segue.identifier == "backtomatch"{
            var vc = segue.destination as! ViewController
            vc.matchId = matchId!
            //Data has to be a variable name in your RandomViewController
        }
    // end of Functions
    
    
}
}

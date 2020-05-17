//
//  Pill.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import Foundation
import UIKit

// Stav objektu Pill
enum PillState{
    //systémovy stav-liek sa este nenachadza v databaze
    case newPill
    // liek ktory je stale potrebne uzivat
    case inUse
    // liek ktory sa zmaze zo zoznamu
    case willRemove
}

// Pill je castou modelu. Negeneruje ziadne udalosti
class Pill {
    var pillID: String
    var name: String                //nazov lieku
    var dateBegin: String             // pociatocny datum uzivania
    var dateEnd: String               // konecny datum uzivania
    var whenTake: String              // kedy je potrebne liek uzit
    var state: PillState = .newPill
    let pillImage: UIImage? = nil  // tvar a typ lieku
    
    var showImage: UIImage {
        let _giveImage = UIImage(named: "images/defaultPill.png")!
        return _giveImage
    }
    
    // CONSTRUCTORS:
        //novy zadany liek
    init(newPill name: String,
         start dateBegin: String,
         end dateEnd: String,
         when whenTake: String,
         id pillID: String)
    {
        self.state = .newPill
        self.name = name
        self.dateBegin = dateBegin
        self.dateEnd = dateEnd
        self.whenTake = whenTake
        self.pillID = pillID
    }
        //liek nacitany z DB
    init(dbPill name: String,
         dateBegin: String,
         dateEnd: String,
         whenTake: String,
         state: PillState,
         pillID: String)
    {
        self.state = state
        self.name = name
        self.dateBegin = dateBegin
        self.dateEnd = dateEnd
        self.whenTake = whenTake
        self.pillID = pillID
    }
    
    
}

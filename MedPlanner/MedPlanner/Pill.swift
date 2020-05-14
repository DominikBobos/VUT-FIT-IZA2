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
    // aktualny stav, liek ktory uz netreba uzivat/ liek ktory je treba uzit
    case notInUse, inUse
}

// Pill je castou modelu. Negeneruje ziadne udalosti
class Pill {
    
    var name: String               //nazov lieku
    var dateBegin: Date             // pociatocny datum uzivania
    var dateEnd: Date               // konecny datum uzivania
    var whenTake: Date              // kedy je potrebne liek uzit
    var state: PillState = .newPill
    let pillImage: UIImage? = nil   // tvar a typ lieku
    
    static let __imageDefault = UIImage(named: "images/defaultPill.png")!
    
    //aby sa vzdy zobrazil nejaky obrazok
    var showImage: UIImage {
        guard let _giveImage = pillImage else { return Pill.__imageDefault}
        return _giveImage
    }
    
    // CONSTRUCTORS:
        //novy zadany liek
    init(newPill name: String,
         start dateBegin: Date,
         end dateEnd: Date,
         when whenTake: Date)
    {
        self.state = .newPill
        self.name = name
        self.dateBegin = dateBegin
        self.dateEnd = dateEnd
        self.whenTake = whenTake
    }
//        //liek nacitany z DB
//    init(dbPill name: String,
//         dateBegin: Date,
//         dateEnd: Date,
//         whenTake: DateComponents,
//         state: PillState)
//    {
//        self.state = state
//        self.name = name
//        self.dateBegin = dateBegin
//        self.dateEnd = dateEnd
//        self.whenTake = whenTake
//    }
    
    
}

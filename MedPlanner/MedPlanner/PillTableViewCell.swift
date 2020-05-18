//
//  PillTableViewCell.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//


import UIKit
import Foundation

/*
    trieda dediaca z UITableViewCell , sluzi na zobrazenie informacii v PillTableView
 */
class PillTableViewCell: UITableViewCell {
    
    
    private weak var pill: Pill?
    
    // outlety pre prvky viditelne v bunke v PillTableView
    @IBOutlet weak var PillImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var When: UILabel!
    
    
    /*
        pripravi bunku na znovu pouzitie
     */
    override func prepareForReuse() {
        setPill(nil)
    }
    /*
        vycisti outlety na default
     */
    private func clearOutlets() {
        //
        Name.text = "Medication name"
        When.text = "0:00"
        PillImage.image = nil
    }
    
    /*
        nastavenie hodnoty
     */
    private func selfConfig() {
        //
        Name.text = pill!.name
        When.text = pill!.whenTake
        PillImage.image = pill!.showImage
    }
    
    /*
        v pripade ze je objekt nil, zavola sa clearOutlets, pokial
        pill != nil nastavia sa hodnoty pocmou selfConfig
     */
    func setPill(_ setNew: Pill?) {
        pill = setNew
        if pill == nil { clearOutlets() } else { selfConfig() }
    }
}

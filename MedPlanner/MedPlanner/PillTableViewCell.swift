//
//  PillTableViewCell.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit

class PillTableViewCell: UITableViewCell {
    
    private weak var pill: Pill?
    
    //
    @IBOutlet var Name: UILabel!
    @IBOutlet var When: UILabel!
    @IBOutlet var PillImage: UIImageView!
    
    //
    override func prepareForReuse() {
        //
        setPill(nil)
    }
    
    //
    private func clearOutlets() {
        //
        Name.text = "Medication name"
        When.text = "0:00"
        PillImage.image = nil
    }
    
    //
    private func selfConfig() {
        //
        Name.text = pill!.name
        When.text = String(stringInterpolationSegment: pill!.whenTake)
        
        //
        PillImage.image = pill!.showImage
    }
    
    //
    func setPill(_ setNew: Pill?) {
        //
        pill = setNew
        
        //
        if pill == nil { clearOutlets() } else { selfConfig() }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

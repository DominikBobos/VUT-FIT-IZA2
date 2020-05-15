//
//  PillDetailViewController.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//
import Foundation
import UIKit

class PillDetailViewController: UITableViewController {

    var pill: Pill!
    
    //
//    @IBOutlet var PillImage: UIImageView!
//    @IBOutlet var Name: UITextField!
//    @IBOutlet var Start: UITextField!
//    @IBOutlet var End: UITextField!
//    @IBOutlet var When: UITextField!
    @IBOutlet  var PillImage: UIImageView!
    @IBOutlet var Name: UITextField!
    @IBOutlet var Start: UITextField!
    @IBOutlet var End: UITextField!
    @IBOutlet var When: UITextField!
    
    //    @IBOutlet var PillImage: UIImageView!
//    @IBOutlet var Name: UITextField!
//    @IBOutlet var Start: UIDatePicker!
//    @IBOutlet var End: UIDatePicker!
//    @IBOutlet var When: UIDatePicker!
    
    // ----------------------------------------------------------------
    // aktualizuje obsah objektu a notifikuje DB o zmene objektu
    func updateModel() {
        //
        if let _name = Name.text, let _start = Start.text,
            let _end = End.text, let _when = When.text {
            //
            pill.name = _name
            pill.dateBegin = _start
            pill.dateEnd = _end
            pill.whenTake = _when
            
            //
            AppDelegate.shared.pillsDatabase.updated(setNew: pill)
        }
    }
    
    @objc func backButton(_ sender: Any) {
        updateModel()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PillImage.image = pill.showImage
        Name.text = pill.name
        Start.text = pill.dateBegin
        End.text = pill.dateEnd
        When.text = pill.whenTake
        
        let _back = UIBarButtonItem(barButtonSystemItem: .save,
                                    target: self,
                                    action: #selector(PillDetailViewController.backButton(_:)))
        
        navigationItem.leftBarButtonItem = _back
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

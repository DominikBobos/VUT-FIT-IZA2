//
//  PillsTableViewController.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit

class PillsTableViewController: UITableViewController {

    var medications: [Pill] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        medications = createArray()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func createArray() -> [Pill] {
        var tempList: [Pill] = []
        let exampleDate = Date.init()
        let pill1 = Pill(newPill: "Paralen", start: exampleDate, end: exampleDate, when: exampleDate)
        
        tempList.append(pill1)
        
        return tempList
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let pill = medications[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell", for: indexPath)
//        return cell
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //     Get the new view controller using segue.destination.
     //    Pass the selected object to the new view controller.
//        if segue.identifier == "bookDetail",
//            let _dest = segue.destination as? PillDetailViewController,
//            let _selRow = tableView.indexPathForSelectedRow
//        {
//            //
//            _dest.pill = pill(atIndexPath: _selRow)
//        }
//        
        if segue.identifier == "addNew",
            let _dest = segue.destination as? PillDetailViewController
        {
            //
            let tempDate = Date.init()
            _dest.pill = Pill(newPill: "", start: tempDate, end: tempDate, when: tempDate)
        }
    }
 

}



extension PillsTableViewController{ //: UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pill = medications[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell") as! PillTableViewCell
        cell.setPill(pill)
        
        return cell
    }
}

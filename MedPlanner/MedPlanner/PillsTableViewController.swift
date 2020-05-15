//
//  PillsTableViewController.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit

class PillsTableViewController: UITableViewController, PillsDSDelegate {

    var medications: [PillsDataSource] = []
    
    func pill(atIndexPath: IndexPath) -> Pill {
        return medications[atIndexPath.section][atIndexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medications.append(PillsDataSource.All(delegate: self, section: 0))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func reloadFrom(pillsDS: PillsDataSource) {
        tableView.reloadData()
    }
    
    func updateFrom(pillsDS: PillsDataSource, onPill: Pill) {
        tableView.reloadSections(IndexSet(integer: pillsDS.section),
                                 with: .automatic)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return medications.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pill"
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 1
//    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell") as! PillTableViewCell
        cell.setPill(pill(atIndexPath: indexPath))
        return cell
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }
    
    
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
//         Get the new view controller using segue.destination.
//         Pass the selected object to the new view controller.
        if segue.identifier == "pillDetail",
            let _dest = segue.destination as? PillDetailViewController,
            let _selRow = tableView.indexPathForSelectedRow
        {
            //
            _dest.pill = pill(atIndexPath: _selRow)
        }
        
        if segue.identifier == "addNew",
            let _dest = segue.destination as? PillDetailViewController
        {
            //
            _dest.pill = Pill(newPill: "", start: "", end: "", when: "")
        }
    }
 

}


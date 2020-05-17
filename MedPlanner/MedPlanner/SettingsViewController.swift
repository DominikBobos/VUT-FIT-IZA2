//
//  SettingsViewController.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData



class SettingsViewController: UITableViewController {
    
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    @IBOutlet var NotificationSwitch: UISwitch!
    @IBAction func SwitchChanged(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if NotificationSwitch.isOn {
            defaults.set(NotificationSwitch.isOn, forKey: "notificationSetting")
            NotificationsTrigger()
        } else {
            defaults.set(NotificationSwitch.isOn, forKey: "notificationSetting")
            let center = UNUserNotificationCenter.current()
            if let notificationID = defaults.stringArray(forKey: "notificationID") {
                center.removePendingNotificationRequests(withIdentifiers: notificationID)
            }
            defaults.removeObject(forKey: "notificationID")
        }
        
    }
    
    
    func NotificationsTrigger() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        var notificationID: [String] = []
        content.title = "MedPlanner"
        content.subtitle = "Take your medication"
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-notifications temp"
    
        let getData = NSFetchRequest<NSFetchRequestResult>(entityName: "Medications")
        getData.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(getData)
            var ID = 0
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let start = data.value(forKey: "dateBegin") as! String
                let end = data.value(forKey: "dateEnd") as! String
                let when = data.value(forKey: "whenTake") as! String
                if validDate(start: start, end: end) {
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm"
                    content.body = "Don't forget to take \(name)."
                    guard let pillDate = timeFormatter.date(from: when) else {
                        continue
                    }
                    notificationID.append("MedPlanner"+"\(ID)")
                    let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: pillDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: notificationID[ID], content: content, trigger: trigger)
                    center.add(request)
                    ID += 1
                }
            }
        } catch {
            print("Data Loading Failed")
        }
        let defaults = UserDefaults.standard
        defaults.set(notificationID, forKey: "notificationID")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "notificationSetting") {
            
            NotificationSwitch.isOn = true
        } else {
            NotificationSwitch.isOn = false
        }
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

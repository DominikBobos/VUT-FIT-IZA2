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


/*
    Table view umoznujuci zmenit nastavenia
    Uzivatelske data o zmene sa ukladaju do UserDefaults
 */
class SettingsViewController: UITableViewController {
    
    // spristupnenie persistentContaineru na pristup k datam v CoreData
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    // Switch pre zmenu nastavenia notifikacii
    @IBOutlet var NotificationSwitch: UISwitch!
    @IBAction func SwitchChanged(_ sender: UISwitch) {
        //nastavenia sa ukladaju do UserDefaults
        let defaults = UserDefaults.standard
        if NotificationSwitch.isOn {
            defaults.set(NotificationSwitch.isOn, forKey: "notificationSetting")
            NotificationsTrigger() //nastavia sa jednotlive notifikacie o pripomenuti uzitia lieku
        } else {
            defaults.set(NotificationSwitch.isOn, forKey: "notificationSetting")
            //zmazu sa vsetky nastavene triggere pomocou notificationID ulozeneho v UserDefaults
            let center = UNUserNotificationCenter.current()
            if let notificationID = defaults.stringArray(forKey: "notificationID") {
                center.removePendingNotificationRequests(withIdentifiers: notificationID)
            }
            defaults.removeObject(forKey: "notificationID")
        }
    }
    
    /*
        Nastavenie Localnych Uzivatelskych Push notifikacii
        s informaciou ktory liek maju uzit, cas spustenia notifikacie
        je urceny pomocou casu whenTake zadaneho uzivatelom
        v pripade ze cas nebol blizsie urceny, tak nie je nastavena notifikacia
     */
    func NotificationsTrigger() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        var notificationID: [String] = []
        // nastavenie tela notifikacie
        content.title = "MedPlanner"
        content.subtitle = "Take your medication"
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-notifications temp"
    
        // nastavenie triggeru
        let getData = NSFetchRequest<NSFetchRequestResult>(entityName: "Medications")
        getData.returnsObjectsAsFaults = false
        do {
            // nacitanie ulozenych dat z CoreData
            let result = try context.fetch(getData)
            var ID = 0
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let start = data.value(forKey: "dateBegin") as! String
                let end = data.value(forKey: "dateEnd") as! String
                let when = data.value(forKey: "whenTake") as! String
        
                //volanie funkcie validDate na zistenie ci je dany liek v intervale kedy je ho este potrebne uzivat
                // ( tzn. aktualny datum spada do intervalu medzi dateBegin a dateEnd
                if validDate(start: start, end: end) {
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm"
                    content.body = "Don't forget to take \(name)."      // nastavenie spravy notifikacie s konkretnym menom lieku
                    guard let pillDate = timeFormatter.date(from: when) else {
                        continue
                    }
                    notificationID.append("MedPlanner"+"\(ID)")         // nastavenie ID notifikacie
                    // nastavenie triggeru notifikacie
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
        
        // ulozenie pola s ID notifikaciami do UserDefaults s key "notificationID"
        let defaults = UserDefaults.standard
        defaults.set(notificationID, forKey: "notificationID")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nacitanie nastavenia z UserDefaults
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "notificationSetting") {
            NotificationSwitch.isOn = true
        } else {
            NotificationSwitch.isOn = false
        }
    }
}

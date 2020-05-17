//
//  ViewController.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit
import CoreData

public func validDate(start: String, end: String) -> Bool {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let startDate = dateFormatter.date(from: start) //can have nil
    let endDate = dateFormatter.date(from: end)
    
    guard startDate != nil else {
        guard endDate != nil else {
            return true //no info about dates
        }
        if date > endDate!{
            return false // dont want to be shown in active medications
        } else {
            return true // medications need to be taken
        }
    }
    if (startDate! < date) && (date < endDate!) {
        return true     // medications need to be taken
    } else {
        return false    // dont want to be shown in active medications
    }
}

class StartViewController: UIViewController {

    @IBOutlet var TakenPills: UILabel!
    @IBOutlet var NotTakenPills: UILabel!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    private func dayTime(pillStr :String) -> Bool {
        let time = Date()
        let calendar = Calendar.current
        let currentTime = calendar.component(.hour, from: time)*60 + calendar.component(.minute, from: time)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        guard let pillDate = timeFormatter.date(from: pillStr) else {
            return true     // no time added - should take
        }
        let pillTime = calendar.component(.hour, from: pillDate)*60 + calendar.component(.minute, from: pillDate)
        
        if currentTime <= pillTime {
            return true     //should take
        } else {
            return false    //was taken
        }
        
    }
    
    private func getContent() {
        var _dataTaken: String = ""
        var _dataNotTaken: String = ""
        
        
        let getData = NSFetchRequest<NSFetchRequestResult>(entityName: "Medications")
        getData.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(getData)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let start = data.value(forKey: "dateBegin") as! String
                let end = data.value(forKey: "dateEnd") as! String
                let when = data.value(forKey: "whenTake") as! String
                if validDate(start: start, end: end) {
                    if dayTime(pillStr: when) {
                        _dataTaken = "\t" + when + "\t\t" + name + "\n" + _dataTaken
                    } else {
                        _dataNotTaken = "\t" + when + "\t\t" + name + "\n" + _dataNotTaken
                    }
                }
            }
        } catch {
            print("Data Loading Failed")
        }
        
        if (_dataTaken.isEmpty) {
            TakenPills.textColor = UIColor.init(displayP3Red: 0.07, green: 0.07, blue: 0.07, alpha: 0.5)
            TakenPills.text = "\tNo pills taken"
        } else {
            TakenPills.textColor = UIColor.black
            TakenPills.text = _dataTaken
        }
        if (_dataNotTaken.isEmpty) {
            NotTakenPills.textColor = UIColor.init(displayP3Red: 0.07, green: 0.07, blue: 0.07, alpha: 0.5)
            NotTakenPills.text = "\tNo pills need to be taken"
        } else {
            NotTakenPills.textColor = UIColor.black
            NotTakenPills.text = _dataNotTaken
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

}


//
//  PillDatabase.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 15/05/2020.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class PillsDatabase {
    var medications: [Pill] = []
    
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let ncMessage = Notification.Name("PillsDatabase:ping:toall")
    
    
    private func pingObservers(with setNew: Pill? = nil) {
        DispatchQueue.main.async {
            let notif = Notification(name: PillsDatabase.ncMessage, object: setNew, userInfo: nil)
            
            NotificationCenter.default.post(notif)
        }
    }

    func gtLoadContent() {
        var _data: [Pill] = []
        var pillIDS: [String] = []
        let getData = NSFetchRequest<NSFetchRequestResult>(entityName: "Medications")
        getData.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(getData)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let start = data.value(forKey: "dateBegin") as! String
                let end = data.value(forKey: "dateEnd") as! String
                let when = data.value(forKey: "whenTake") as! String
                let pillID = data.value(forKey: "pillID") as! String
                _data.append(Pill(dbPill: name, dateBegin: start, dateEnd: end, whenTake: when, state: .inUse, pillID: pillID))
                pillIDS.append(pillID)
            }
        } catch {
            print("Data Loading Failed")
        }
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "pillIDS")
        defaults.set(pillIDS, forKey: "pillIDS")
    
        DispatchQueue.main.async {
            if (_data.isEmpty == false){
                self.medications = _data
            }
            
            self.pingObservers()
        }
    }
}

extension PillsDatabase {
    func updated(setNew: Pill) {
        switch setNew.state {
        case .newPill:
            let defaults = UserDefaults.standard
            let pillID = UUID().uuidString
            if var pillIDS = defaults.stringArray(forKey: "notificationID") {
                pillIDS.append(pillID)
                defaults.removeObject(forKey: "pillIDS")    //premazem z userDefaults a pridam rozsirene pole
                defaults.set(pillIDS, forKey: "pillIDS")
            } else {
                let pillIDS: [String] = [pillID]        //prvykrat sa pridava id
                defaults.set(pillIDS, forKey: "pillIDS")
            }
            setNew.state = .inUse
            setNew.pillID = pillID
            medications.append(setNew);
            let savePill = Medications(entity: Medications.entity(), insertInto: context)
            savePill.name = setNew.name
            savePill.dateBegin = setNew.dateBegin
            savePill.dateEnd = setNew.dateEnd
            savePill.whenTake = setNew.whenTake
            savePill.pillID = setNew.pillID
           appDelegate.saveContext()
           do  {
               try context.save()
           } catch {
               print ("Failed saving data")
           }
            pingObservers();
        default:
            let getData = NSFetchRequest<NSFetchRequestResult>(entityName: "Medications")
            getData.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(getData)
                for data in result as! [NSManagedObject] {
                    let pillID = data.value(forKey: "pillID") as! String
                    if pillID == setNew.pillID {
                        data.setValue(setNew.name, forKey: "name")
                        data.setValue(setNew.dateBegin, forKey: "dateBegin")
                        data.setValue(setNew.dateEnd, forKey: "dateEnd")
                        data.setValue(setNew.whenTake, forKey: "whenTake")
                    }
                }
            } catch {
                print("Data Loading Failed")
            }
            appDelegate.saveContext()
            do  {
                try context.save()
            } catch {
                print ("Failed saving data")
            }
            pingObservers(with: setNew)
        }
    }
}

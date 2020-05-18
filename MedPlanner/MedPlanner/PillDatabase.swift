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

/*
    Objekt uklada original vsetkych objektov Pill
    uskutocnuje editaciu obsahu databaze: add/edit
 */
class PillsDatabase {

    // pole obsahujuce originaly objektov Pill
    var medications: [Pill] = []
    
    // spristupnenie persistentContaineru na nacitanie a zmenu dat v CoreData
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // tato sprava sa rozposiela PillDatabazi cez Notifikacni centrum
    static let ncMessage = Notification.Name("PillsDatabase:ping:toall")
    
    // rozposlanie spravy
    private func pingObservers(with setNew: Pill? = nil) {
        DispatchQueue.main.async {
            let notif = Notification(name: PillsDatabase.ncMessage, object: setNew, userInfo: nil)
            
            NotificationCenter.default.post(notif)
        }
    }

    /*
        Nacitanie dat z CoreData a ulozenie do medications
        Pracuje v Global Queue
     */
    func loadContent() {
        var _data: [Pill] = []
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
            }
        } catch {
            print("Data Loading Failed")
        }
    
        DispatchQueue.main.async {
            if (_data.isEmpty == false){    // v pripade ze sa prvykrat pusta apliakcia/je prazdna databaza -> nenacitava sa nic
                self.medications = _data
            }
            self.pingObservers()
        }
    }
}

/*
    editacia/pridanie noveho Objektu
 */
extension PillsDatabase {
    func updated(setNew: Pill) {
        switch setNew.state {
        case .newPill:  // novy objekt
            let pillID = UUID().uuidString  // vytvorenie unikatneho ID objektu
            setNew.state = .inUse           // zmena stavu
            setNew.pillID = pillID
            medications.append(setNew);     // rozirenie pola o novy objekt Pill
            let savePill = Medications(entity: Medications.entity(), insertInto: context)
            savePill.name = setNew.name
            savePill.dateBegin = setNew.dateBegin
            savePill.dateEnd = setNew.dateEnd
            savePill.whenTake = setNew.whenTake
            savePill.pillID = setNew.pillID
            appDelegate.saveContext()       // ulozenie do databazy
           do  {
               try context.save()
           } catch {
               print ("Failed saving data")
           }
            pingObservers();                // rozposlanie spravy
        
        default:    // existujuci objekt == editacia udajov
            let getData = NSFetchRequest<NSFetchRequestResult>(entityName: "Medications")
            getData.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(getData)
                for data in result as! [NSManagedObject] {
                    let pillID = data.value(forKey: "pillID") as! String
                    if pillID == setNew.pillID {    // uprava spravneho objektu pill pomocou ID
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
            pingObservers(with: setNew)     // rozposlanie spravy
        }
    }
}

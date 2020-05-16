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
    var fuckingSwift = [Medications]()
    
    static let ncMessage = Notification.Name("PillsDatabase:ping:toall")
    
    
    private func pingObservers(with setNew: Pill? = nil) {
        DispatchQueue.main.async {
            let notif = Notification(name: PillsDatabase.ncMessage, object: setNew, userInfo: nil)
            
            NotificationCenter.default.post(notif)
        }
    }

    func gtLoadContent() {
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
                _data.append(Pill(dbPill: name, dateBegin: start, dateEnd: end, whenTake: when, state: .inUse))
            }
        } catch {
            print("Data Loading Failed")
        }
      
//        let _data = [Pill(dbPill: "Paralen", dateBegin: "vcera", dateEnd: "endless", whenTake: "kazde rano", state: .inUse),
//                     Pill(dbPill: "Vitamin C", dateBegin: "tempDate", dateEnd: "tempDate", whenTake: "tempDate", state: .InUse)]
        
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
            setNew.state = .inUse
            medications.append(setNew);
            pingObservers();
            
        default:
            pingObservers(with: setNew)
        }
    }
}

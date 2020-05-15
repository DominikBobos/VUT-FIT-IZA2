//
//  PillDatabase.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 15/05/2020.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import Foundation


class PillsDatabase {
    var medications: [Pill] = []
    
    static let ncMessage = Notification.Name("PillsDatabase:ping:toall")
    
    
    private func pingObservers(with setNew: Pill? = nil) {
        DispatchQueue.main.async {
            let notif = Notification(name: PillsDatabase.ncMessage, object: setNew, userInfo: nil)
            
            NotificationCenter.default.post(notif)
        }
    }

    func gtLoadContent() {

        let _data = [Pill(dbPill: "Paralen", dateBegin: "vcera", dateEnd: "endless", whenTake: "kazde rano", state: .inUse),
                     Pill(dbPill: "Vitamin C", dateBegin: "tempDate", dateEnd: "tempDate", whenTake: "tempDate", state: .notInUse)]

        DispatchQueue.main.async {
            self.medications = _data
            
            
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

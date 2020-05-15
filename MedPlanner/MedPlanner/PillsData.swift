//
//  PillsData.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 14/05/2020.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import Foundation
import UIKit

//delegate protocol na nacitanie pripadne update zdrojov
protocol PillsDSDelegate : AnyObject {
    func reloadFrom(pillsDS: PillsDataSource)
    func updateFrom(pillsDS: PillsDataSource, onPill: Pill)
}


class PillsDataSource {
    var selection: [Pill] = []
    let filter: (Pill) -> Bool
    let section: Int
    
    weak var delegate: PillsDSDelegate?
    
    var count: Int { return selection.count}
    var db: PillsDatabase { return AppDelegate.shared.pillsDatabase}
    
    subscript(_ index: Int) -> Pill { return selection[index] }
    
    
    init(section: Int, delegate: PillsDSDelegate, filter: @escaping (Pill) -> Bool)
    {
        self.filter = filter
        self.delegate = delegate
        self.section = section
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadDatabase() {
        selection = db.medications.filter(self.filter)
        
        DispatchQueue.main.async {
            self.delegate?.reloadFrom(pillsDS: self)
        }
    }
    
    @objc func ncMessageObserver(_ notif: Notification) {
        if let _setNew = notif.object as? Pill {
            if selection.contains(where: { $0 === _setNew} ) {
                DispatchQueue.main.async {
                    self.delegate?.updateFrom(pillsDS: self, onPill: _setNew)
                }
            }
        }
        else {
            loadDatabase()
        }
    }
    
    func start() {
        let nc = NotificationCenter.default
        
        
        nc.addObserver(self, selector: #selector(PillsDataSource.ncMessageObserver(_:)), name: PillsDatabase.ncMessage, object: nil)
        
        loadDatabase()
    }
}


extension PillsDataSource {
    static func All(delegate: PillsDSDelegate, section: Int) -> PillsDataSource
    {
        let pillsDS = PillsDataSource(section: section, delegate: delegate, filter: { _ in true } )
        
        pillsDS.start()
        
        return pillsDS
    }
}

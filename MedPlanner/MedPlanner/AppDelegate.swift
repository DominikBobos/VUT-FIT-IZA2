//
//  AppDelegate.swift
//  MedPlanner
//
//  Created by Dominik Boboš on 13.5.20.
//  Copyright © 2020 Dominik Boboš. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    //k nacitaniu obsahu databazy
    fileprivate var __pillsDatabase: PillsDatabase!
    var pillsDatabase: PillsDatabase { return __pillsDatabase }

    // vytvorenie AppDelegate na handlovanie systemovych eventov
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        __pillsDatabase = PillsDatabase()
        DispatchQueue.global().async {
            self.__pillsDatabase.loadContent()
        }
        // ziadost o udelenie opravnenia k pristupovaniu k uzivatelskym upozorneniam
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.sound, .alert, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            if error != nil {
                print(error!)
            }
        }
        return true
    }
    
    // aby sa zobrazovali upozornenia aj mimo toho ked je zariadenie uzamknute
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // tesne pred ukoncenim aplikacie sa zavola saveContext na ulozenie dat do CD
        self.saveContext()
    }

    // vytvorenie a vratenie persistent container, ku ktoremu mozem potom pristupovat z hocijakej triedy
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MedPlanner")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // ulozi data do CoreData
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
//

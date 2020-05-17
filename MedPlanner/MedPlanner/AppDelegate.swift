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
    
    fileprivate var __pillsDatabase: PillsDatabase!
    
    var pillsDatabase: PillsDatabase { return __pillsDatabase }

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        __pillsDatabase = PillsDatabase()
        DispatchQueue.global().async {
            self.__pillsDatabase.gtLoadContent()
        }
        // ziadost o udelenie opravneni k pristupovaniu k upozorneniam
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
        // tesne pred ukoncenim aplikacie sa ulozi Context
        self.saveContext()
    }

    // vytvorenie persistent container, ku ktoremu mozem potom pristupovat z hocijakej triedy
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MedPlanner")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
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

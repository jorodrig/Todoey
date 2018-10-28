//
//  AppDelegate.swift
//  Todoey
//
//  Created by Joseph on 10/20/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)//test code to show the path to persistent data on simulator devices.
                    //Use this path to browse Finder to the plist for the app which shows the stored local data.  Put corresponding Call in an Action Method or whereever persistent data needs to be stored to NOT use UserDefaults as a database as it is loaded each time an app is loaded


        return true
    }
    /*   10-27-2018: Note these methoda have been commented out as they are not needed and were provided when the project was created without coredata
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
*/
    //10-27-2018 From applicationWillTerminate to saveContext() below, the code is copied from a test or sample CoreData project as it is always needed in core data projects.
    //10-27-2018 Note: first create a new coredata file by adding it to the current project, then copy the AppDelegate from the test core data project to the current appDelegate file as a starting point.  This is how one add's coredata to a project that did not start as a coredata project.
    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    //10-27-2018 NOte: Lazy vars are only used when needed so do not occupy memory until needed.  The code inside the {} will only run when this variable is used.
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DataModel")
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


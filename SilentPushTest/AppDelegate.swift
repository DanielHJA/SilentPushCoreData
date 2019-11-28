//
//  AppDelegate.swift
//  SilentPushTest
//
//  Created by Daniel Hjärtström on 2019-11-27.
//  Copyright © 2019 Daniel Hjärtström. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import NotificationCenter
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.setbadgeNumberTo(0)
        Core.shared.purgeAllData(true)
        prepareForNotifications(for: application)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Push Notifications

    func prepareForNotifications(for application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().delegate = self
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        fetchBackgroundData { (result) in
            completionHandler(result)
        }
    }
    
    private func fetchBackgroundData(completion: @escaping (UIBackgroundFetchResult) -> ()) {
        let url = "http://demo6427581.mockable.io/"
        Webservice<[DecodablePerson]>.fetch(urlString: url) { (result) in
            switch result {
            case .success(let objects):
                self.makeObjectsFromDictionary(dict: objects)
                //DispatchQueue.main.async {
                    //_ = objects.map { $0.toPersonEntity() }
                //}
                completion(.newData)
            case .failure(_):
                completion(.failed)
            }
        }
    }
    
    func makeObjectsFromDictionary(dict: [[String: Any]]) {
        for object in dict {
            guard let id = object["id"] as? String else { continue }
            guard let name = object["name"] as? String else { continue }
            guard let headline = object["headline"] as? String else { continue }
            guard let bio = object["bio"] as? String else { continue }
            guard let age = object["age"] as? Int32 else { continue }
        
            Core.shared.checkIdExist(type: Person.self, id: id) { (exists) in
                if !exists {
                    Core.shared.add(type: Person.self) { (person) in
                        person.id = id
                        person.hasBeenRead = false
                        person.name = name
                        person.headline = headline
                        person.bio = bio
                        person.age = age
                        UIApplication.increaseBadgeNumberBy(1)
                        Core.shared.save()
                    }
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier {
//        case UNNotificationDismissActionIdentifier:
//            break
//        case UNNotificationDefaultActionIdentifier:
//            break
//        default:
//            break
//        }
        completionHandler()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SilentPushTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


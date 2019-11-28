//
//  Core.swift
//  CoreDataTest
//
//  Created by Daniel Hjärtström on 2019-11-22.
//  Copyright © 2019 Daniel Hjärtström. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Core: NSObject {
    static let shared = Core()
    
    private override init() {}
    
    private lazy var appDelegate: AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    private lazy var persistentContainer: NSPersistentContainer? = {
          return appDelegate.persistentContainer
      }()
    
    private lazy var context: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, completion: @escaping ([T]) -> ()) {
        let request = NSFetchRequest<T>(entityName: T.identifier)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        
        do {
            let result = try context.fetch(request)
            completion(result)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func add<T: NSManagedObject>(type: T.Type, completion: @escaping (T) -> ()) {
        if let entityDescription = NSEntityDescription.entity(forEntityName: T.identifier, in: context) {
            completion(T(entity: entityDescription, insertInto: context))
        }
    }
    
    func delete(object: NSManagedObject) {
        context.delete(object)
        print("Object deleted")
        save()
    }
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func purgeAllData(_ purge: Bool) {
        if purge {
            guard let uniqueNames = persistentContainer?.managedObjectModel.entities.compactMap({ $0.name }) else { return }
            uniqueNames.forEach { (name) in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try persistentContainer?.viewContext.execute(batchDeleteRequest)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func checkIdExist<T: NSManagedObject>(type: T.Type, id: String, completion: @escaping (Bool) -> ()) {
        let predicate = NSPredicate(format: "id = %@", id)
        fetch(type: T.self, predicate: predicate) { (results) in
            completion(results.isEmpty ? false : true)
        }
    }
    
}



//
//  EntityCRUDService.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/4.
//

import Foundation
import UIKit
import CoreData
class EntityCRUDService {
    // get entity container context viewContext is main thread context
    let persistentContainer: NSPersistentContainer!
    var requestOffset = 0
    lazy var context: NSManagedObjectContext = {
        //back ground context
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        return self.persistentContainer.viewContext
    }()
    
    init(container: NSPersistentContainer?) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        //Use the default container for production environment
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    public func addNewToEntity<T: NSManagedObject>(name: String) -> T? {
        
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        guard let retObj = NSManagedObject(entity: entity!, insertInto: context) as? T else {
            return nil
        }
        return retObj
    }
    
    public func readData<T: NSManagedObject>(name: String, with rule: String, limit: Int = 0) -> [T]{
        self.requestOffset = 0
        var array:[T] = []
        let request = NSFetchRequest<T>(entityName: name)
        let predicate = NSPredicate(format: rule)
        request.predicate = predicate
        if limit > 0 {
            request.fetchLimit = limit
        }
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try context.fetch(request)
            for result in results {
                array.append(result)
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        return array
    }
    
    public func readDataNext<T: NSManagedObject>(name: String, with rule: String, limit: Int = 0) -> [T]{
        self.requestOffset += limit
        var array:[T] = []
        let request = NSFetchRequest<T>(entityName: name)
        let predicate = NSPredicate(format: rule)
        request.predicate = predicate
        if limit > 0 {
            request.fetchLimit = limit
        }
        request.fetchOffset = self.requestOffset
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let results = try context.fetch(request)
            for result in results {
                array.append(result)
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        return array
    }
    
    
    public func readData<T: NSManagedObject>(by name: String, limit: Int = 0) -> [T]{
        var array:[T] = []
        let request = NSFetchRequest<T>(entityName: name)
        if limit > 0 {
            request.fetchLimit = limit
        }
        do {
            let results = try context.fetch(request)
            for result in results {
                array.append(result)
            }
        }catch{
            fatalError("Failed to fetch data: \(error)")
        }
        return array
    }
    
    public func saveData() -> Bool{
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error \(error)")
                return false
            }
            return true
        }
        return false
    }
    
    public func deleteData(targetObj : NSManagedObject) {
        context.delete(targetObj)
    }
    
    public func deleteData(targetObjs: [NSManagedObject]) {
        for delObj in targetObjs {
            context.delete(delObj)
        }
    }
    
    public func deleteData(entityName: String, id: Int32) -> [NSManagedObject] {
        return Array(context.deletedObjects)
    }
}

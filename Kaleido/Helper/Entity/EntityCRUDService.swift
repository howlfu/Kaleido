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
        let retObj = NSManagedObject(entity: entity!, insertInto: context) as! T
        return retObj
    }
    
    public func readData<T: NSManagedObject>(name: String, with rule: String) -> [T]{
        var array:[T] = []
        let request = NSFetchRequest<T>(entityName: name)
        let predicate = NSPredicate(format: rule)
        request.predicate = predicate
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
    
    
    public func readData<T: NSManagedObject>(by name: String) -> [T]{
        var array:[T] = []
        let request = NSFetchRequest<T>(entityName: name)
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
}

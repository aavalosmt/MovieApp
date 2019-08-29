//
//  RealmHandler.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/29/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHandler {
    
    static let shared: RealmHandler = RealmHandler()
    
    private func getRealmInstance() -> Realm? {
        do {
            let realmInstance = try Realm()
            return realmInstance
        } catch _ as Realm.Error {
            handleMigrationFail()
        } catch let error as NSError {
            assertionFailure("Something went wrong with Realm, error = \(error.description)")
        }
        return nil
    }
    
    public func configure(schemaVersion: Int, realmFileURL: URL) throws {
        var config = Realm.Configuration(

            schemaVersion: UInt64(schemaVersion),
            migrationBlock: { migration, oldSchemaVersion in
                guard oldSchemaVersion < UInt64(schemaVersion) else { return }
                
        }, deleteRealmIfMigrationNeeded: false)
        
        config.fileURL = realmFileURL
        
        Realm.Configuration.defaultConfiguration = config
        
        if getRealmInstance() == nil {
            // Reset
        }
    }
    
    func handleMigrationFail() {
        RealmAppDelegate.shared.deleteBrokenFile()
        RealmAppDelegate.shared.realmSetup()
    }
    
    public func addObject(object: Object) {
        guard let realm = getRealmInstance(), !object.isInvalidated else { return }
        if realm.isInWriteTransaction {
            realm.add(object)
        } else {
            do {
                try realm.write {
                    realm.add(object)
                }
            } catch let error as NSError {
                assertionFailure("Something went wrong with Realm (Write), error = \(error.description)")
            }
        }
    }
    
    public func addObject(object: Object, update: Realm.UpdatePolicy) {
        guard let realm = getRealmInstance(), !object.isInvalidated else { return }
        if realm.isInWriteTransaction {
            realm.add(object, update: update)
        } else {
            do {
                try realm.write {
                    realm.add(object, update: update)
                }
            } catch let error as NSError {
                assertionFailure("Something went wrong with Realm (Write), error = \(error.description)")
            }
        }
    }
    
    public func addObjects(objects: [Object], update: Realm.UpdatePolicy) {
        
        guard let realm = getRealmInstance() else { return }
        let filtered = objects.filter({ !$0.isInvalidated })
        if realm.isInWriteTransaction {
            realm.add(filtered, update: update)
        } else {
            do {
                try realm.write {
                    realm.add(filtered, update: update)
                }
            } catch let error as NSError {
                assertionFailure("Something went wrong with Realm (Write), error = \(error.description)")
            }
        }
    }
    
    public func getObject(type: Object.Type, forKey: String?) -> Object? {
        guard let realm = getRealmInstance(), let key = forKey else { return nil }
        return realm.object(ofType: type, forPrimaryKey: key)
    }
    
    public func getObject(type: Object.Type, forId: Int) -> Object? {
        guard let realm = getRealmInstance() else { return nil }
        return realm.object(ofType: type, forPrimaryKey: forId)
    }
    
    public func getObjects(type: Object.Type) -> [Any]? {
        return getObjects(type: type, predicateFormat: "")
    }
    
    public func getObjects(type: Object.Type, predicateFormat: String, _ args: Any...) -> [Any]? {
        guard let realm = getRealmInstance() else { return nil }
        if !predicateFormat.isEmpty {
            return Array(realm.objects(type).filter(predicateFormat, args))
        } else {
            return Array(realm.objects(type))
        }
    }
    
    public func deleteObject(object: Object) {
        guard let realm = getRealmInstance(), !object.isInvalidated else { return }
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error as NSError {
            assertionFailure("Something went wrong with Realm (Delete), error = \(error.description)")
        }
    }
    
    public func clear() {
        guard let realm = getRealmInstance() else { return }
        do {
            if realm.isInWriteTransaction {
                realm.cancelWrite()
            }
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            assertionFailure("Something went wrong with Realm (DeleteAll), error = \(error.description)")
        }
    }
    
}

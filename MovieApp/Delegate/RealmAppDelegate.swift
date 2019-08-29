//
//  RealmAppDelegate.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/29/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAppDelegate: NSObject, ApplicationService {
    
    static let shared: RealmAppDelegate = RealmAppDelegate()
    
    static func setCurrentRealmFile() {
        
        if let buildVersionString = UserDefaults.standard.string(forKey: AppConstants.AppVersion.buildVersion),
            let buildVersionInt = Int(buildVersionString) {
            
            configureRealm(schemaVersion: buildVersionInt, realmFileURL: self.getDefaultRealmURL())
        } else {
            assertionFailure("Build version in UserDefault should have been set on launch and must be parseable to Int")
        }
    }
    
    // Creates folders if necessary
    static func getDefaultRealmURL() -> URL {
        
        var folder = self.getRootRealmFolderPath()
        folder = folder.appendingPathComponent(AppConstants.RealmCache.defaultRealmFolderName)
        self.createFoldersIfNecesary(forPath: folder.path)
        
        let fileName = AppConstants.RealmCache.defaultRealmFileName + AppConstants.RealmCache.realmExtension
        return folder.appendingPathComponent(fileName)
    }
    
    static func getRootRealmFolderPath() -> URL {
        return self.getDocumentsPath().appendingPathComponent(AppConstants.RealmCache.realmRootFolderName)
    }
    
    private static func getDocumentsPath() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first ?? ""
        return URL(fileURLWithPath: documentsDirectory)
    }
    
    private static func createFoldersIfNecesary(forPath path: String) {
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    private static func deleteFileIfExists(_ path: String) {
        
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("It has started!")
        
        return true
    }
    
    func realmSetup() {
        let defaults = UserDefaults.standard
        guard let currentBuildVersionString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            assertionFailure("CFBundleVersion must exists")
            return
        }
        let defaultRealmUrl = RealmAppDelegate.getDefaultRealmURL()
        
        guard let currentBuildVersionInt = Int(currentBuildVersionString) else {
            assertionFailure("CFBundleVersion must be parseable to Int")
            return
        }
        
        RealmAppDelegate.configureRealm(schemaVersion: currentBuildVersionInt, realmFileURL: defaultRealmUrl)
        defaults.set(currentBuildVersionString, forKey: AppConstants.AppVersion.buildVersion)
    }
    
    // Delete old and unused Realm files that are not part of the new folder structure and have a different Realm schema
    private func deleteLegacyFiles() {
        DispatchQueue.global(qos: .background).async {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            
            if let firstPath = paths.first {
                
                let documentsDirectory = URL(fileURLWithPath: firstPath)
                
                let defaultRealm = documentsDirectory.appendingPathComponent(AppConstants.RealmCache.LegacyDefaultRealmFileName)
                let defaultRealmLock = documentsDirectory.appendingPathComponent(AppConstants.RealmCache.LegacyDefaultRealmLockFileName)
                let defaultRealmManagement = documentsDirectory.appendingPathComponent(AppConstants.RealmCache.LegacyDefaultRealmManagementFileName)
                
                RealmAppDelegate.deleteFileIfExists(defaultRealm.path)
                RealmAppDelegate.deleteFileIfExists(defaultRealmLock.path)
                RealmAppDelegate.deleteFileIfExists(defaultRealmManagement.path)
            }
        }
    }
    
    func deleteBrokenFile() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if let firstPath = paths.first {
            
            let documentsDirectory = URL(fileURLWithPath: firstPath)
            
            let defaultRealm = documentsDirectory.appendingPathComponent(AppConstants.RealmCache.realmRootFolderName)
            RealmAppDelegate.deleteFileIfExists(defaultRealm.path)
        }
    }
    
    private static func configureRealm(schemaVersion: Int, realmFileURL: URL) {
        do {
            try RealmHandler.shared.configure(schemaVersion: schemaVersion, realmFileURL: realmFileURL)
        } catch _ as Realm.Error {
            RealmHandler.shared.handleMigrationFail()
        } catch let error as NSError {
            assertionFailure("Something went wrong with Realm, error = \(error.description)")
        }
    }
    
}

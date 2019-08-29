//
//  AppConstants.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 8/29/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import Foundation

struct AppConstants {
    
    struct AppVersion {
        static let buildVersion = "buildVersion"
        static let unknownVersionNumber = "0.0.0"
    }
    
    struct RealmCache {
        static let realmRootFolderName: String = "Realms"
        static let defaultRealmFileName: String = "default"
        static let defaultRealmFolderName: String = "Default"
        static let realmExtension: String = ".realm"
        
        static let LegacyDefaultRealmFileName: String = "default.realm"
        static let LegacyDefaultRealmLockFileName: String = "default.realm.lock"
        static let LegacyDefaultRealmManagementFileName: String = "default.realm.management"
    }
    
}

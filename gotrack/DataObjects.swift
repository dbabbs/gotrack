//
//  DataObjects.swift
//  gotrack
//
//  Created by Ian on 12/10/16.
//  Copyright © 2016 Babbs, Dylan. All rights reserved.
//

import Foundation
import RealmSwift

// Run Model
class Run: Object {
    dynamic var timestamp = Date()
    let locations = List<Location>()
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}

// Location Model
class Location: Object {
    dynamic var timestamp = Date()
    dynamic var latitude : Float = 0.0
    dynamic var longitude : Float = 0.0
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}



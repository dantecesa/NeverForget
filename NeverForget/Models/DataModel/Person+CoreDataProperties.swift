//
//  Person+CoreDataProperties.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/17/22.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var additionalDescription: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var photoFileName: String?
    @NSManaged public var locationStored: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedAdditionalDescription: String {
        additionalDescription ?? ""
    }
    
    public var wrappedId: UUID {
        id ?? UUID()
    }
    
    public var wrappedPhotoFileName: String {
        photoFileName ?? "Unknown fileName"
    }
    
    public var wrappedDateAdded: Date {
        dateAdded ?? Date.now
    }
}

extension Person : Identifiable {

}

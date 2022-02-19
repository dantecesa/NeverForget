//
//  PersonViewModel.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/18/22.
//

import Foundation
import SwiftUI

class PersonViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var moc
    let locationFetcher: LocationFetcher = LocationFetcher()
    
    func savePerson(_ person: Person, name: String, description: String, enableLocation: Bool, image: UIImage) {
        person.id = person.wrappedId
        person.name = name
        person.additionalDescription = description
        person.dateAdded = person.wrappedDateAdded
        
        let imageFileName = name + "-" + person.id!.description + ".jpg"
        saveImage(image, withFileName: imageFileName)
        person.photoFileName = imageFileName
        
        if enableLocation {
            if let location = self.locationFetcher.lastKnownLocation {
                person.locationStored = true
                person.latitude = location.latitude
                person.longitude = location.longitude
            }
        } else {
            person.locationStored = false
        }
        
        try? moc.save()
    }
    
    func saveImage(_ image: UIImage?, withFileName fileName: String) {
        guard let image = image else { return }
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
                do {
                    try jpegData.write(to: FileManager.documentsDirectory.appendingPathComponent(fileName, isDirectory: false), options: [.atomic, .completeFileProtection])
                    
                }     catch {
                    print("We couldn't save the image")
                }
            }
    }
    
    func loadImage(forPerson person: Person) -> Image {
        guard let jpegData = try? Data(contentsOf: FileManager.documentsDirectory.appendingPathComponent(person.wrappedPhotoFileName, isDirectory: false)) else { return Image(uiImage: UIImage(systemName: "star")!) }
        
        return Image(uiImage: UIImage(data: jpegData) ?? UIImage(systemName: "star")!)
    }
}

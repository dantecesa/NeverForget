//
//  Location.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/18/22.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let coordinates: CLLocationCoordinate2D
}

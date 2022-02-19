//
//  MapView.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/18/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var coordinateRegion: MKCoordinateRegion
    let annotationItems: [Location]
    
    init(latitude: Double, longitude: Double) {
        _coordinateRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        self.annotationItems = [Location(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))]
    }
    
    var body: some View {
        NavigationView {
            //Map(coordinateRegion: $coordinateRegion)
            Map(coordinateRegion: $coordinateRegion, annotationItems: annotationItems) { annotation in
                MapAnnotation(coordinate: annotation.coordinates) {
                    Image(systemName: "mappin")
                        .symbolRenderingMode(.multicolor)
                        .font(.largeTitle)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(latitude: 50, longitude: 50)
    }
}

//
//  NeverForgetApp.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/17/22.
//

import SwiftUI

@main
struct NeverForgetApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

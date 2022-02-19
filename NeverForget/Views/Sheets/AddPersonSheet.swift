//
//  AddPersonSheet.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/17/22.
//

import SwiftUI

struct AddPersonSheet: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: PersonViewModel
    
    @State private var name: String = ""
    @State private var image: UIImage?
    @State private var description: String = ""
    @State private var enableLocation: Bool = false
    
    @State private var showingAddImageSheet: Bool = false
        
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("What's their name?", text: $name)
                        .disableAutocorrection(true)
                    
                    TextField("Additional details?", text: $description)
                }
                Section("Add a photo") {
                    Button(action: {
                        showingAddImageSheet = true
                    }, label: {
                        if image == nil {
                            Text("Select…")
                        } else {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Image selected")
                            }
                        }
                    })
                }
                
                Section("Add Location") {
                    Toggle("Store Location?", isOn: $enableLocation)
                        .onChange(of: enableLocation) { newValue in
                            if newValue == true {
                                viewModel.locationFetcher.start()
                            }
                        }
                }
            }
            .navigationTitle("Add Person")
            .sheet(isPresented: $showingAddImageSheet) {
                ImagePicker(image: $image)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        let person = Person(context: moc)
                        
                        guard let image = image else { return }
                        
                        viewModel.savePerson(person, name: name, description: description, enableLocation: enableLocation, image: image)
                        
                        dismiss()
                    }, label: {
                        Text("Save")
                    })
                        .disabled(name.isEmpty || image == nil)
                }
            }
        }
    }
}

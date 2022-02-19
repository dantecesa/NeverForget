//
//  UserDetailView.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/17/22.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteConfirmation: Bool = false
    
    @EnvironmentObject var viewModel: PersonViewModel
    
    var person: Person
    
    @State private var showPersonDetails: Bool = true
    @State private var showEditSheet: Bool = false
    @State private var showMapSheet: Bool = false
    
    var body: some View {
        ZStack {
            viewModel.loadImage(forPerson: person)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Text(person.wrappedName)
                        .font(.title2)
                        .padding()
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        if person.wrappedAdditionalDescription != "" {
                            Text(person.wrappedAdditionalDescription)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(person.wrappedDateAdded.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing)
                }
                .background(.thinMaterial)
                .padding(.bottom)
                .opacity(showPersonDetails ? 1 : 0)
            }
        }
        .onTapGesture {
            withAnimation {
                showPersonDetails.toggle()
            }
        }
        .navigationTitle(person.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Menu(content: {
                if person.locationStored {
                    Button(action: {
                        showMapSheet = true
                    }, label: {
                        Text("Show Map")
                        Image(systemName: "map")
                    })
                }
                Button(action: {
                    showEditSheet = true
                }, label: {
                    Text("Edit")
                    Image(systemName: "pencil")
                })
                Button(role: .destructive, action: {
                    showDeleteConfirmation = true
                }, label: {
                    Text("Delete Person")
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                })
            }, label: {
                Image(systemName: "ellipsis.circle")
            })
        }
        .alert("Are you sure you want to remove \(person.wrappedName)?", isPresented: $showDeleteConfirmation) {
            Button(role: .destructive, action: { deletePerson() }, label: { Text("Confirm") })
            Button(role: .cancel, action: { }, label: { Text("Cancel") })
        } message: {
            Text("This action cannot be undone.")
        }
        .sheet(isPresented: $showEditSheet) {
            EditPersonSheet(person: person)
        }
        .sheet(isPresented: $showMapSheet) {
            MapView(latitude: person.latitude, longitude: person.longitude)
        }
    }
    
    func deletePerson() {
        moc.delete(person)
        
        if moc.hasChanges {
            try? moc.save()
        }
        dismiss()
    }
}

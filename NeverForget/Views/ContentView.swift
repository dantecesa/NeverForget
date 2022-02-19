//
//  ContentView.swift
//  NeverForget
//
//  Created by Dante Cesa on 2/17/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject var viewModel: PersonViewModel = PersonViewModel()
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var people: FetchedResults<Person>
    
    @State private var showAddSheet: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people, id:\.self) { person in
                    NavigationLink(destination: {
                        UserDetailView(person: person)
                    }, label: {
                        HStack {
                            viewModel.loadImage(forPerson: person)
                                .resizable()
                                .scaledToFill()
                                .padding(2)
                                .frame(width: 44, height: 44)
                            
                            VStack(alignment: .leading) {
                                Text(person.wrappedName)
                                    .foregroundColor(.primary)
                                Text(person.wrappedDateAdded.formatted(date: .numeric, time: .shortened))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    })
                }
                .onDelete { indexSet in
                    deletePerson(atOffsets: indexSet)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .navigationTitle("NeverForget")
        }
        .sheet(isPresented: $showAddSheet) {
            AddPersonSheet()
        }
        .environmentObject(viewModel)
        .preferredColorScheme(.dark)
    }
    
    func deletePerson(atOffsets: IndexSet) {
        for offset in atOffsets {
            let item = people[offset]
            moc.delete(item)
        }
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

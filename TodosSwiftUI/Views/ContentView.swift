//
//  ContentView.swift
//  ToDoList
//
//  Created by Stephen DeStefano on 8/20/19.
//  Copyright © 2019 Stephen DeStefano. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: ToDoList.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \ToDoList.dateCreated, ascending: false)])
    var fetchedItems: FetchedResults<ToDoList>
    @State private var toDoItem = ""
    @State private var setPriority = ""
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    HStack {
                        TextField("Type Something...", text: self.$toDoItem)
                            .padding(.all, 4)
                            .font(Font.system(size: 25, design: .default))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: addItem){
                            Image(systemName: "plus.circle")
                                .foregroundColor(.white)
                                .imageScale(.large)
                        }
                    }
                    
                    Picker(selection: self.$setPriority, label: Text("")) {
                        Text("No Rush").tag("😌")
                        Text("Important").tag("✅")
                        Text("Urgent").tag("🚨")
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    ForEach(fetchedItems, id: \.self) { toDoItems in
                        ItemRowView(item: toDoItems.item ?? "Empty", dateCreated: toDoItems.dateCreated!, priority: toDoItems.priority ?? "Empty")
                    }.onDelete(perform: removeItems)
                }.navigationBarTitle(Text("Todos"))
                .foregroundColor(.white)
            }
            .environment(\.colorScheme, .dark)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func addItem() {
        guard self.toDoItem != "" else { return }
        let ToDoItem = ToDoList(context: self.managedObjectContext)
        ToDoItem.item = self.toDoItem
        ToDoItem.dateCreated = Date()
        ToDoItem.priority = self.setPriority
        do {
            try self.managedObjectContext.save()
        } catch {
            showingAlert.toggle()
            errorMessage = error.localizedDescription
        }
        self.toDoItem = ""
    }
    
    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = fetchedItems[index]
            managedObjectContext.delete(item)
            
        }
        do {
            try managedObjectContext.save()
        } catch {
            showingAlert.toggle()
            errorMessage = error.localizedDescription
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




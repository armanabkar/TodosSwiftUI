//
//  ItemRowView.swift
//  TodosSwiftUI
//
//  Created by Arman Abkar on 6/19/21.
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
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(fetchedItems, id: \.self) { toDoItems in
                        ItemRowView(item: toDoItems.item ?? "Empty", dateCreated: toDoItems.dateCreated!, priority: toDoItems.priority ?? "Empty")
                    }
                    .onDelete(perform: removeItems)
                }
                .navigationBarTitle(Text("Todos"))
                .toolbar(content: {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.primary)
                            .imageScale(.large)
                    }
                })
                
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
            .sheet(isPresented: $showingSheet) {
                SheetView(addItem: addItem,
                          toDoItem: $toDoItem,
                          setPriority: $setPriority)
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
        showingSheet.toggle()
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
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

struct SheetView: View {
    
    let addItem: () -> Void
    @Binding var toDoItem: String
    @Binding var setPriority: String
    
    var body: some View {
        VStack {
            HStack {
                TextField("Type Something...", text: $toDoItem)
                    .padding(.all, 4)
                    .font(Font.system(size: 25, design: .default))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: addItem){
                    Image(systemName: "plus.circle")
                        .foregroundColor(.black)
                        .imageScale(.large)
                }
            }
            
            Picker(selection: $setPriority, label: Text("")) {
                Text("No Rush").tag("😌")
                Text("Important").tag("✅")
                Text("Urgent").tag("🚨")
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
    }
}

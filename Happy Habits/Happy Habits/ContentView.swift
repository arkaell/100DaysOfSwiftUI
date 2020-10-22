//
//  ContentView.swift
//  Happy Habits
//
//  Created by David Liongson on 10/16/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var habits = Habits()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habits.activities) { activity in
                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                        ActivityRowView(activity: activity)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("Happy Habits")
            .navigationBarItems(
                leading:
                EditButton(),
                trailing:
                Button("Add") {
                    self.showingAddActivity.toggle()
                }
            )
        }
        .environmentObject(habits)
        .sheet(isPresented: $showingAddActivity, content: {
            AddActivityFormView(isPresented: self.$showingAddActivity, habits: habits)
        })
    }
    
    func removeItems(at offsets: IndexSet) {
        habits.activities.remove(atOffsets: offsets)
    }
}

struct ActivityDetailView: View {
    
    @State var activity: Activity
    
    @EnvironmentObject var habits: Habits
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(activity.title)
                .font(.largeTitle)
            Text(activity.description)
                .font(.headline)
            Text("\(activity.completions)")
                .font(.headline)
            Button("Completed") {
                if let currentActivityIndex = habits.activities.firstIndex(where: { $0.id == activity.id }) {
                    habits.activities[currentActivityIndex].incrementCompletions()
                }
                activity.incrementCompletions()
            }
        }
    }
    

}

struct ActivityRowView: View {
    var activity: Activity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.headline)
                Text(activity.description)
                    .font(.caption)
            }
            Spacer()
            Text("\(activity.completions)")
                .font(.largeTitle)
        }
    }
}

struct AddActivityFormView: View {
    
    @Binding var isPresented: Bool
    @State var habits: Habits
    
    @State private var title: String = ""
    @State private var description: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter details about your activity")) {
                    TextField("Title of the activity", text: $title)
                    TextField("Description of the activity", text: $description)
                }
            }
            .navigationBarTitle("New Activity")
            .navigationBarItems(leading: Button("Cancel") {
                self.isPresented = false
            }, trailing: Button("Save") {
                let newActivity = Activity(title: self.title, description: self.description)
                habits.activities.append(newActivity)
                self.isPresented = false
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

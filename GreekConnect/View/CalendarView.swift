import SwiftUI

struct CalendarView: View {
    @ObservedObject var vm: ViewModel
    @State private var selectedDate: Date = Date()
    @State private var isAddingEvent = false
    @State private var events: [String: [String]] = [
        "2024-12-01": ["ACAB", "Yep"],
        "2024-12-02": ["Durrrr", "Elections"]
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Calendar Header
                
                // DatePicker for Month & Year selection
                DatePicker(
                    "Choose Month",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                // Events for the selected date
                if let selectedEvents = events[formattedDate(selectedDate)] {
                    Text("Events on \(formattedDate(selectedDate))")
                        .font(.headline)
                        .padding(.top)
                    
                    List(selectedEvents, id: \.self) { event in
                        Text(event)
                        //Make each event clickable
                    }
                } else {
                    Text("No events for \(formattedDate(selectedDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddingEvent = true
                    }) {
                        Image(systemName: "plus")
                            .font(.callout)
                            .foregroundColor(Color.purple)
                            
                    }
                }
            }
            .sheet(isPresented: $isAddingEvent) {
                AddEventView(
                    selectedDate: $selectedDate,
                    onSave: { newEvent,arg  in
                        let dateKey = formattedDate(selectedDate)
                        if events[dateKey] != nil {
                            events[dateKey]?.append(newEvent)
                        } else {
                            events[dateKey] = [newEvent]
                        }
                        isAddingEvent = false
                    },
                    onCancel: {
                        isAddingEvent = false
                    }
                )
            }
        }
    }
    
    // Helper function to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct AddEventView: View {
    @Binding var selectedDate: Date
    @State private var eventTitle: String = ""
    @State private var selectedTag: String? = nil
    @State private var location: String = ""
    @State private var description: String = ""
    let possibleTags: [String] = ["Brotherhood", "Social Event", "Philanthropy"]
    let onSave: (String, String?) -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 0){
                // Event Title Input
                TextField("Event Title", text: $eventTitle)
                    .padding(15)
                    .padding(.horizontal)
                    
                // DatePicker for Event Date
                DatePicker("Date", selection: $selectedDate, displayedComponents: [.date])
                    .padding(15)
                    .padding(.horizontal)
                TextField("Location", text: $location)
                    .padding(15)
                    .padding(.horizontal)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(5...10)
                    .padding(15)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
                // Dropdown Menu for Tags
                Menu {
                    ForEach(possibleTags, id: \.self) { tag in
                        Button(action: {
                            selectedTag = tag
                        }) {
                            Text(tag)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedTag ?? "Select a Tag")
                            .foregroundColor(selectedTag == nil ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(15)
                    .padding(.horizontal)
                    .background(Color.clear)
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .navigationTitle(Text("Add an Event"))
            .navigationBarTitleDisplayMode(.inline)
 // Inline title to reduce gap
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !eventTitle.isEmpty {
                            onSave(eventTitle, selectedTag)
                        }
                    }
                    .disabled(eventTitle.isEmpty)
                }
            }
        }
    }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(vm: ViewModel())
    }
}

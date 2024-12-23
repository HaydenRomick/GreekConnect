//
//  DashboardView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import SwiftUI

let tempPassEvents: [tempEvent] = [
    tempEvent(title: "Event 1", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!),
    tempEvent(title: "Event 2", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
    tempEvent(title: "Event 3", date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
    tempEvent(title: "Event 4", date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
    tempEvent(title: "Event 5", date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!),
    tempEvent(title: "Event 6", date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!)
]
let tempUsers: [User] = [
    User(name: .init(first: "John", middle: "A.", last: "Doe"), pledgeClass: "Alpha", email: "john.doe@example.com", company: "TechCorp", role: "Engineer", status: "Active"),
    User(name: .init(first: "Jane", middle: nil, last: "Smith"), pledgeClass: "Beta", email: "jane.smith@example.com", company: "Innovate Inc", role: "Manager", status: "Alumni"),
    User(name: .init(first: "Alice", middle: "B.", last: "Johnson"), pledgeClass: "Gamma", email: "alice.johnson@example.com", company: "Creative Labs", role: "Designer", status: "Active")
]

struct DashboardView: View {
    
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        
//    case home
//    case directory
//    case calendar
        VStack {
            if vm.selectedTab == .home {
                HomeView(vm: vm)
            } else if vm.selectedTab == .directory {
                DirectoryView(vm: vm)
            } else if vm.selectedTab == .calendar {
                CalendarView(vm: vm)
            } else if vm.selectedTab == .weekly {
                WeeklyCalendarView(events: tempPassEvents)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    vm.selectedTab = .directory
                }) {
                    VStack {
                        Image(systemName: "person")
                        Text("Catalog")
                    }
                }
                .foregroundColor(vm.selectedTab == .directory ? Color.purple : .gray)
                
                Spacer()
                
                Button(action: {
                    vm.selectedTab = .home
                }) {
                    VStack{
                        // Put Image here
                        Image(systemName: "house")
                        Text("Dashboard")
                    }
//                }.foregroundColor(vm.selectedTab == .directory ? Color(hex: vm.green) : .gray)
                }.foregroundColor(vm.selectedTab == .home ? Color.purple : .gray)

                
                Spacer()
                Button(action: {
                    vm.selectedTab = .calendar
                }) {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                }
                .foregroundColor(vm.selectedTab == .calendar ? Color.purple : .gray)
                
                Spacer()
                Button(action: {
                    vm.selectedTab = .weekly
                }) {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Weekly")
                    }
                }
                .foregroundColor(vm.selectedTab == .weekly ? Color.purple : .gray)
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DashboardView(vm: ViewModel())
}

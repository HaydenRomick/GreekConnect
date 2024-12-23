//
//  DirectoryView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import SwiftUI

// User struct with detailed information


// Sample data
//let sampleUsers: [User] = [
//    User(name: .init(first: "John", middle: "A.", last: "Doe"), pledgeClass: "Alpha", email: "john.doe@example.com", company: "TechCorp", role: "Engineer", status: "Active"),
//    User(name: .init(first: "Jane", middle: nil, last: "Smith"), pledgeClass: "Beta", email: "jane.smith@example.com", company: "Innovate Inc", role: "Manager", status: "Alumni"),
//    User(name: .init(first: "Alice", middle: "B.", last: "Johnson"), pledgeClass: "Gamma", email: "alice.johnson@example.com", company: "Creative Labs", role: "Designer", status: "Active")
//]

// Catalog View
struct DirectoryView: View {
    @ObservedObject var vm: ViewModel
    @State var searchText: String = ""
    var searchedUsers: [User] {
        if searchText.isEmpty {
            return vm.directory
        }
        return vm.directory.filter { user in
            let lowercasedSearchText = searchText.lowercased()
            // Check all relevant fields for the search text
            return user.name.first.lowercased().contains(lowercasedSearchText) ||
                   (user.name.middle?.lowercased().contains(lowercasedSearchText) ?? false) ||
                   user.name.last.lowercased().contains(lowercasedSearchText) ||
                   user.pledgeClass.lowercased().contains(lowercasedSearchText) ||
                   user.company.lowercased().contains(lowercasedSearchText) ||
                   user.role.lowercased().contains(lowercasedSearchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(searchedUsers.indices, id: \.self) { index in
                        UserCardView(user: searchedUsers[index])
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }.searchable(text: $searchText, prompt: "Name, Pledge Class, Role, or Company")
                .navigationTitle("Directory")
//            .toolbar{
//                ToolbarItem(placement: .principal){
//                    Text("Search Bar")
//                        .searchable(text: $searchText)
//                }
//                
//            }
        }
    }
}

// User Card View
struct UserCardView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Status
            HStack {
                VStack(alignment: .leading) {
                    Text("\(user.name.first) \(user.name.middle ?? "") \(user.name.last)")
                        .font(.headline)
//                    @State private var roles: [String] = ["Alumni", "Active", "Inactive", "Recorder", "Treasurer", "Archon", "Deputy Archon", "Warden", "New Member Educator", "Health and Safety"]

                    Text(user.status)
                        .font(.subheadline)
                        .foregroundColor(user.status == "Active" ? .green : user.status == "Alumni" ? .purple :  ["Archon", "Health and Safety", "Warden", "New Member Educator", "Treasurer", "Recorder"].contains(user.status) ? .red : .gray)
                }
                Spacer()
            }
            
            // Pledge Class and Role
            HStack {
                Label("Pledge Class: \(user.pledgeClass)", systemImage: "person.3.fill")
                Spacer()
                Label("Role: \(user.role)", systemImage: "briefcase.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            // Email and Company
            VStack(alignment: .leading, spacing: 4) {
                Label(user.email, systemImage: "envelope.fill")
                Label(user.company, systemImage: "building.2.crop.circle.fill")
            }
            .font(.footnote)
            .foregroundColor(.blue)
            
            Divider()
        }
        .navigationBarBackButtonHidden()
        .padding()
        .background(Color.clear)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Preview


#Preview {
    DirectoryView(vm: {
        let rv = ViewModel()
        rv.getDirectory()
        rv.email = "test@gmail.com"
        rv.firebaseID = "8gdJYjTcTpXeiZOi567EjzGTk2d2"
        
        return rv
    }() )
}

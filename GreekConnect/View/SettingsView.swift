//
//  SettingsView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//
import SwiftUI


struct SettingsView: View {
    @ObservedObject var vm: ViewModel
    @State private var isLoggingOut = false
    @State private var showingConfirmation = false
    @State private var isEditing = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    Text("First Name: \(vm.profile?.name.first ?? "")")
                    if vm.profile?.name.middle != "" {
                        Text("Middle Name: \(vm.profile?.name.middle ?? "")")
                    }
                    Text("Last Name: \(vm.profile?.name.last ?? "Log Back In")")
                }
                
                Section(header: Text("Pledge Class")) {
                    Text("\(vm.profile?.pledgeClass ?? "")")
                }
                
                Section(header: Text("Contact Information")) {
                    Text("Email: \(vm.email)")
                }
                
                Section(header: Text("Work Details")) {
                    Text("Company: \( vm.profile?.company ?? "" )")
//                    EditableRow(label: "Company: ", text: $vm.profile.company,  isEditing: $isEditing)
                        
                    Text("Role: \(vm.profile?.role ?? "")")
                }
                
                Section(header: Text("Status")) {
                    Text("\(vm.profile?.status ?? "")")
                }
            }.navigationTitle("User Settings")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $isLoggingOut) {
                    LoginView(vm:vm)
                }
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button( action: {
                            if vm.isLoggedIn == false {
                                vm.showingAlert = true
                            } else {
                                showingConfirmation = true
                            }
                        }){
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }.alert(isPresented: $vm.showingAlert){
                            Alert(title: Text("Logout Error"), message: Text("User is not logged in"), dismissButton: .default(Text("OK")))
                        }.confirmationDialog("Logout Confirmation", isPresented: $showingConfirmation) {
                            Button ("Yes") {
                                vm.logout()
                                isLoggingOut = true
                            }
                            Button("No") {}
                            
                        } message: {
                            Text("Are you sure you want to log out?")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading){
                        Button(action: {
                                isEditing.toggle()
                                }) {
                                    Text(isEditing ? "Done" : "Edit")
                                }
                    }
                }

        }
    }
}

struct EditableRow: View {
    let label: String
    @Binding var text: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            Text("\(label):")
            if isEditing {
                TextField(label, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(text.isEmpty ? "Tap to Edit" : text)
                    .foregroundColor(text.isEmpty ? .gray : .primary)
            }
            Spacer()
            if !isEditing {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    SettingsView(vm: ViewModel())
}




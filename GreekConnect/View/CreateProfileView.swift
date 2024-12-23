//
//  CreateProfileView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//
import SwiftUI

struct CreateProfileView: View {
    
    @ObservedObject var vm: ViewModel
    
    @State private var firstName: String = ""
    @State private var middleName: String = ""
    @State private var lastName: String = ""
    @State private var pledgeClass: String = ""
    @State private var email: String = ""
    @State private var company: String = ""
    @State private var role: String = ""
    @State private var status: String?
    @State private var roles: [String] = ["Alumni", "Active", "Inactive", "Recorder", "Treasurer", "Archon", "Deputy Archon", "Warden", "New Member Educator", "Health and Safety"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            TextField("First Name", text: $firstName)
                .padding()
            TextField("Last Name", text: $lastName)
                .padding()
            TextField("Pledge Class", text: $pledgeClass)
                .padding()
            TextField("Email", text: $email)
                .padding()
                .background(.gray)
                .cornerRadius(8)
                .disabled(true)
//                    .keyboardType(.emailAddress)
            TextField("Company", text: $company)
                .padding()
            TextField("Job Sector; i.e. Marketing, Student", text: $role)
                .padding()
            Menu {
                ForEach(roles, id: \.self) { tag in
                    Button(action: {
                        status = tag
                    }) {
                        Text(tag)
                    }
                }
            } label: {
                HStack {
                    Text(status ?? "Select a Status")
                        .foregroundColor(status == nil ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(8)
                .padding(.horizontal)
                .cornerRadius(8)
            }
            
            .padding()
            .background(Color.gray)
            .cornerRadius(8)

            Button(action: {
                // Placeholder for save profile logic
                Task {
                    let user = UserManager.shared.createUser(firstName: firstName, middleName: middleName, lastName: lastName, pledgeClass: pledgeClass, email: email, company: company, role: role, status: status!)
                    if let ID = vm.firebaseID {
                        await UserManager.shared.uploadUserHelper(user: user, firebaseID: ID)
                        vm.login()
                    }
                }
            }) {
                Text("Save Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.purple)
                    .cornerRadius(8)
            }
            .padding(.top, 20)

            Spacer()
        }.onAppear{
            email = vm.email
        }.navigationDestination(isPresented: $vm.isLoggedIn){
            DashboardView(vm: vm)
        }
        .padding()
    }
}

#Preview {
    CreateProfileView(vm: {
        let rv = ViewModel()
        
        rv.email = "test@gmail.com"
        rv.firebaseID = "8gdJYjTcTpXeiZOi567EjzGTk2d2"
        
        return rv
    }() )
}

//#Preview {
//    TestView(vm: {
//        let rv = ViewModel()
//        
//        // login with an account that has prfile
//        rv.username = "testguy420@gmail.com"
//        rv.password = "thisisatest"
//        rv.login()
//        print(rv.errorMessage)
//        return rv
//    }())
//}

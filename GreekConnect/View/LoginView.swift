//
//  LoginView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: ViewModel


    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer ()
                VStack {
                    Text("ΣΑΕ")
                        .font(.system(size: 90))
                        .fontWeight(.bold)
                    Text("NC Delta")
                        .font(.subheadline)
                        Divider()
                }
                
                
                TextField("Email", text: $vm.email)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(8)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                
                SecureField("Password", text: $vm.password)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(8)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                
                Button(action: {
                    // No functionality yet
                    Task {
                        vm.login()
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top)
                .navigationBarBackButtonHidden()
                Spacer()
                
            }.navigationDestination(isPresented: $vm.isCreated) {
                DashboardView(vm: vm)
            }
            .navigationDestination(isPresented: $vm.navigateToCreate){
                CreateProfileView(vm:vm)
            }
            .navigationBarBackButtonHidden(true)
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(vm: ViewModel())
    }
}

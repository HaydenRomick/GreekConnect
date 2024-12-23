//
//  ContentView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import SwiftUI

import SwiftUI

/**
 Step 1
 */
struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        if vm.isLoggedIn {
            if vm.profile == .none {
                CreateProfileView(vm: vm)
            } else {
                DashboardView(vm: vm)
            }
        } else {
            LoginView(vm: vm)
        }
    }
}

#Preview {
    ContentView()
}

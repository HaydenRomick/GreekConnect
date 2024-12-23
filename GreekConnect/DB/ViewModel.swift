//
//  ViewModel.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import Foundation
import FirebaseAuth
@MainActor final class ViewModel: ObservableObject {
    @Published var email = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var password = UserDefaults.standard.string(forKey: "password") ?? ""
    @Published var isSignedUp = false
    @Published var confirmPassword: String = ""
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false
    @Published var showingAlert = false
    @Published var isLoading:Bool = false
    @Published var errorMessage:String? = ""
    @Published var isSignedup:Bool = false
    @Published var firebaseID:String?
    @Published var isCreated:Bool = false
    @Published var navigateToCreate:Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var selectedTab: Tab = .home
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var profile: User? {
        didSet {
            DispatchQueue.main.async {
                self.isCreated = (self.profile != .none)
            }
        }
    }

    @Published var directory: [User] = []
    
    func getDirectory() {
        UserManager.shared.fetchAllUsers(){
            Users in
            self.directory = Users ?? []
        }
    }
    func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-zA-Z]).{8,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    
//    func login() {
//        isLoading = true
//        errorMessage = nil
//        
//        Auth.auth().signIn(withEmail: username, password: password) {
//            authResult, error in
//            if let error = error {
//                self.errorMessage = "Error: \(error.localizedDescription)"
//                self.isLoading = false
//            }
//            else if authResult == nil {
//                self.errorMessage = "Error: No Authorization"
//                self.isLoading = false
//            } else {
//                //Successfully logged in
//                Task {
//                    let user = Auth.auth().currentUser
//                    if let user = user {
//                        self.firebaseID = user.uid
//                    }
//                }
//            }
//        }
//    }
    
    
    ///logs user and stores in firebase using Auth package, ties profile to firebase ID using ProfileManager to get a profile.
    func login() {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
            } else if authResult == nil {
                self.errorMessage = "Error: No authorization"
                self.isLoading = false
            } else {
                // Successfully logged in
                // spend one more second to fetch the existing profile if any
                // After successful sign in retrieve user information
                Task {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        self.firebaseID = user.uid
                        UserManager.shared.downloadUser(firebaseID: self.firebaseID!) { user in
                            self.profile = user
                            if self.profile == nil {
                                self.navigateToCreate = true
                            } else {
                                self.isLoggedIn = true
                                self.navigateToCreate = false
                                self.getDirectory()
                            }
                            self.isLoading = false
                            
                        }
                    } else {
                        self.isLoggedIn = true
                        self.isLoading = false
                    }
                }
            }
        }
    }
    /// logs user out using firebase Auth package
    func logout() {
        guard self.isLoggedIn else{
            print("Attempted log out. isLoggedIn: \(self.isLoggedIn)")
            return
        }
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.email = ""
                self.password = ""
                self.firebaseID = ""
                self.profile = nil
                self.directory = []
                print("Successfully signed out.")
                
                self.isLoggedIn = false
            }
        } catch{
            print("Error signing out: \(error)")
        }
    }
    ///resets password using firebase Auth package
    func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound:
                    self.alertMessage = "If an account with this email exists, a password reset link has been sent."
                case .invalidEmail:
                    self.alertMessage = "The email address is not valid."
                default:
                    self.alertMessage = error.localizedDescription
                }
            } else {
                self.alertMessage = "If an account with this email exists, a password reset link has been sent."
            }
            self.showAlert = true
        }
    }
    
    enum Tab {
            case home
            case directory
            case calendar
            case weekly
        }
}

//
//  UserManager.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/3/24.
//
import FirebaseDatabase
import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    //            self.partyCreated = (self.party != .none)
    
    init() {}
    
    func createUser(
        firstName: String,
        middleName: String?,
        lastName: String,
        pledgeClass: String,
        email: String,
        company: String,
        role: String,
        status: String
    ) -> User {
        let name = User.Name(first: firstName, middle: middleName, last: lastName)
        return User(name: name, pledgeClass: pledgeClass, email: email, company: company, role: role, status: status)
    }
    
    func uploadUserHelper(user: User, firebaseID: String) async {
        //This works
        let database = Database.database().reference()
        let path = "Users/\(firebaseID)"
        do {
            // Convert User object to dictionary using JSONEncoder
            let jsonData = try JSONEncoder().encode(user)
            guard let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Failed to convert JSON data to dictionary")
                return
            }
            
            // Upload the dictionary to Firebase
            try await database.child(path).setValue(jsonDict) { error, _ in
                if let error = error {
                    print("Failed to upload user: \(error.localizedDescription)")
                } else {
                    print("User uploaded successfully!")
                }
            }
        } catch {
            print("Error encoding user: \(error.localizedDescription)")
        }
    }
    
    func downloadUser(firebaseID: String, completion: @escaping (User?) -> Void) {
        let path = "Users/\(firebaseID)"
        let database = Database.database().reference()
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let json = snapshot.value as? [String: Any] else {
                print("No data found for user with ID: \(firebaseID)")
                completion(nil)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                completion(user)
            } catch {
                print("Failed to decode user: \(error.localizedDescription)")
                completion(nil)
            }
        } withCancel: { error in
            print("Error fetching user: \(error.localizedDescription)")
            completion(nil)
        }
    }


    func fetchAllUsers(completion: @escaping ([User]?) -> Void) {
        let databaseRef = Database.database().reference()
        
        databaseRef.child("Users").observeSingleEvent(of: .value) { snapshot, _ in
//            print(snapshot)
            

            guard let usersData = snapshot.value as? [String: Any] else {
                print("No data found or data format mismatch")
                completion(nil)
                return
            }
            
//            print(usersData)
            var users: [User] = []
            
            do {
                for (userID, userDetails) in usersData {
                    print(userID, userDetails)
                    let jsonData = try JSONSerialization.data(withJSONObject: userDetails, options: [])
                    let user = try JSONDecoder().decode(User.self, from: jsonData)
                    print(user)
                    users.append(user)
                    
                }
                completion(users)
            } catch {
                print("Error decoding user data: \(error)")
                completion(nil)
            }
        }
    }


}

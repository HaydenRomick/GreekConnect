//
//  HomeView.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import SwiftUI


import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: ViewModel
    @State private var isShowingPostSheet: Bool = false
    @State private var selectedPostID: Int? = nil
    @State private var isShowingPostDetails: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Posts and User Information VStack
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(0..<5, id: \.self) { index in
                            PostView(postID: index, onUserDoubleTap: {
                                selectedPostID = index
                                isShowingPostDetails.toggle()
                                
                            })
                        }
                    }
                    .padding()
                }
                .refreshable {
                    // Add in refreshable code for retrieveing information
                }
                Spacer()
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            // Action to add a new post
                            print("Add post button tapped")
                            isShowingPostSheet.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                                .opacity(0.6)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar{
                HStack {
                    NavigationLink {
                        SettingsView(vm: vm)
                    }label: {
                        Image(systemName: "person.circle")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                    }
                }
            }
            .sheet(isPresented: $isShowingPostSheet) {
                AddPostView()
            }
            .sheet(isPresented: $isShowingPostDetails){
                if let postID = selectedPostID {
                    PostDetailsView(postID: postID)
                }
            }
        }
    }
}


// MARK: - AddPostView
struct AddPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var description: String = ""
    private let descriptionWordLimit = 500
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Create a Post")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 10)
                
                // Title Input
                TextField("Enter Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 10)
                
                // Description Input
                VStack(alignment: .leading) {
                    Text("Description (max \(descriptionWordLimit) words)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 150, maxHeight: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .onChange(of: description) { newValue in
                            limitDescriptionWordCount()
                        }
                }
                
                Spacer()
                
                // Submit and Cancel Buttons
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                    .padding()
                    
                    Spacer()
                    
                    Button("Submit") {
                        print("Post Submitted: Title = \(title), Description = \(description)")
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                    .foregroundColor(title.isEmpty || description.isEmpty ? .gray : .blue)
                    .padding()
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private func limitDescriptionWordCount() {
        let words = description.split { $0.isWhitespace }
        if words.count > descriptionWordLimit {
            description = words.prefix(descriptionWordLimit).joined(separator: " ")
        }
    }
}

// MARK: - PostView
struct PostView: View {
    let postID: Int
    @State private var showComments = false // State to toggle comments section
    @State private var isLiked: Bool = false // Add in like and dislike parsing in regards with UUID so keep a list of UUID for Likes: UUID1, UUID2 etc. , dislikes: UUID1, UUID2
    @State private var isDisliked: Bool = false
    
    var onUserDoubleTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // User Information and Post Content
            HStack {
                Text("User \(postID + 1)")
                    .font(.headline)
                    .padding(.top, 5)
                Spacer()
                Menu {
                    Button(action: {
                        // Implement Edit functionality
                    }) {
                        Text("Edit")
                            .foregroundColor(.purple)
                    }
                    Button(action: {
                        //Implemenent Delete Functionality
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                } label: {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")

                }
            }

            
            Text("This is a placeholder for post content. Post ID: \(postID)")
                .font(.body)
            
            // Action Buttons (Comment, Like, Dislike)
            HStack {
                Button(action: {
                    withAnimation {
                        showComments.toggle() // Toggle comments visibility
                    }
                }) {
                    HStack {
                        Image(systemName: "bubble.left")
                        Text("Comment")
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        print("Like tapped on post \(postID)")
                        withAnimation(.spring()){
                            isLiked.toggle()
                        }
                    }) {
                        Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .foregroundColor(.green)
                    }
                    Button(action: {
                        print("Dislike tapped on post \(postID)")
                        withAnimation(.spring()) {
                            isDisliked.toggle()
                        }
                    }) {
                        Image(systemName: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .foregroundColor(.red)
                    }
                }
            }

            
            // Comments Section
            if showComments {
                VStack(alignment: .leading, spacing: 5) {
                    Divider()
                    ForEach(0..<3, id: \.self) { commentIndex in
                        HStack(alignment: .top) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.gray)
                            
                            VStack(alignment: .leading) {
                                Text("User \(commentIndex + 1)")
                                    .font(.caption)
                                    .bold()
                                Text("This is a sample comment for post \(postID).")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 3)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
        .onTapGesture(count: 2) {
            onUserDoubleTap()
        }
    }
}

// MARK: - PostDetailsView (Bottom Drawer)
struct PostDetailsView: View {
    let postID: Int
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Post Details")
                    .font(.title)
                    .bold()
                
                // Full Post Content
                Text("This is the detailed view of the post content for Post ID: \(postID).")
                    .font(.body)
                    .padding(.bottom, 10)
                
                // Comments Section
                Text("Comments")
                    .font(.headline)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0..<5, id: \.self) { commentIndex in
                            HStack(alignment: .top) {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading) {
                                    Text("User \(commentIndex + 1)")
                                        .font(.caption)
                                        .bold()
                                    Text("This is a sample comment for Post \(postID).")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Post \(postID + 1)")
            .navigationBarItems(trailing: Button("Close") {
                // Close the sheet
            })
        }
    }
}



#Preview {
    HomeView(vm: ViewModel())
}

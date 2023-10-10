//
//  PostDataManager.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import Foundation
import CoreData

class PostDataManager {
    private var posts: [Post] = []
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //CREATE
    func createPost(id: Int16, userId: Int16, title: String, body: String) -> Post? {
        let newPost = Post(context: context)
        newPost.id = id
        newPost.userId = userId
        newPost.title = title
        newPost.body = body
        
        do{
            try context.save()
            return newPost
        }catch let error {
            print("error:", error)
            return nil
        }
        
    }
    
    //READ
    func fetch() {
        do{
            self.posts = try self.context.fetch(Post.fetchRequest())
        }catch let error {
            print("error:", error)
        }
    }
    
    //UPDATE
    func updatePost(post: Post, title: String, body: String) -> Post {
        post.title = title
        post.body = body
        
        do{
            try context.save()
        }catch let error {
            print("error: ", error)
        }
        
        return post
        
    }
    
    //DELETE
    func deletePost(post: Post) -> Bool {
        self.context.delete(post)
        
        do{
            try context.save()
            return true
        }catch let error {
            print("error: ", error)
            return false
        }
    }
    
    func countPost() -> Int {
        return posts.count
    }
    
    func getPost(at index: Int) -> Post {
        return posts[index]
    }
    
}

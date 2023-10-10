//
//  PostServiceManager.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import Foundation

class PostServiceManager {
    
    private var posts: [MyPost] = []
    
    static let shared = PostServiceManager()
    
    init() {
        
    }
    
    //CREATE
    func createPost(post : MyPost, completion: @escaping (MyPost?) -> Void) {
        guard let url = URL(string: Constants.postURL) else {
            completion(nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //value - key
        
        do {
            //Encode our post
            let jsonData = try JSONEncoder().encode(post)
            
            print("JSON:", try JSONSerialization.jsonObject(with: jsonData) )
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    //Handle response data
                    if let createdPost = try? JSONDecoder().decode(MyPost.self, from: data) {
                        completion(createdPost)
                    }
                } else if let error = error {
                    print("Error:", error)
                    completion(nil)
                }
            }
            task.resume()
        } catch let error{
            print("Error:", error)
            completion(nil)
        }
    }
    
    //READ
    func loadPostsData(completion: @escaping () -> Void) {
        let url = URL(string: Constants.postURL)!
        let session = URLSession.shared
        var httpResponse = HTTPURLResponse()
        var loadedPosts : [MyPost] = []
        
        // Creates a data task with a URL request
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                httpResponse = (response as? HTTPURLResponse)!
                print("statusCode: ", httpResponse.statusCode)
                return
            }
            
            // Check if there is any data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Parse and use the data
            do {
                print(data)
                let decodedResponse = try JSONDecoder().decode([MyPost].self, from: data)
                
                loadedPosts = decodedResponse
                
                for post in loadedPosts {
                    self.posts.append(post)
                    print("post:", post.title)
                }
                
            } catch let error{
                loadedPosts = []
                print("JSON parsing error: \(error)")
            }
            completion()
        }
        
        // Start the task
        task.resume()
    }
    
    
    //UPDATE
    func updatePost(post : MyPost, completion: @escaping (MyPost?) -> Void) {
        let urlString = Constants.postURL + String(post.id!)
        print("urlString:", urlString)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") //value - key
        
        do {
            //Encode our post
            let jsonData = try JSONEncoder().encode(post)
            print("JSON:", try JSONSerialization.jsonObject(with: jsonData) )
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    //Handle response data
                    if let updatedPost = try? JSONDecoder().decode(MyPost.self, from: data) {
                        completion(updatedPost)
                    }
                } else if let error = error {
                    print("Error:", error)
                    completion(nil)
                }
            }
            task.resume()
        } catch let error{
            print("Error:", error)
            completion(nil)
        }
    }
    
    
    //DELETE
    
    
    
}

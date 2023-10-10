//
//  ViewController.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    let postService = PostServiceManager.shared
    
    var currentPost: MyPost?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        postService.loadPostsData {
            print("Loaded data....")
        }
        
        
    }
    
    @IBAction func unwindFromPostDetail(segue: UIStoryboardSegue) {
        print("unwind")
        let source = segue.source as! AddPostViewController
        
        currentPost = source.postDetail
        
        if currentPost != nil {
            print("title: ", currentPost!.title)
            print("body: ", currentPost!.body)
            
            currentPost?.id = 25
            
            postService.createPost(post: currentPost!){ createdPost in
                if let post = createdPost {
                    print("created post: ", post)
                    self.currentPost = post
                }else {
                    print("Error: Post creation failed...")
                }
            }
            
            postService.updatePost(post: currentPost!){ updatedPost in
                if let post = updatedPost {
                    print("updated post: ", post)
                }else {
                    print("Error: Post update failed...")
                }
            }
            
            
        }
        
        
        
    }


}


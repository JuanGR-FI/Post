//
//  ViewController.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    let postService = PostServiceManager.shared
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var postManager: PostDataManager?
    
    var currentPost: Post?
    
    var auxPost: MyPost?
    
    var currentId: Int16 = 0
    
    
    @IBOutlet var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //print(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last! as String)
        
        //Retrieving data from DB
        postManager = PostDataManager(context: context)
        postManager?.fetch()
        
        //Updating tableview data
        postTableView.reloadData()
        
        //Datasource and delegate
        postTableView.dataSource = self
        postTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentId = getConfig(key: Constants.currentIdKey) as? Int16 ?? 0
        print("Current id in BD: ", currentId)
    }
    
    @IBAction func unwindFromPostDetail(segue: UIStoryboardSegue) {
        print("unwind")
        let source = segue.source as! AddPostViewController
        currentPost = source.postDetail
        
        if currentPost!.id == 0 { //Create a new Post
            currentId += 1
            print("Creating new post...")
            auxPost = MyPost(id: currentId, title: (currentPost?.title)!, body: (currentPost?.body)!, userId: currentPost!.userId)
            
            postService.createPost(post: auxPost!){ createdPost in //Creating post in Remote Server
                if let post = createdPost {
                    //print("created post: ", post)
                    self.auxPost = post
                    
                    //Saving in BD
                    self.currentPost?.id = self.currentId
                    
                    do{
                        try self.context.save()
                    }catch let error {
                        print("error:", error)
                    }
                    
                    //Reloading UI
                    self.postManager?.fetch()
                    DispatchQueue.main.async {
                        self.postTableView.reloadData()
                    }
                    
                    //Saving currentId
                    self.saveConfig(key: Constants.currentIdKey, value: self.currentId)
                    
                }else {
                    print("Error: Post creation failed...")
                }
            }
        }else { //Update a Post
            print("Updating post...")
            
            auxPost = MyPost(id: currentPost?.id, title: (currentPost?.title)!, body: (currentPost?.body)!, userId: currentPost!.userId)
            
            postService.updatePost(post: auxPost!){ updatedPost in //Updating post in Remote Server
                if let post = updatedPost {
                    //print("updated post: ", post)
                    
                    //Updating in BD
                    do{
                        try self.context.save()
                    }catch let error {
                        print("error:", error)
                    }
                    
                    //Reloading UI
                    self.postManager?.fetch()
                    DispatchQueue.main.async {
                        self.postTableView.reloadData()
                    }
                    
                }else {
                    print("Error: Post update failed...")
                }
            }
        }
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (postManager?.countPost())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
        cell.titleLabel.text = postManager?.getPost(at: indexPath.row).title
        cell.idLabel.text = String(Int((postManager?.getPost(at: indexPath.row).id)!))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let post = (postManager?.getPost(at: indexPath.row))!
            
            
            
            postService.deletePost(id: Int(post.id)){ statusCode in //Deleting post in Remote Server
                if statusCode == 200 {
                    if self.postManager!.deletePost(post: post) { //Deleting from DB
                        
                        
                        //Reloading UI
                        self.postManager?.fetch()
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            self.postTableView.reloadData()
                        }
                    }
                    print("Post deleted successfully!")
                }else{
                    print("Failed post deletion...")
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPostSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostSegue" {
            let destination = segue.destination as! AddPostViewController
            destination.postDetail = postManager?.getPost(at: postTableView.indexPathForSelectedRow!.row)
        }
    }
    
    
}


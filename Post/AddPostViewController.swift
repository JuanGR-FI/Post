//
//  AddPostViewController.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import UIKit

class AddPostViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var postManager: PostDataManager?
    
    var postDetail: MyPost?
    
    
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareUI()
    }
    
    func prepareUI() {
        if postDetail != nil {
            titleTextView.text = postDetail?.title
            bodyTextView.text = postDetail?.body
        }else {
            postDetail = MyPost(id: nil, title: "", body: "", userId: Int16.random(in: 1...10))
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isModal = self.presentingViewController is UINavigationController
        if isModal {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController
        
        postDetail?.title = titleTextView.text
        postDetail?.body = bodyTextView.text
        
        destination.currentPost = postDetail
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var perform = false
        
        if titleTextView.text != "" && bodyTextView.text != "" {
            perform = true
        }else{
            createAlert()
        }
        
        return perform
        
    }
    
    func createAlert() {
        let alertMessage = UIAlertController(title: "Missing content!", message: "All fields must be filled", preferredStyle: .alert)
        
        let okAction =  UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertMessage.addAction(okAction)
        
        self.present(alertMessage, animated: true, completion: nil)
        
    }
    
    
    
}

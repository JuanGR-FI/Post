//
//  ViewControllerExtension.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 10/10/23.
//

import Foundation

//MARK: Methods to persist data
extension ViewController {
    
    func saveConfig(key: String, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key)
        //print("UD:", UserDefaults.standard.value(forKey: key)!)
    }
    
    func getConfig(key: String) -> Any {
        return UserDefaults.standard.object(forKey: key) as Any
    }
    
}

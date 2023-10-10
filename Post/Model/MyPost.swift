//
//  Post.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import Foundation

struct MyPost: Codable {
    var id: Int16?
    var title: String
    var body: String
    var userId: Int16
}

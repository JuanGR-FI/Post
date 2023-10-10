//
//  Post+CoreDataProperties.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var userId: Int16

}

extension Post : Identifiable {

}

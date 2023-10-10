//
//  CGColorExtension.swift
//  Post
//
//  Created by Juan Andrés Cervantes Guati Rojo on 09/10/23.
//

import Foundation
import UIKit

public extension CGColor {
    var UIColor : UIKit.UIColor {
        return UIKit.UIColor(cgColor: self)
    }
}

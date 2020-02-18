//
//  UIStoryboard.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 18/2/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import UIKit

extension UIStoryboard {
    public convenience init<T: UIViewController>(viewControllerType controllerType: T.Type) {
        var name = String(describing: T.self)
        
        if let range = name.range(of: "ViewController") {
            name = String(name[..<range.lowerBound])
        }
        
        self.init(name: name, bundle: Bundle(for: T.self))
    }
}

//
//  UIViewController+instantiateFromStoryboard.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 18/2/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func instantiateFromStoryboard<T: UIViewController>() -> T {
        let storyboard = UIStoryboard(viewControllerType: T.self)
        let controller = storyboard.instantiateInitialViewController() as! T
        return controller
    }
}

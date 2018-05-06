//
//  UIViewController+Additions.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var allChildViewControllers: [UIViewController] {
        
        func parentWithChilds(_ vc: UIViewController) -> [UIViewController] {
            return vc.childViewControllers.map { parentWithChilds($0) }.reduce([vc], +)
        }
        
        return childViewControllers.map { parentWithChilds($0) }.reduce([UIViewController](),+)
    }
    
}

//
//  UINavigationController.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import UIKit

extension UINavigationController {
    func forceUpdateNavBar() {
        DispatchQueue.main.async {
            self.navigationBar.sizeToFit()
        }
      }
}

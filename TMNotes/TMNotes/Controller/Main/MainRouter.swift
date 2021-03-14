//
//  MainRouter.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import UIKit

class MainRouter {

    class func call(to navigationController: UINavigationController, folder: String? = nil, _ animated: Bool) {
        let view = UIStoryboard.init(name: "Main",
                                     bundle: Bundle.main).instantiateViewController(withIdentifier: "Main")
            as? MainViewController
        view?.folder = folder
        navigationController.pushViewController(view!, animated: animated)
    }
}

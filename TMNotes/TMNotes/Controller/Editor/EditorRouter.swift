//
//  EditorRouter.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import UIKit

class EditorRouter {

    class func call(to navigationController: UINavigationController, note: Note? = nil, _ animated: Bool) {
        let view = UIStoryboard.init(name: "Main",
                                     bundle: Bundle.main).instantiateViewController(withIdentifier: "Editor")
            as? EditorViewController
        view?.note = note
        navigationController.pushViewController(view!, animated: animated)
    }
}

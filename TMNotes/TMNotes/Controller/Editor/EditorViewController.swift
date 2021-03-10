//
//  EditorViewController.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

class EditorViewController: UIViewController {
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        saveNoteIfNecessary()
        super.viewDidDisappear(true)
    }
}

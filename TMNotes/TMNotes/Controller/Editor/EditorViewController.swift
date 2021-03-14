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

    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveNoteIfNecessary()
        super.viewWillDisappear(true)
    }
}

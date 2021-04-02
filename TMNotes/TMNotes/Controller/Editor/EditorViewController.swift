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
    @IBOutlet weak var containerScrollView: UIScrollView!

    var note: Note?
    var tags: [String] = ["Tag1", "Tag2", "Tag3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initProvider()
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveNoteIfNecessary()
        super.viewWillDisappear(true)
    }

    @IBAction func tagVisibilityClick(_ sender: Any) {

    }
}

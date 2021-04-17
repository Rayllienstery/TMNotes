//
//  EditorViewController.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

class EditorViewController: UIViewController {
    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var folderTitle: UILabel!
    @IBOutlet weak var removeFolderButton: UIButton!

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var containerScrollView: UIScrollView!

    var note: Note?
    var folder: Folder?
    var tags: [String] = []

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

    @IBAction func removeFolderClick(_ sender: Any) {
        self.removeFolder()
    }
}

//
//  EditorViewController.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import UIKit

class SelectFolderViewController: UIViewController {
    @IBOutlet weak var foldersTableView: UITableView!
    var folders = [NotesFolder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateFoldersList()
    }
}

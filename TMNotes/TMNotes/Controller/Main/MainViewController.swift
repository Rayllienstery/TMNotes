//
//  MainViewController.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var notesListTableView: UITableView!

    var notes = [Note]()
    var folders = [NotesFolder]()

    var folder: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewWillAppearCompletion()
    }
}

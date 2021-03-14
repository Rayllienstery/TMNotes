//
//  MainViewController.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var notesListTableView: UITableView!

    var notes = [Note]()
    var folders = [NotesFolder]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewWillAppearCompletion()
    }
}

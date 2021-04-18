//
//  MainViewController.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var notesListTableView: UITableView!
    @IBOutlet weak var notesCounterLabel: UILabel!

    var notes = [Note]()
    var folders = [Folder]()

    var folder: Folder?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initProvider()
        self.initUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewWillAppearCompletion()
    }

    @IBAction func openFolderListClick() {
        openFolderListLogic()
    }

    @IBAction func editSorterClick(_ sender: Any) {
        editSorterLogic()
    }
}

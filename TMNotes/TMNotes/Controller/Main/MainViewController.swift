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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.viewDidAppearCompletion()
    }
}

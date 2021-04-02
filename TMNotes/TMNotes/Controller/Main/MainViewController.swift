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

    var folder: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.viewWillAppearCompletion()
    }

    @IBAction func openFolderList() {
        guard let view = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "SelectFolder")
                as? SelectFolderViewController else { return }
        view.completion = { folder in
            if let folder = folder, let navigation = self.navigationController {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    MainRouter.call(to: navigation, folder: folder, true)
                }
            }
        }
        self.present(view, animated: true, completion: nil)
    }
}

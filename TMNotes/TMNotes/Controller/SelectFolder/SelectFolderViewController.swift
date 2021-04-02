//
//  EditorViewController.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import UIKit

class SelectFolderViewController: UIViewController {
    @IBOutlet weak var foldersTableView: UITableView!
    var folders = [Folder]()
    var selectedFolder: String?
    var completion: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initProvider()
    }

    @IBAction func addFolderClick(_ sender: Any) {
        self.present(FoldersProvider.shared.createFolderAlert(), animated: true)
    }
}

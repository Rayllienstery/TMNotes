//
//  SelectFolderTableViewCell.swift
//  TMNotes
//
//  Created by Raylee on 14.03.2021.
//

import UIKit

class SelectFolderTableViewCell: UITableViewCell {
    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesCountLabel: UILabel!
    var folder: Folder?

    func setFolder(_ folder: Folder) {
        self.folder = folder

        self.titleLabel.text = folder.title
        self.notesCountLabel.text = "\(folder.getNotesCount()) notes"
        self.folderImageView.image = UIImage(systemName: folder.imagePath ?? "folder")
    }
}

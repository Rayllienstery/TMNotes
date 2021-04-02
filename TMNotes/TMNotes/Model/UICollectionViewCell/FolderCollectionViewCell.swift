//
//  FolderCollectionViewCell.swift
//  TMNotes
//
//  Created by Raylee on 10.03.2021.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesCountLabel: UILabel!
    @IBOutlet weak var folderAvatarImageView: UIImageView!

    var folder: Folder?

    func setFolder(_ folder: Folder) {
        self.folder = folder

        self.titleLabel.text = folder.title
        self.notesCountLabel.text = "\(folder.getNotesCount()) notes"
        self.folderAvatarImageView.image = UIImage(systemName: folder.imagePath ?? "folder")
    }
}

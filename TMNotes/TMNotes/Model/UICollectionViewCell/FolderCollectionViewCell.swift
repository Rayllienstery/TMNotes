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

    var folder: NotesFolder?

    func setFolder(_ folder: NotesFolder) {
        self.folder = folder

        self.titleLabel.text = folder.title
        self.notesCountLabel.text = "\(folder.notesCount) notes"
        self.folderAvatarImageView.image = UIImage(systemName: folder.imagePath ?? "folder")
    }
}

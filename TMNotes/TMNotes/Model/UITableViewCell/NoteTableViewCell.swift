//
//  NoteTableViewCell.swift
//  TMNotes
//
//  Created by Raylee on 10.03.2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var spacerConstraint: NSLayoutConstraint!

    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var pinnedImageView: UIImageView!
    var note: Note?

    override func prepareForReuse() {
        note = nil
    }

    func setNote(_ note: Note) {
        self.note = note

        self.titleLabel.text = note.title ?? ""
        self.subtitleLabel.text = note.content ?? ""

        self.pinnedImageView.isHidden = !note.pinned
        self.starImageView.isHidden = !note.starred

        self.spacerConstraint.constant = (
            (titleLabel.text?.count ?? 0) == 0 ||
            (subtitleLabel.text?.count ?? 0) == 0) ? 0 : 6
    }
}

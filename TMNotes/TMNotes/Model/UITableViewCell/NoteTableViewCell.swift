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
    var note: Note?

    override func prepareForReuse() {
        note = nil
    }

    func setNote(_ note: Note) {
        self.note = note

        self.titleLabel.text = note.title ?? ""
        self.subtitleLabel.text = note.content ?? ""
    }
}

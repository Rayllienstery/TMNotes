//
//  TagTableViewCell.swift
//  TMNotes
//
//  Created by Raylee on 21.03.2021.
//

import UIKit

class TagTableViewCell: UITableViewCell {
    @IBOutlet weak var tagTitleLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    var deleteClosure: (() -> Void)?

    override func prepareForReuse() {
        removeButton.isHidden = true
        deleteClosure = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if !self.removeButton.isHidden, selected {
            deleteClosure?()
        }
        UIView.animate(withDuration: 0.17) {
            self.removeButton.isHidden = !selected
        }
    }
}

//
//  Folder.swift
//  TMNotes
//
//  Created by Raylee on 03.04.2021.
//

import UIKit
import CoreData

extension Folder {
    func getNotesCount() -> Int {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return 0 }
        let request: NSFetchRequest<Note> = Note.fetchRequest()

        switch self.title {
        case "Starred":
            request.predicate = NSPredicate(format: "starred == %d", true)
        case "Trash":
            request.predicate = NSPredicate(format: "trashed == %d", true)
        default:
            return 0
        }
        return (try? context.fetch(request).count) ?? 0
    }
}

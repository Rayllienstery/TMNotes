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
            guard let notes = notes else { return 0 }
            let parsedNotes = (try? JSONSerialization.jsonObject(with: notes, options: [])) as? [Int64]
            let count = parsedNotes?.count ?? 0
            return count
        }
        return (try? context.fetch(request).count) ?? 0
    }

    func add(note: Note) {
        if self.notes == nil {
            guard let noteIdToData = try? JSONSerialization.data(withJSONObject: [note.id], options: []) else { return }
            notes = noteIdToData
        } else {
            guard var notesList = (try?
                                    JSONSerialization.jsonObject(with: notes!, options: [])) as? [Int64] else { return }
            if !notesList.contains(note.id) {
                notesList.append(note.id)
                guard let noteIdToData = try? JSONSerialization.data(withJSONObject: notesList, options: []) else { return }
                self.notes = noteIdToData
            }
        }
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        do {
            try context?.save()
        } catch {
            print(error)
        }

        NotificationCenter.default.post(name: .foldersUpdated, object: nil)
    }
}

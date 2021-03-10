//
//  NotesProvider.swift
//  TMNotes
//
//  Created by Raylee on 06.03.2021.
//

import UIKit
import CoreData

enum NotesProviderValues: String {
    case latestNoteId = "LatestNoteId"
}

class NotesProvider {
    public static let shared = NotesProvider()

    func getNotes() -> [Note]? {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return nil }
        return try? context.fetch(Note.fetchRequest()).filter({$0.trashed == false})
    }

    func addNote(title: String, content: String? = "") {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        let note = Note(context: context)
        note.title = title
        note.content = content
        note.id = Int64(updateLatestIdWithGet())
        self.sync(context)
    }

    func updateLatestIdWithGet() -> Int {
        var noteId = UserDefaults.standard.integer(forKey: NotesProviderValues.latestNoteId.rawValue)
        noteId += 1
        UserDefaults.standard.setValue(noteId, forKey: NotesProviderValues.latestNoteId.rawValue)
        return noteId
    }

    func sync(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }

    func markAsTrashed(_ note: Note, completion: @escaping () -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        note.trashed = true
        sync(context)
        completion()
    }

    func markAsPinned(_ note: Note, completion: @escaping () -> Void) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        note.pinned = !note.pinned
        sync(context)
        completion()
    }
}

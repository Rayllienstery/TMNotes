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
        return try? context.fetch(Note.fetchRequest())
    }

    func addNote(title: String, content: String? = "") {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext else { return }
        let note = Note(context: context)
        note.title = title
        note.content = content
        note.id = Int64(updateLatestIdWithGet())
        self.save(context)
    }

    func updateLatestIdWithGet() -> Int {
        var id = UserDefaults.standard.integer(forKey: NotesProviderValues.latestNoteId.rawValue) 
        id += 1
        UserDefaults.standard.setValue(id, forKey: NotesProviderValues.latestNoteId.rawValue)
        return id
    }

    func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

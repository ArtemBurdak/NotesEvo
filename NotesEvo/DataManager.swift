//
//  DataManager.swift
//  NotesEvo
//
//  Created by Artem on 5/12/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import CoreData

class DataManager {

    static var sharedInstance: DataManager {
        return DataManager()
    }

    func getNotes(_ searchText: String? = nil) -> [Note] {

        let request: NSFetchRequest<Note> = Note.fetchRequest()
        if let text = searchText {
            request.predicate = NSPredicate(format: "text CONTAINS[c] %@", text)
            request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        }

        var notes = [Note]()

        do {
            notes = try Constants.context.fetch(request)
        } catch {
            print("Loading error \(error.localizedDescription)")
        }

        return notes
    }

    func removeNote(_ note: Note) {
        Constants.context.delete(note)
        saveNotes()
    }
    
    func saveNotes() {
        do {
            try Constants.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


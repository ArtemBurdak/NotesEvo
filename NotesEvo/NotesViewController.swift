//
//  ViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!

    var notes = [Note]()

    private let dataManager = DataManager.sharedInstance

//    private let contextManager = ContextManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
//        notes = dataManager.getNotes()
        getNotes()
        tableView.tableFooterView = UIView()
    }

    @IBAction func AddNote(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateNewNoteViewController") as! CreateNewNoteViewController
        vc.callback = { [weak self] in
//            guard let wself = self else { return }
//            wself.notes = wself.dataManager.getNotes()
//            wself.tableView.reloadData()
            self?.getNotes()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func getNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()) {

        do {
            notes = try Constants.context.fetch(request)
        } catch {
            print("Loading error \(error)")
        }
        tableView.reloadData()
    }

}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)

        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.textLabel?.numberOfLines = 2

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetailsViewController") as! NoteDetailsViewController
        let note = notes[indexPath.row]
        vc.passedNote = note.text ?? "Empty note"
        vc.callback = { [weak self] in
            if Constants.context.hasChanges {
                self?.notes.remove(at: indexPath.row)
            }
            self?.getNotes()
        }

        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Constants.context.delete(notes[indexPath.row])
            notes.remove(at: indexPath.row)

            dataManager.saveNote()

            self.tableView.reloadData()
        }
    }
    
}

extension NotesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.returnKeyType = UIReturnKeyType.done
        if searchBar.text?.count == 0 {
            getNotes()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            let request : NSFetchRequest<Note> = Note.fetchRequest()
            request.predicate = NSPredicate(format: "text CONTAINS[c] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]

            getNotes(with: request)
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)

        getNotes()
    }
}

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
        notes = dataManager.getNotes()
//        getNotes()
        tableView.tableFooterView = UIView()
    }

    @IBAction func AddNote(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateNewNoteViewController") as! CreateNewNoteViewController
        vc.callback = { [weak self] in
            guard let wself = self else { return }
            wself.notes = wself.dataManager.getNotes()
            wself.tableView.reloadData()
//            self?.getNotes()
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

//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.searchBar.frame.origin.y == 562 {
//                self.searchBar.frame.origin.y -= keyboardSize.height - 50
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.searchBar.frame.origin.y != 562 {
//            self.searchBar.frame.origin.y = 562
//        }
//    }

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

        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Constants.context.delete(notes[indexPath.row])
            notes.remove(at: indexPath.row)

//            let note = notes[indexPath.row]

            dataManager.saveNote()

            self.tableView.reloadData()
        }
    }
}

extension NotesViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Note> = Note.fetchRequest()

        request.predicate = NSPredicate(format: "text CONTAINS[c] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]

        getNotes(with: request)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getNotes()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)

        getNotes()
    }

//    func updateSearchResults(for searchController: UISearchController) {
//        searchController.searchResultsUpdater = self
//    }

}
//
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

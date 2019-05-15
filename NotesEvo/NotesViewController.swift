//
//  ViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var item: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!

    var notes = [Note]()

    private let dataManager = DataManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        getNotes()
        tableView.tableFooterView = UIView()
    }

    @IBAction func AddNote(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateNewNoteViewController") as! CreateNewNoteViewController
        vc.callback = { [weak self] in
            self?.getNotes()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func sortButtonAction(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "Sorting direction", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { _ in self.sortNotes(true) }))
        alert.addAction(UIAlertAction(title: "Descending", style: .default, handler: { _ in self.sortNotes(false) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    private func getNotes(_ text: String? = nil) {
        notes = dataManager.getNotes(text)
        sortNotes()
    }

    private func sortNotes(_ isAscending: Bool = true) {

        notes.sort(by: { (first, second) -> Bool in
            if let fText = first.text, let sText = second.text {
                return isAscending ? fText < sText : fText > sText
            }
            return false
        })
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
        vc.note = note
        vc.callback = { [weak self] in
            self?.getNotes()
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            dataManager.removeNote(notes[indexPath.row])
            notes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}

extension NotesViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.returnKeyType = UIReturnKeyType.done
        if searchBar.text?.isEmpty ?? true {
            getNotes()
            searchBar.resignFirstResponder()
        } else {

            getNotes(searchBar.text!)
            self.tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false

        getNotes()
    }
}

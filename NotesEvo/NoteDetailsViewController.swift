//
//  NoteDetailsViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController {

    @IBOutlet weak var noteDetailOutlet: UITextView!

    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!

    private let dataManager = DataManager.sharedInstance

    var passedNote = ""

    let notes = [Note]()

    var activity: UIActivityViewController?

    var callback: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        noteDetailOutlet.text = passedNote
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        checkEditButtonState()

    }

    @IBAction func editButtonAction(_ sender: Any) {
        noteDetailOutlet.becomeFirstResponder()
        checkEditButtonState()
        editNote()
    }

    func checkEditButtonState() {
        if noteDetailOutlet.text != passedNote {
            editButtonOutlet.title = "Save"
        }
    }

    func editNote() {
        if noteDetailOutlet.text != passedNote {
        let editedNote = Note(context: Constants.context)
        editedNote.text = noteDetailOutlet.text
        dataManager.saveNote()
        navigationController?.popViewController(animated: true)
        callback?()
        }
    }

    @IBAction func shareButtonAction(_ sender: UIBarButtonItem) {
        guard let sharedNote = noteDetailOutlet.text else { return }
        activity = UIActivityViewController(activityItems: [sharedNote], applicationActivities: nil)
        self.present(activity!, animated: true, completion: nil)
        
    }

}

extension NoteDetailsViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        checkEditButtonState()
    }

}

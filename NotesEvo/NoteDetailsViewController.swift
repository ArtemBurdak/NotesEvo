//
//  NoteDetailsViewController.swift
//  NotesEvo
//
//  Created by Artem on 5/9/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noteDetailOutlet: UITextView!

    var passedNote: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        noteDetailOutlet.text = passedNote

    }


}

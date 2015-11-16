//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by 小林和宏 on 11/15/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class NoteDisplayViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        displayNote(note)
    }
    
    //MARK: Business Logic
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView {
            titleTextField.text = note.title
            contentTextView.text = note.content
        }
    }

}

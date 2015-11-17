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
import ConvenienceKit


class NoteDisplayViewController: UIViewController {
    

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    var edit: Bool = false
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        displayNote(note)
        
        titleTextField.returnKeyType = .Next
        titleTextField.delegate = self
        
        keyboardNotificationHandler = KeyboardNotificationHandler()
        
        keyboardNotificationHandler!.keyboardWillBeHiddenHandler = { (height: CGFloat) in UIView.animateWithDuration(0.3){
                self.toolbarBottomSpace.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        keyboardNotificationHandler!.keyboardWillBeShownHandler = { (height: CGFloat) in UIView.animateWithDuration(0.3){
            //FIXME
                self.toolbarBottomSpace.constant = -height
                self.view.layoutIfNeeded()
            }
        }
        
        if edit {
            deleteButton.enabled = false
        }
    }
    
    //MARK: Business Logic
    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if note.title.characters.count == 0 && note.content.characters.count == 0 {
                titleTextField.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    func saveNote(){
        if let note = note {
            do {
                let realm = try Realm()
                
                try realm.write {
                    if (note.title != self.titleTextField.text || note.content != self.contentTextView.text) {
                        note.title = self.titleTextField.text!
                        note.modificationDate = NSDate()
                    }
                }
            } catch {
                print("handle error")
            }
            }
    }
    
}

extension NoteDisplayViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == titleTextField) {
            contentTextView.returnKeyType = .Done
            contentTextView.becomeFirstResponder()
        }
        
        return false
    }
}

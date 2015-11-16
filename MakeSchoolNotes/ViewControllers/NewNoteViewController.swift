//
//  NewNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by 小林和宏 on 11/12/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    var currentNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ShowNewNote") {
            // create a new Note and hold onto it, to be able to save it later
            currentNote = Note()
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController
            noteViewController.note = currentNote
        }
/*
        currentNote = Note()
        currentNote!.title = "Super Simple Test Note"
        currentNote!.content = "Yet more content"
 */       
        

    }

}

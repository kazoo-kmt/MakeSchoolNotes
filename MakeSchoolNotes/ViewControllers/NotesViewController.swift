//
//  NotesViewController.swift
//  MakeSchoolNotes
//
//  Created by Martin Walsh on 29/05/2015.
//  Updated by Chris Orcutt on 09/07/2015.
//  Copyright © 2015 MakeSchool. All rights reserved.
//

import RealmSwift
import UIKit

class NotesViewController: UITableViewController {
    
    var notes: Results<Note>! {
        didSet {
            //Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    
    // Do any additional setup after loading the view, typically from a nib.
    let myNote = Note()
    myNote.title = "Super Simple Test Note"
    myNote.content = "A long piece of content"
    
    do {
        let realm = try Realm()
        try realm.write() {
            realm.add(myNote)
        }
      // 1
      notes = realm.objects(Note)
    } catch {
        print("handle error")
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            print("Identifier \(identifier)")
        }
    }

  
}

extension NotesViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath:
                indexPath) as! NoteTableViewCell //1
            /*
            cell.titleLabel.text = "Hello"
            cell.dateLabel.text = "Today"
            */
            let row = indexPath.row
            let note = notes[row] as Note
            cell.note = note
            
            return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
  }

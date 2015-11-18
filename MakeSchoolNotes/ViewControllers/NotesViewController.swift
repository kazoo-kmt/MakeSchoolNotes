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

class NotesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    // FIXME: Search doesn't work....Need to check...
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                do {
                    let realm = try Realm()
                    notes = realm.objects(Note).sorted("modificationDate", ascending: false)
                    self.navigationController!.setNavigationBarHidden(false, animated: true)
                    searchBar.resignFirstResponder()
                    searchBar.text = ""
                    searchBar.showsCancelButton = false
                } catch {
                    print("realm error")
                }
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                searchBar.setShowsCancelButton(true, animated: true)
                notes = searchNotes(searchText)
                self.navigationController!.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    

    var selectedNote: Note?
    var notes: Results<Note>! {
        didSet {
            //Whenever notes update, update the table view
            tableView?.reloadData()
        }
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    do {
        let realm = try Realm()
        notes = realm.objects(Note).sorted("modificationDate", ascending: false)
        state = .DefaultMode
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
           do {
                let realm = try Realm()
            
                switch identifier {
                    
                case "Save":
                    let source = segue.sourceViewController as! NewNoteViewController
                    try realm.write() {
                        realm.add(source.currentNote!)
                    }
                case "Delete":
                    try realm.write() {
                        realm.delete(self.selectedNote!)
                    }
                    
                    let source = segue.sourceViewController as! NoteDisplayViewController
                    source.note = nil;
                        
                default:
                    print("No one loves \(identifier)")
                        
                }
                    
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
              } catch {
                print("handle error")
              }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowExistingNote") {
            let noteViewController = segue.destinationViewController as! NoteDisplayViewController
            noteViewController.note = selectedNote
        }
    }
    
    func searchNotes(searchString: String) -> Results<Note>? {
        do {
            let realm = try Realm()
            let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@ OR content CONTAINS[c] %a", searchString, searchString)
            return realm.objects(Note).filter(searchPredicate)
        } catch {
            print("realm error")
            return nil
        }
    }
    
}

//extension NotesViewController: {
extension NotesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath:
                indexPath) as! NoteTableViewCell //1
            let row = indexPath.row
            let note = notes[row] as Note
            cell.note = note
            
            return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
  }

//extension NotesViewController: {
extension NotesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedNote = notes[indexPath.row]
        
        self.performSegueWithIdentifier("ShowExistingNote", sender: self)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let note = notes[indexPath.row] as Object
            
            do {
                let realm = try Realm()
                try realm.write() {
                    realm.delete(note)
                }
                
                notes = realm.objects(Note).sorted("modificationDate", ascending: false)
            } catch {
                print("handle error")
            }
            
        }
    }
}

extension NotesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        notes = searchNotes(searchText)
    }
}

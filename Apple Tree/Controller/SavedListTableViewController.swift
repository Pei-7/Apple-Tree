//
//  SavedListTableViewController.swift
//  Apple Tree
//
//  Created by 陳佩琪 on 2023/9/26.
//

import UIKit

class SavedListTableViewController: UITableViewController {
    
    var vocab = Vocabulary()
    var savedWords: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        savedWords = Vocabulary.loadSavedWords()
        savedWords = savedWords?.sorted(by: { word1, word2 in
            return word1.localizedStandardCompare(word2) == .orderedAscending
        })
        if let savedWords {
            Vocabulary.saveWords(savedWords)
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let savedWords {
            return savedWords.count
        } else {
            return 0
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabTableViewCell", for: indexPath) as! VocabTableViewCell
        if let savedWords {
            cell.vocabLabel.text = savedWords[indexPath.row]
        }
        return cell
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        savedWords?.remove(at: indexPath.row)
        if let savedWords {
            Vocabulary.saveWords(savedWords)
        }
        tableView.reloadData()
        
    }
    
    @IBAction func removeAll(_ sender: Any) {
        savedWords?.removeAll()
        Vocabulary.saveWords([])
        tableView.reloadData()
        
    }
    
    @IBSegueAction func showSavedVocab(_ coder: NSCoder) -> DetailViewController? {
        let controller = DetailViewController(coder: coder)
        
        if let savedWords, let indexPath = tableView.indexPathForSelectedRow {
            controller?.wordEng = savedWords[indexPath.row]
        }
        
        return controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedWords = Vocabulary.loadSavedWords()
        tableView.reloadData()
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  VocabTableViewController.swift
//  Apple Tree
//
//  Created by 陳佩琪 on 2023/9/26.
//

import UIKit

class VocabTableViewController: UITableViewController {
    
    var vocab = Vocabulary()
    var alphabetArray = [String()]
    var vocabularyArray = [Vocabulary()]
    
    var savedList : [Vocabulary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        let alphabetString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        alphabetArray = alphabetString.map{String($0)}
        
        savedList = vocab.loadSavedList()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        savedList = vocab.loadSavedList()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print("numberOfSections",alphabetArray.count)
        return alphabetArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alphabetArray[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        alphabetArray.compactMap { $0.capitalized }
    }

    fileprivate func updateSelectedAlphabetArray(_ section: Int) {
        // #warning Incomplete implementation, return the number of rows
        let selectedAlphabet = [alphabetArray[section]]
        vocabularyArray = vocab.getData(alphabetArray: selectedAlphabet)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateSelectedAlphabetArray(section)
        //print(alphabetArray[section],vocabularyArray.count)
        return vocabularyArray.count

    }

    
    fileprivate func changeStarButtonImage(_ index: Int, _ button: UIButton, addNew: Bool) {
        if let savedList {
            if savedList.contains(where: {$0 == vocabularyArray[index]}) == addNew {
                button.setImage(UIImage(systemName: "bookmark"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabTableViewCell", for: indexPath) as! VocabTableViewCell

        // Configure the cell...
        updateSelectedAlphabetArray(indexPath.section)
        
        cell.vocabLabel.text = vocabularyArray[indexPath.row].wordEng
        changeStarButtonImage(indexPath.row, cell.starButton,addNew: false)
        
        cell.starButton.addAction(UIAction(handler: { _ in
            print("button tapped",indexPath.section,indexPath.row)
            self.saveToList(section: indexPath.section, row: indexPath.row)
            self.changeStarButtonImage(indexPath.row, cell.starButton,addNew: true)
            
        }), for: .touchUpInside)

        return cell
    }
    
    @IBSegueAction func showVocabDetail(_ coder: NSCoder) -> DetailViewController? {
        let controller = DetailViewController(coder: coder)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            controller?.alphabetIndex = selectedIndexPath.section
            controller?.vocabIndex = selectedIndexPath.row
        }
        
        return controller
    }

    func saveToList(section: Int, row: Int) {
        updateSelectedAlphabetArray(section)
        print("11111",vocabularyArray[row])
        savedList = vocab.loadSavedList()
        if var savedList {
            if savedList.contains(where: {$0 == vocabularyArray[row]}) == false {
                savedList.append(vocabularyArray[row])
                print(savedList)
            } else {
                if let index = savedList.firstIndex(where: {$0 == vocabularyArray[row]}){
                    savedList.remove(at: index)
                }
            }
            vocab.saveList(savedList)
        }
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

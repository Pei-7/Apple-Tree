//
//  VocabTableViewController.swift
//  Apple Tree
//
//  Created by 陳佩琪 on 2023/9/26.
//

import UIKit

class VocabTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filteredAlphabetIndex: Int?
    
    func updateSearchResults(for searchController: UISearchController) {

        filteredList = []
        alphabetArray = alphabetString.map{String($0)}
        
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                let alphabet = String(searchText.prefix(1))
                
                filteredAlphabetIndex = alphabetArray.firstIndex(where: { $0 == alphabet})
                
                alphabetArray = [alphabet]
                vocabularyArray = vocab.getData(alphabetArray: [alphabet])
                
                filteredList = vocabularyArray.filter({ vocab in
                    if let word = vocab.wordEng {
                        return word.localizedStandardContains(searchText)
                    } else {
                        return false
                    }
                })
                
            } else {
                alphabetArray = alphabetString.map{String($0)}
                
            }
            tableView.reloadData()
        }
    }
    
    let alphabetString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var vocab = Vocabulary()
    var alphabetArray = [String()]
    var vocabularyArray = [Vocabulary()]
    
    var savedList : [Vocabulary]?
    
    var filteredList: [Vocabulary]?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        alphabetArray = alphabetString.map{String($0)}
        

        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
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
        if filteredList?.isEmpty == false {
            return 1
        } else {
            return alphabetArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if filteredList?.isEmpty == false {
            return nil
        } else {
            return alphabetArray[section]
        }
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if filteredList?.isEmpty == false {
            return nil
        } else {
            return alphabetArray.compactMap { $0.capitalized }
        }
    }

    fileprivate func updateSelectedAlphabetArray(_ section: Int) {
        // #warning Incomplete implementation, return the number of rows
        let selectedAlphabet = [alphabetArray[section]]
        vocabularyArray = vocab.getData(alphabetArray: selectedAlphabet)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredList, filteredList.isEmpty == false {
                return filteredList.count
        } else {
            updateSelectedAlphabetArray(section)
            return vocabularyArray.count
        }

    }

    
    fileprivate func changeStarButtonImage(_ index: Int, _ button: UIButton) {
        if filteredList?.isEmpty == false {

            if savedList?.contains(where: {$0 == filteredList?[index]}) == true {
                button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }

        } else {
            if savedList?.contains(where: {$0 == vocabularyArray[index]}) == true {
                button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabTableViewCell", for: indexPath) as! VocabTableViewCell

        // Configure the cell...
        
        if let filteredList, filteredList.isEmpty == false {
            cell.vocabLabel.text = filteredList[indexPath.row].wordEng
            changeStarButtonImage(indexPath.row, cell.starButton)
        } else {
            updateSelectedAlphabetArray(indexPath.section)
            cell.vocabLabel.text = vocabularyArray[indexPath.row].wordEng
            changeStarButtonImage(indexPath.row, cell.starButton)
        }

        return cell
    }
    
    @IBSegueAction func showVocabDetail(_ coder: NSCoder) -> DetailViewController? {
        let controller = DetailViewController(coder: coder)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
        if filteredList?.isEmpty == false {
            controller?.alphabetIndex = filteredAlphabetIndex
            
            let vocab = filteredList?[selectedIndexPath.row]
            let index = vocabularyArray.firstIndex (where: {$0 == vocab})
            controller?.vocabIndex = index
            
        } else {
                controller?.alphabetIndex = selectedIndexPath.section
                controller?.vocabIndex = selectedIndexPath.row
            }
        }
        
        return controller
    }
    
    @IBAction func showSavedList(_ sender: Any) {
        if let savedList {
            vocab.saveList(savedList)
        }
        performSegue(withIdentifier: "showSavedListSegue", sender: nil)
        
    }
    
    @IBAction func markedSave(_ sender: UIButton) {
        savedList = vocab.loadSavedList()
        let button = sender as? UIButton
        if let point: CGPoint = button?.convert(.zero, to: tableView), let indexPath = tableView.indexPathForRow(at: point){
            let section = indexPath.section
            let row = indexPath.row
            
            print("99999",row,filteredList?[row].wordEng,savedList?.contains(where: {$0 == filteredList?[row]}))
            
            if filteredList?.isEmpty == false {
                if savedList?.contains(where: {$0 == filteredList?[row]}) == false {
                    if let filteredList {
                        savedList?.append((filteredList[row]))
                    }
                } else {
                    if let index = savedList?.firstIndex(where: {$0 == filteredList?[row]}){
                        savedList?.remove(at: index)
                    }
                }

            } else {
                updateSelectedAlphabetArray(section)
                if savedList?.contains(where: {$0 == vocabularyArray[row]}) == false {
                    savedList?.append(vocabularyArray[row])
                } else {
                    if let index = savedList?.firstIndex(where: {$0 == vocabularyArray[row]}){
                        savedList?.remove(at: index)
                    }
                }
            }
            
            changeStarButtonImage(row, button!)
            vocab.saveList(savedList!)
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

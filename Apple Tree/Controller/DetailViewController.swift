//
//  DetailViewController.swift
//  Apple Tree
//
//  Created by 陳佩琪 on 2023/9/26.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    var alphabetIndex: Int?
    var vocabIndex: Int?
    var savedIndex: Int?
    
    @IBOutlet var wordEngLabel: UILabel!
    @IBOutlet var wordChiLabel: UILabel!
    @IBOutlet var sentenceEngLabel: UILabel!
    @IBOutlet var sentenceChiLabel: UILabel!
    
    var alphabetArray: [String] = []
    var selectedAlphabet: [String] = []
    var vocabularyArray: [Vocabulary] = []
    var savedList: [Vocabulary]?

    var speaker = AVSpeechSynthesizer()
    
    @IBOutlet var switchPageButtons: [UIButton]!
    
    var wordEng: String!
    let vocab = Vocabulary()
    var savedWords: [String]?
    @IBOutlet var savedButton: UIBarButtonItem!
    
    fileprivate func updateVocab(index: Int) {

        wordEngLabel.text = vocabularyArray[index].wordEng
        wordChiLabel.text = vocabularyArray[index].wordChi
        sentenceEngLabel.text = vocabularyArray[index].sentenceEng
        sentenceChiLabel.text = vocabularyArray[index].sentenceChi
        
        wordEng = vocabularyArray[index].wordEng
        
        if let savedWords {
            if !savedWords.contains(wordEng) {
                savedButton.image = UIImage(systemName: "bookmark")
            } else {
                savedButton.image = UIImage(systemName: "bookmark.fill")
            }
        }
    }
    
    fileprivate func updateAlphabet() {
        
        if let alphabetIndex {
            selectedAlphabet = [alphabetArray[alphabetIndex]]
        }
        let vocab = Vocabulary()
        vocabularyArray = vocab.getData(alphabetArray: selectedAlphabet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let alphabetString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        alphabetArray = alphabetString.map{String($0)}
        
        savedWords = vocab.loadSavedWords()

        if let vocabIndex {
            updateAlphabet()
            updateVocab(index: vocabIndex)
            for button in switchPageButtons {
                button.isHidden = false
            }
        } else {
            let firstAlphabet = wordEng.prefix(1).uppercased()
            if let alphabetIndex = alphabetArray.firstIndex(where: { $0 == firstAlphabet}) {
                vocabularyArray = vocab.getData(alphabetArray: [alphabetArray[alphabetIndex]])
                if let vocabIndex = vocabularyArray.firstIndex(where: { $0.wordEng == wordEng}) {
                    updateVocab(index: vocabIndex)
                }
            }
            for button in switchPageButtons {
                button.isHidden = true
            }
        }
        
    }
    
    
    @IBAction func pronounce(_ sender: Any) {
        
        if let string = wordEngLabel.text {
            let utternce = AVSpeechUtterance(string: string)
            utternce.voice = AVSpeechSynthesisVoice(language: "en_US")
            speaker.speak(utternce)
        }
        
        
    }
    
    @IBAction func switchVocabulary(_ sender: UIButton) {
        
            switch sender.tag {
            case 0:
                if vocabIndex != 0 {
                    vocabIndex! -= 1
                    updateVocab(index: vocabIndex!)
                } else {
                    alphabetIndex! -= 1
                    updateAlphabet()
                    vocabIndex = vocabularyArray.count-1
                    updateVocab(index: vocabIndex!)
                }
                
            case 1:
                if vocabIndex != vocabularyArray.count - 1 {
                    vocabIndex! += 1
                    updateVocab(index: vocabIndex!)
                } else {
                    alphabetIndex! += 1
                    updateAlphabet()

                    vocabIndex = 0
                    updateVocab(index: vocabIndex!)
                }
                
            default:
                break
            }
    }
    
    @IBAction func saveVocab(_ sender: UIBarButtonItem) {


        if var savedWords = savedWords {
            if !savedWords.contains(wordEng) {
                savedWords.append(wordEng)
                vocab.saveWords(savedWords)
                sender.image = UIImage(systemName: "bookmark.fill")
                
            } else {
                if let index = savedWords.firstIndex (where:{ $0 == wordEng }) {
                    savedWords.remove(at: index)
                    vocab.saveWords(savedWords)
                }
                sender.image = UIImage(systemName: "bookmark")
            }
        }
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

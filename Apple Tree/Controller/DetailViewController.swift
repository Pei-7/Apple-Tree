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
    
    
    fileprivate func updateVocab(array: [Vocabulary],index: Int) {

        wordEngLabel.text = array[index].wordEng
        wordChiLabel.text = array[index].wordChi
        sentenceEngLabel.text = array[index].sentenceEng
        sentenceChiLabel.text = array[index].sentenceChi
        
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
        
        let vocab = Vocabulary()
        savedList = vocab.loadSavedList()

        
        if let vocabIndex {
            updateAlphabet()
            updateVocab(array: vocabularyArray, index: vocabIndex)
            for button in switchPageButtons {
                button.isHidden = false
            }
        } else if let savedList, let savedIndex {
            updateVocab(array: savedList, index: savedIndex)
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
                    updateVocab(array: vocabularyArray, index: vocabIndex!)
                } else {
                    alphabetIndex! -= 1
                    updateAlphabet()
                    vocabIndex = vocabularyArray.count-1
                    updateVocab(array: vocabularyArray, index: vocabIndex!)
                }
                
            case 1:
                if vocabIndex != vocabularyArray.count - 1 {
                    vocabIndex! += 1
                    updateVocab(array: vocabularyArray, index: vocabIndex!)
                } else {
                    alphabetIndex! += 1
                    updateAlphabet()

                    vocabIndex = 0
                    updateVocab(array: vocabularyArray, index: vocabIndex!)
                }
                
            default:
                break
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

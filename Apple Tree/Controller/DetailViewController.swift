//
//  DetailViewController.swift
//  Apple Tree
//
//  Created by 陳佩琪 on 2023/9/26.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    var alphabetIndex: Int!
    var vocabIndex: Int!
    
    @IBOutlet var wordEngLabel: UILabel!
    
    @IBOutlet var wordChiLabel: UILabel!
    
    @IBOutlet var sentenceEngLabel: UILabel!
    
    @IBOutlet var sentenceChiLabel: UILabel!
    
    var alphabetArray: [String] = []
    var selectedAlphabet: [String] = []
    var vocabularyArray: [Vocabulary] = []

    var speaker = AVSpeechSynthesizer()
    
    
    fileprivate func updateVocab() {
        wordEngLabel.text = vocabularyArray[vocabIndex].wordEng
        wordChiLabel.text = vocabularyArray[vocabIndex].wordChi
        sentenceEngLabel.text = vocabularyArray[vocabIndex].sentenceEng
        sentenceChiLabel.text = vocabularyArray[vocabIndex].sentenceChi
    }
    
    fileprivate func updateAlphabet() {
        selectedAlphabet = [alphabetArray[alphabetIndex]]
        
        let vocab = Vocabulary()
        vocabularyArray = vocab.getData(alphabetArray: selectedAlphabet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let alphabetString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        alphabetArray = alphabetString.map{String($0)}
        
        updateAlphabet()
        updateVocab()
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
                vocabIndex -= 1
                updateVocab()
            } else {
                alphabetIndex -= 1
                updateAlphabet()
                
                vocabIndex = vocabularyArray.count-1
                updateVocab()
            }
            
        case 1:
            if vocabIndex != vocabularyArray.count - 1 {
                vocabIndex += 1
                updateVocab()
            } else {
                alphabetIndex += 1
                updateAlphabet()
                
                vocabIndex = 0
                updateVocab()
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

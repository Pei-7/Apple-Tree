//
//  GameViewController.swift
//  Apple Tree
//
//  Created by 陳佩琪 on 2023/9/26.
//

import UIKit

class GameViewController: UIViewController {


    @IBOutlet var keyboardButtons: [UIButton]!
    
    var questionBank : [String] = []
    var questionWord = String()
    var questionArray : [String] = []
    var answerArray : [String] = []
    @IBOutlet var wordsView: UIView!
    var labelArray: [UILabel] = []
    var charIndexArray: [Int] = []
    
    let answerStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    @IBOutlet var treeView: UIView!
    var appleArray: [UIImageView] = []
    var oldYConstraint:[NSLayoutConstraint] = []
    var newYConstraint:[NSLayoutConstraint] = []
    
    var wrongCount = 0 {
        didSet{
            dropApple()
        }
    }
    var wrongBool = true
    @IBOutlet var resultLabel: UILabel!
    
    var bestRecord: Int?
    
    @IBOutlet var lastRecordLabel: UILabel!
    
    fileprivate func setUpKeyboard() {
        let keyboardString = "QWERTYUIOPASDFGHJKLZXCVBNM"
        let keyboardArray = keyboardString.map { String($0) }
        for (i,button) in keyboardButtons.enumerated() {
            button.setTitle(keyboardArray[i], for: .normal)
            
            button.configuration?.contentInsets = .zero
            button.layer.cornerRadius = button.frame.height/2
            button.clipsToBounds = true
            button.addAction(UIAction(handler: { _ in
                if let char = button.titleLabel?.text?.lowercased() {
                    self.answerArray.append(char)
                    self.checkAnswerChar()
                }
                button.isEnabled = false
            }), for: .touchUpInside)
        }
    }
    
    fileprivate func setUpButtons() {
        wordsView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.centerXAnchor.constraint(equalTo: wordsView.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: wordsView.centerYAnchor, constant: 0)
        ])
        
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 40
        
        let definitionButton = UIButton()
        definitionButton.configuration = .filled()
        definitionButton.setTitle("See Definition", for: .normal)
        definitionButton.addAction(UIAction(handler: { _ in
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "\(DetailViewController.self)") as? DetailViewController else {return}
            controller.wordEng = self.questionWord
            self.navigationController?.pushViewController(controller, animated: true)
        }), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(definitionButton)
        
        let playAgainButton = UIButton()
        playAgainButton.configuration = .filled()
        playAgainButton.setTitle("Play Again", for: .normal)
        playAgainButton.addAction(UIAction(handler: { _ in
            self.playAgain()
        }), for: .touchUpInside)
        buttonStackView.addArrangedSubview(playAgainButton)
        
        buttonStackView.isHidden = true
        resultLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getQuestionBank()
        createNewQuestion()
        
        createAnswerBlank()
        setUpKeyboard()
        
        setUpButtons()
        
        createApple()
        loadBestRecord()
        updateBestRecordLabel()
        
        
    }
    
    fileprivate func createNewQuestion() {
        questionWord = questionBank[Int.random(in: 0..<questionBank.count)]
        questionArray = questionWord.map({String($0)})
        print(questionWord,questionArray)
    }
    
    func getQuestionBank() {
        
        let alphabetString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let alphabetArray = alphabetString.map({String($0)})
        
        let vocab = Vocabulary()
        let vocabArray = vocab.getData(alphabetArray: alphabetArray)
        
        for i in 0..<vocabArray.count {
            if let word = vocabArray[i].wordEng {
                questionBank.append(word)
            }
        }
        
        questionBank = questionBank.filter { string in
            !string.contains(" ") && !string.contains("-")
        }
        
        
        
    }
    
    fileprivate func createAnswerLabel() {
        for _ in 1...questionWord.count {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 24)
            label.text = "_"
            labelArray.append(label)
            answerStackView.addArrangedSubview(label)
        }
    }
    
    func createAnswerBlank() {
        
        wordsView.addSubview(answerStackView)
        answerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerStackView.centerXAnchor.constraint(equalTo: wordsView.centerXAnchor),
            answerStackView.bottomAnchor.constraint(equalTo: wordsView.centerYAnchor, constant: -20)
        ])
        
        answerStackView.alignment = .center
        answerStackView.axis = .horizontal
        answerStackView.spacing = 10

        createAnswerLabel()
        
    }
    
    func checkAnswerChar() {
        wrongBool = true
        if let character = answerArray.last {
            for (i,char) in questionArray.enumerated() {
                if char == character {
                    charIndexArray.append(i)
                    wrongBool = false
                    //print("0000")
                } else {
                    //print("1111")
                }
            }
        }

        if wrongBool == true {
            wrongCount += 1
        }
        //print("wrongBool",wrongBool,"wrongCount",wrongCount)
        
        for index in charIndexArray {
            labelArray[index].text = answerArray.last
        }
        charIndexArray.removeAll()
        
        var matchCount = 0
        for label in labelArray {
            if label.text != "_" {
                matchCount += 1
            }
        }
        
        if matchCount == questionArray.count || wrongCount == 7 {
            closeRound()
        }
    
    }
    
    fileprivate func updateBestRecordLabel() {
        var recordString = ""
        if bestRecord! > 0 {
            for _ in 1...bestRecord! {
                recordString += "🍎"
            }
        } else {
            recordString += "🌳"
        }
        lastRecordLabel.text = recordString
    }
    
    func closeRound() {
        for button in keyboardButtons {
            button.isEnabled = false
        }
        buttonStackView.isHidden = false
        resultLabel.isHidden = false
        treeView.bringSubviewToFront(resultLabel)
        
        if wrongCount == 7 {
            for (i,label) in labelArray.enumerated() {
                label.text = questionArray[i]
                label.textColor = .red
                resultLabel.text = "All the apples are rotten!"
            }
        } else {
            resultLabel.text = "Both you and the tree\n are so fruitful!"
        }
        
        let remainingApple = 7 - wrongCount
        print(remainingApple)
        
        if remainingApple > bestRecord! {
            bestRecord = remainingApple
            UserDefaults.standard.set(bestRecord, forKey: "bestRecord")

            updateBestRecordLabel()
        }
    }
    
    func playAgain() {
        for label in labelArray {
            label.removeFromSuperview()
        }
        labelArray.removeAll()
        
        for button in keyboardButtons {
            button.isEnabled = true
        }
        buttonStackView.isHidden = true
        resultLabel.isHidden = true
        
        questionArray.removeAll()
        answerArray.removeAll()
        createNewQuestion()
        createAnswerLabel()
        
        wrongCount = 0
        for apple in appleArray {
            apple.image = UIImage(named: "apple")
        }
        for constraint in newYConstraint {
            constraint.isActive = false
        }
        for constraint in oldYConstraint {
            constraint.isActive = true
        }
        view.layoutIfNeeded()
        
        
    }
    
    func createApple() {
        
        
        var xMultiplier:[CGFloat] = [1.4, 1.06, 0.9, 0.46, 0.86, 0.54, 1.34]
        var yMultiplier:[CGFloat] = [0.54, 1.12, 0.76, 0.6, 0.4, 0.96, 0.9, 0.6]

        
        for i in 0...6 {
            let appleImageView = UIImageView()
            appleImageView.image = UIImage(named: "apple")
            appleArray.append(appleImageView)
            treeView.addSubview(appleImageView)
            
            let constantX = (0.5 - (0.5*xMultiplier[i])) * treeView.frame.width
            let constantY = ((0.5*yMultiplier[i])-0.5) * treeView.frame.height
            
            appleImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                appleImageView.widthAnchor.constraint(equalTo: appleImageView.heightAnchor),
                appleImageView.heightAnchor.constraint(equalTo:treeView.heightAnchor, multiplier: 0.17),
                appleImageView.centerXAnchor.constraint(equalTo: treeView.centerXAnchor, constant: constantX)
            ])
            let yConstraint = appleImageView.centerYAnchor.constraint(equalTo: treeView.centerYAnchor, constant: constantY)
            yConstraint.isActive = true
            oldYConstraint.append(yConstraint)
        }
        //print("0000",appleArray.count,appleYConstraint)
    }
    
    func dropApple() {
        if wrongCount > 0 {
            oldYConstraint[wrongCount-1].isActive = false
            UIView.animate(withDuration: 0.6) {
                let constant = CGFloat.random(in: -8...0)
                let yConstraint = self.appleArray[self.wrongCount-1].bottomAnchor.constraint(equalTo: self.treeView.bottomAnchor, constant: constant)
                yConstraint.isActive = true
                self.newYConstraint.append(yConstraint)
                self.view.layoutIfNeeded()
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.appleArray[self.wrongCount-1].image = UIImage(named: "appleWithShadow")
            }
        }

       
    }

    
    func loadBestRecord() {
        if let record = UserDefaults.standard.value(forKey: "bestRecord") as? Int {
            bestRecord = record
        } else {
            bestRecord = 0
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

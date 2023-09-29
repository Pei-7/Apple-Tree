//
//  Vocabulary.swift
//  Apple Tree
//
//  Created by 陳佩琪 on 2023/9/26.
//

import Foundation

struct Vocabulary: Codable,Equatable {
    var wordEng: String?
    var wordChi: String?
    var sentenceEng: String?
    var sentenceChi: String?
    
    func getData(alphabetArray: [String]) -> [Vocabulary] {
        var allVocabulary: [Vocabulary] = []
//        let alphabetArray = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        for i in 0..<alphabetArray.count{
            if let url = Bundle.main.url(forResource: String(alphabetArray[i]), withExtension: "txt"){
                do {
                    let allData = try String(contentsOf: url)
                    //print(allData)
                    
                    let singleLine = allData.components(separatedBy: "\n")
                    //print(singleLine)
                    
                    for line in singleLine {
                        var vocab = Vocabulary()
                        let item = line.components(separatedBy: "\t")
                        //print("item",item)

                        
                        if item.count >= 4 {
                            vocab.wordEng = formattedString(item[0],0)
                            vocab.wordChi = formattedString(item[1],1)
                            vocab.sentenceEng = formattedString(item[2],2)
                            vocab.sentenceChi = formattedString(item[3],3)
                            //print("vocab",vocab)
                            allVocabulary.append(vocab)
                        }
                        //print(allVocabulary.count,allVocabulary[allVocabulary.count-1])
                    }
                } catch {
                    print(error)
                }
            }
        }
        //print(allVocabulary)
        let index = allVocabulary.count-1
        
        return allVocabulary
    }
    
    func formattedString(_ string: String, _ caseInt: Int) -> String {
        var formattedString = string.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "\r", with: "")

        switch caseInt {
        case 2:
            if !formattedString.contains(".") {
                formattedString += "."
            }
        case 3:
            if !formattedString.contains("。"){
                formattedString += "。"
            }
        default:
            break
        }

        
        return formattedString
    }
    
    
    func saveList(_ vocab: [Vocabulary]) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(vocab)
        let url = URL.documentsDirectory.appending(path: "savedVocab")
        try? data?.write(to: url)
    }
    
    func loadSavedList() -> [Vocabulary]{
        
        let url = URL.documentsDirectory.appendingPathComponent("savedVocab")
        var savedList: [Vocabulary]?
        if let data =  try? Data(contentsOf: url) {
//            print("22222",String(data: data, encoding: .utf8))
            let decoder = JSONDecoder()
            savedList = try? decoder.decode([Vocabulary].self, from: data)
//            print("3333",savedList)
        }
        return savedList ?? []
    }
    
    func saveWords(_ vocab: [String]) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(vocab)
        let url = URL.documentsDirectory.appending(path: "savedWords")
        try? data?.write(to: url)
    }
    
    func loadSavedWords() -> [String]{
        let url = URL.documentsDirectory.appendingPathComponent("savedWords")
        var savedList: [String]?
        if let data =  try? Data(contentsOf: url) {
            print("66666",String(data: data, encoding: .utf8))
            let decoder = JSONDecoder()
            savedList = try? decoder.decode([String].self, from: data)
            print("77777",savedList)
        }
        return savedList ?? []
    }
    
}

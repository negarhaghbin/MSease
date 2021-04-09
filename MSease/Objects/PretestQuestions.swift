//
//  PretestQuestions.swift
//  MSease
//
//  Created by Negar on 2021-04-08.
//

import Foundation

var pretestQuestions : [pretestQuestion] = []

enum Pretest: Int {
    case gender = 0
    case bday
    case MSType
    case diagnosedDate
    case treatmentDate
}

class pretestQuestion{
    var number : Int = 0
    var question : String = ""
    
    convenience init(number: Int, question: String) {
        self.init()
        self.number = number
        self.question = question
    }
    
    class func fillTable(){
        pretestQuestions.append(pretestQuestion(number: 1, question: "What is your gender identity?"))
        
        pretestQuestions.append(pretestQuestion(number: 2, question: "When were you born?"))
        
        pretestQuestions.append(pretestQuestion(number: 3, question: "What type of MS do you have?"))
        
        pretestQuestions.append(pretestQuestion(number: 4, question: "When were you diagnosed with MS?"))
        
        pretestQuestions.append(pretestQuestion(number: 5, question: "When did you start treatment with injectable therapies?"))
    }
}

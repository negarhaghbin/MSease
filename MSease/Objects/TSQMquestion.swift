//
//  TSQMquestion.swift
//  MSease
//
//  Created by Negar on 2021-04-01.
//

import Foundation

var TSQMquestions : [TSQMquestion] = []

struct TSQMquestion{
    var number : Int = 0
    var question : String = ""
    var options : [String] = ["3 Extremely satisfied", "2","1","0","-1","-2", "-3 Extremely dissatisfied"]
    
    func add(){
        TSQMquestions.append(self)
    }
    
    static func fillTable(){
        TSQMquestion(number: 1, question: "How satisfied or dissatisfied are you with the ability of the medication to prevent or treat your condition?", options: ["3 Extremely satisfied", "2","1","0","-1","-2", "-3 Extremely dissatisfied"]).add()
        
        TSQMquestion(number: 2, question: "How satisfied or dissatisfied are you with the way the medication relieves your symptoms?", options: ["3 Extremely satisfied", "2","1","0","-1","-2", "-3 Extremely dissatisfied"]).add()
        
        TSQMquestion(number: 3, question: "How satisfied or dissatisfied are you with the amount of time it takes the medication to start working?", options: ["3 Extremely satisfied", "2","1","0","-1","-2", "-3 Extremely dissatisfied"]).add()
        
        TSQMquestion(number: 4, question: "As a result of taking this medication, do you currently experience any side effects at all?", options: []).add()
        
        TSQMquestion(number: 5, question: "How bothersome are the side effects of the medication you take to treat your condition?", options: ["3 Extremely", "2","1","0","-1","-2", "-3 Not at all"]).add()
        
        TSQMquestion(number: 6, question: "To what extent do the side effects interfere with your physical health and ability to function (i.e., strength, energy levels, etc.)?", options: ["3 Extremely", "2","1","0","-1","-2", "-3 Not at all"]).add()
        
        TSQMquestion(number: 7, question: "To what extent do the side effects interfere with your mental function (i.e., ability to think clearly, stay awake, etc.)?", options: ["3 Extremely", "2","1","0","-1","-2", "-3 Not at all"]).add()
        
        TSQMquestion(number: 8, question: "To what degree have medication side effects affected your overall satisfaction with the medication?", options: ["3 Extremely", "2","1","0","-1","-2", "-3 Not at all"]).add()
        
        TSQMquestion(number: 9, question: "How easy or difficult is it to use the medication in its current form?", options: ["3 Extremely difficult", "2","1","0","-1","-2", "-3 Extremely easy"]).add()
        
        TSQMquestion(number: 10, question: "How easy or difficult is it to plan when you will use the medication each time?", options: ["3 Extremely difficult", "2","1","0","-1","-2", "-3 Extremely easy"]).add()
        
        TSQMquestion(number: 11, question: "How convenient or inconvenient is it to take the medication as instructed?", options: ["3 Extremely convenient", "2","1","0","-1","-2", "-3 Extremely inconvenient"]).add()
        
        TSQMquestion(number: 12, question: "Overall, how confident are you that taking this medication is a good thing for you?", options: ["3 Extremely confident", "2","1","0","-1","-2", "-3 Not confident at all"]).add()
        
        TSQMquestion(number: 13, question: "How certain are you that the good things about your medication outweigh the bad things?", options: ["3 Extremely certain", "2","1","0","-1","-2", "-3 Not certain at all"]).add()
        
        TSQMquestion(number: 14, question: "Taking all things into account, how satisfied or dissatisfied are you with this medication?", options: ["3 Extremely satisfied", "2","1","0","-1","-2", "-3 Extremely dissatisfied"]).add()
    }
}

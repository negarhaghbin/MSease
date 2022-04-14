//
//  InjectionPhobia.swift
//  MSease
//
//  Created by Negar on 2021-04-06.
//

import Foundation

var IPquestions : [IPquestion] = []

struct IPquestion{
    var number : Int = 0
    var question : String = ""
    var options : [String] = ["0 No Anxiety", "1","2","3","4 Max Anxiety"]
    
    static func fillTable(){
        IPquestions.append(IPquestion(number: 1, question: "Giving a blood sample by having a finger pricked."))
        
        IPquestions.append(IPquestion(number: 2, question: "Having a shot in the upper arm."))
        
        IPquestions.append(IPquestion(number: 3, question: "Having an anesthetic injection at the dentist."))
        
        IPquestions.append(IPquestion(number: 4, question: "Having a venipuncture (needle inserted into vein)."))
        
        IPquestions.append(IPquestion(number: 5, question: "Getting an injection in the buttock."))
        
        IPquestions.append(IPquestion(number: 6, question: "Having one’s ears pierced."))
        
        IPquestions.append(IPquestion(number: 7, question: "Getting a vaccination."))
        
        IPquestions.append(IPquestion(number: 8, question: "Getting an intravenous injection."))
    }
}

//
//  Symptom.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

var symptoms : [Symptom] = []
class Symptom{
    var name = ""
    var imageName = ""
    
    convenience init(name: String, imageName: String){
        self.init()
        self.name = name
        self.imageName = imageName
    }
    
    static func fillSymptomsTable(){
        symptoms.append(Symptom(name: "Headache", imageName: "headache"))
        symptoms.append(Symptom(name: "Diarrhea", imageName: "diarrhea"))
        symptoms.append(Symptom(name: "Rash", imageName: "rash"))
        symptoms.append(Symptom(name: "Nausea", imageName: "nausea"))
        symptoms.append(Symptom(name: "Vomit", imageName: "vomit"))
            
        symptoms.append(Symptom(name: "Headache", imageName: "headache"))
        symptoms.append(Symptom(name: "Diarrhea", imageName: "diarrhea"))
        symptoms.append(Symptom(name: "Rash", imageName: "rash"))
        symptoms.append(Symptom(name: "Nausea", imageName: "nausea"))
        symptoms.append(Symptom(name: "Vomit", imageName: "vomit"))
        
    }
    
    static func symptomImage(for name: String)->String{
        for symptom in symptoms{
            if symptom.name == name{
                return symptom.imageName
            }
        }
        return ""
    }
}

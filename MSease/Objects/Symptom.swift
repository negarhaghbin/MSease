//
//  Symptom.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

var symptoms : [Symptom] = []
var reactions : [Symptom] = []
var painScale = ["nopain", "mild", "moderate", "intense", "unspeakable"]

struct Symptom{
    var name = ""
    var imageName = ""
    
    static func fillSymptomsTable(){
        symptoms.append(Symptom(name: "Headache", imageName: "headache"))
        symptoms.append(Symptom(name: "Diarrhea", imageName: "diarrhea"))
        symptoms.append(Symptom(name: "Rash", imageName: "rash"))
        symptoms.append(Symptom(name: "Nausea", imageName: "nausea"))
        symptoms.append(Symptom(name: "Vomit", imageName: "vomit"))
        symptoms.append(Symptom(name: "Chest pain", imageName: "chestPain"))
        symptoms.append(Symptom(name: "Shortness of breath", imageName: "shortness_breath"))
        symptoms.append(Symptom(name: "Flushing", imageName: "flushed"))
    }
    
    static func fillReactionsTable(){
        reactions.append(Symptom(name: "Itching", imageName: "itching"))
        reactions.append(Symptom(name: "Pain", imageName: "pain"))
        reactions.append(Symptom(name: "Redness", imageName: "redness"))
        reactions.append(Symptom(name: "Swelling", imageName: "swelling"))
        reactions.append(Symptom(name: "Bleeding", imageName: "bleeding"))
        reactions.append(Symptom(name: "Rash", imageName: "rash"))
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

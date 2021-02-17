//
//  RealmManager.swift
//  MSease
//
//  Created by Negar on 2021-02-09.
//

import Foundation
import RealmSwift

class RealmManager{
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init() {
    }
    func getSymptoms() -> [Symptom]{
        let symptoms = realm.objects(Symptom.self).sorted(byKeyPath: "name", ascending: true)
        return Array(symptoms)
    }
    
    func addSymptom(newSymptom: Symptom){
        try! realm.write{
            realm.add(newSymptom)
        }
    }
    
    func printPath(){
        let path = realm.configuration.fileURL!.path
        print("Path: \(String(describing: path))")
    }
    
    func fillSymptomsTable(){
        if RealmManager.shared.getSymptoms().count == 0{
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Headache", imageName: "headache"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Diarrhea", imageName: "diarrhea"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Rash", imageName: "rash"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Nausea", imageName: "nausea"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Vomit", imageName: "vomit"))
            
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Headache", imageName: "headache"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Diarrhea", imageName: "diarrhea"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Rash", imageName: "rash"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Nausea", imageName: "nausea"))
            RealmManager.shared.addSymptom(newSymptom: Symptom(name: "Vomit", imageName: "vomit"))
        }
        
    }
    
    func getNoteImages() -> [String]{
        //TODO
        return []
    }
    
    func addNote(newNote: Note){
        try! realm.write{
            realm.add(newNote)
        }
    }
    
    func getNotes(for date: Date) -> [Note]{
        let predicate = NSPredicate(format: "date = %@", date.getUSFormat())
        let result = realm.objects(Note.self).filter(predicate)
        return Array(result)
    }
}

extension RealmManager{
    func addRemidner(newReminder: Reminder){
        try! realm.write{
            realm.add(newReminder)
        }
    }
}

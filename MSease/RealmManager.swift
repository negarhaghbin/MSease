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
}

// MARK: - Note
extension RealmManager{
    func addNote(newNote: Note){
        try! realm.write{
            realm.add(newNote)
        }
    }
    
//    func getNoteImages(noteId: ObjectId) -> [String]{
//        let predicate = NSPredicate(format: "noteId = %@", "\(noteId)")
//        let result = realm.objects(NotePhoto.self).filter(predicate)
//        var imageNames : [String] = []
//        for image in result{
//            imageNames.append(image.name)
//        }
//        return Array(imageNames)
//    }
    
    func getNotes(for date: Date) -> [Note]{
        let predicate = NSPredicate(format: "date = %@", date.getUSFormat())
        let result = realm.objects(Note.self).filter(predicate)
//        var photos : [String] = []
//        for note in result{
//            photos = getNoteImages(noteId: note._id)
//            note.setImages(imageNames: photos)
//        }
        return Array(result)
    }
    
    func haveNotes(for date: Date) -> Bool{
        let predicate = NSPredicate(format: "date beginswith %@", date.getUSFormat())
        let result = realm.objects(Note.self).filter(predicate)
        return result.count == 0 ? false : true
    }
    
    func editNote(newNote: Note){
        let oldNote = realm.object(ofType: Note.self, forPrimaryKey: newNote._id)
        try! realm.write{
            oldNote?.textContent = newNote.textContent
            oldNote?.date = newNote.date
            oldNote?.time = newNote.time
            oldNote?.images = newNote.images
            oldNote?.symptoms.removeAll()
            oldNote?.symptoms.append(objectsIn: newNote.symptoms)
        }
    }
}

// MARK: - Reminder
extension RealmManager{
    func addReminder(newReminder: Reminder){
        try! realm.write{
            realm.add(newReminder)
        }
    }
    
    func getReminders()->[Reminder]{
        let reminders = realm.objects(Reminder.self)
        return Array(reminders)
    }
    
    func editReminder(_ newReminder: Reminder){
        let oldReminder = realm.object(ofType: Reminder.self, forPrimaryKey: newReminder._id)
        try! realm.write{
            oldReminder?.name = newReminder.name
            oldReminder?.mon = newReminder.mon
            oldReminder?.tue = newReminder.tue
            oldReminder?.wed = newReminder.wed
            oldReminder?.thu = newReminder.thu
            oldReminder?.fri = newReminder.fri
            oldReminder?.sat = newReminder.sat
            oldReminder?.sun = newReminder.sun
            oldReminder?.time = newReminder.time
            oldReminder?.message = newReminder.message
        }
    }
    
    func connectToMongoDB(){
        let app = App(id: "mseaseapp-wrhfs")
    }
}

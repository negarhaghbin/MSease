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
    
    private init() {
    }
    
    func printPath(realm: Realm){
        let path = realm.configuration.fileURL!.path
        print("Path: \(String(describing: path))")
    }
    
    func connectToMongoDB()->App{
        return App(id: "mseaseapp-wrhfs")
    }
}


// MARK: - Note
extension RealmManager{
    func addNote(newNote: Note, realm: Realm){
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
    
    func getNotes(for date: Date, realm: Realm) -> Results<Note>{
        let predicate = NSPredicate(format: "date = %@", date.getUSFormat())
        let result = realm.objects(Note.self).filter(predicate)
//        var photos : [String] = []
//        for note in result{
//            photos = getNoteImages(noteId: note._id)
//            note.setImages(imageNames: photos)
//        }
        return result
    }
    
    func haveNotes(for date: Date, realm: Realm) -> Bool{
        let predicate = NSPredicate(format: "date beginswith %@", date.getUSFormat())
        let result = realm.objects(Note.self).filter(predicate)
        return result.count == 0 ? false : true
    }
    
    func editNote(newNote: Note, realm: Realm){
        let oldNote = realm.object(ofType: Note.self, forPrimaryKey: newNote._id)
        try! realm.write{
            oldNote?.textContent = newNote.textContent
            oldNote?.date = newNote.date
            oldNote?.time = newNote.time
            oldNote?.images = newNote.images
            oldNote?.symptomNames.removeAll()
            oldNote?.symptomNames.append(objectsIn: newNote.symptomNames)
        }
    }
    
    func removeNote(note: Note, realm: Realm){
        try! realm.write {
            realm.delete(note)
        }
    }
}

// MARK: - Reminder
extension RealmManager{
    func addReminder(newReminder: Reminder, realm: Realm){
        try! realm.write{
            realm.add(newReminder)
        }
    }
    
    func getReminders(realm: Realm)->[Reminder]{
        let reminders = realm.objects(Reminder.self)
        return Array(reminders)
    }
    
    func editReminder(_ newReminder: Reminder, realm: Realm){
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
    
    func removeReminder(reminder: Reminder, realm: Realm){
        try! realm.write {
            realm.delete(reminder)
        }
    }
    
    func changeReminderState(reminder: Reminder, state: Bool, realm: Realm){
        try! realm.write{
            reminder.isOn = state
        }
    }
    
}

// MARK: - Injection

extension RealmManager{
    func addInjection(newInjection: Injection, realm: Realm){
        try! realm.write{
            realm.add(newInjection)
        }
    }
    
    func getInjectionsForLimb(limb: Limb, realm: Realm)->Results<Injection>{
        let name = limb.name ?? ""
        let result = realm.objects(Injection.self).filter("limbName == '\(name)'")
        return result
    }
}

// MARK: - Login
extension RealmManager{
    
    func hasCredentials() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "email") == nil{
            return false
        }
        else{
            return true
        }
    }
    
    func saveCredentials(email: String, password: String){
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    func removeCredentials(){
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
    }
}

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
    private var realm : Realm?
    let PHASE_DURATION_WEEKS = 4.0
    
    private init() {
    }
    
    func printPath(){
        let path = realm!.configuration.fileURL!.path
        print("Path: \(String(describing: path))")
    }
    
    func connectToMongoDB()->App{
        return App(id: "mseaseapp-wrhfs")
    }
    
    func setRealm(realm: Realm){
        self.realm = realm
    }
    
    func getPartitionValue()->String{
        guard let syncConfiguration = realm?.configuration.syncConfiguration else {
            fatalError("Sync configuration not found! Realm not opened with sync?")
        }

        return syncConfiguration.partitionValue!.stringValue!
    }
}


// MARK: - Note
extension RealmManager{
    func addNote(newNote: Note){
        try! realm!.write{
            realm!.add(newNote)
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
    
    func getNotes(for date: Date) -> Results<Note>{
        let predicate = NSPredicate(format: "date = %@", date.getUSFormat())
        let result = realm!.objects(Note.self).filter(predicate)
//        var photos : [String] = []
//        for note in result{
//            photos = getNoteImages(noteId: note._id)
//            note.setImages(imageNames: photos)
//        }
        return result
    }
    
    func haveNotes(for date: Date) -> Bool{
        let predicate = NSPredicate(format: "date beginswith %@", date.getUSFormat())
        let result = realm!.objects(Note.self).filter(predicate)
        return result.count == 0 ? false : true
    }
    
    func editNote(newNote: Note){
        let oldNote = realm!.object(ofType: Note.self, forPrimaryKey: newNote._id)
        try! realm!.write{
            oldNote?.textContent = newNote.textContent
            oldNote?.date = newNote.date
            oldNote?.time = newNote.time
            oldNote?.images = newNote.images
            oldNote?.symptomNames.removeAll()
            oldNote?.symptomNames.append(objectsIn: newNote.symptomNames)
        }
    }
    
    func removeNote(note: Note){
        try! realm!.write {
            realm!.delete(note)
        }
    }
}

// MARK: - Reminder
extension RealmManager{
    func addReminder(newReminder: Reminder){
        try! realm!.write{
            realm!.add(newReminder)
        }
    }
    
    func getReminders()->Results<Reminder>{
        let reminders = realm!.objects(Reminder.self)
        return reminders
    }
    
    func editReminder(_ newReminder: Reminder){
        let oldReminder = realm!.object(ofType: Reminder.self, forPrimaryKey: newReminder._id)
        try! realm!.write{
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
    
    func removeReminder(reminder: Reminder){
        try! realm!.write {
            realm!.delete(reminder)
        }
    }
    
    func changeReminderState(reminder: Reminder, state: Bool){
        try! realm!.write{
            reminder.isOn = state
        }
    }
    
}

// MARK: - Injection

extension RealmManager{
    func addInjection(newInjection: Injection){
        try! realm!.write{
            realm!.add(newInjection)
        }
    }
    
    func getInjectionsForLimb(limb: Limb)->Results<Injection>{
        let name = limb.name ?? ""
        let result = realm!.objects(Injection.self).filter("limbName == '\(name)'")
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
    
    func hasSignedConsent(realm: Realm) -> Bool {
        let user = realm.objects(User.self).first
        return user?.hasSignedConsent ?? false
    }
    
    func saveCredentials(email: String, password: String){
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    func removeCredentials(){
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    func logOut(vc: UIViewController) {
        let alertController = UIAlertController(title: "Log Out", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Log Out", style: .destructive, handler: {
            _ -> Void in
            app.currentUser?.logOut { (_) in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                    let onboardingVC = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
                    RealmManager.shared.removeCredentials()
                    onboardingVC.walkthroughPageViewController?.currentIndex = walkthroughPages.count - 1
                    vc.navigationController?.setViewControllers([onboardingVC], animated: true)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.present(alertController, animated: true)
    }
    
    func acceptConsent(){
        let user = realm!.objects(User.self).first
        try! realm!.write{
            user?.hasSignedConsent = true
        }
    }
    
    // MARK: - Pretest Questionnaire
    func submitPretestData(answers: [String]){
        let user = realm!.objects(User.self).first
        try! realm!.write{
            user?.gender = answers[0]
            user?.birthday = answers[1]
            user?.typeOfMS = answers[2]
            user?.diagnosisDate = answers[3]
            user?.treatmentBeginningDate = answers[4]
        }
    }
    
}

// MARK: - TSQM
extension RealmManager{
    func submitTSQM(version: Int, answers: [String]){
        if hasTSQM(version: version){
            let tsqm = realm?.objects(TSQM.self).filter("version == \(version)").first
            try! realm!.write{
                tsqm?.q1 = answers[0]
                tsqm?.q2 = answers[1]
                tsqm?.q3 = answers[2]
                tsqm?.q4 = answers[3]
                tsqm?.q5 = answers[4]
                tsqm?.q6 = answers[5]
                tsqm?.q7 = answers[6]
                tsqm?.q8 = answers[7]
                tsqm?.q9 = answers[8]
                tsqm?.q10 = answers[9]
                tsqm?.q11 = answers[10]
                tsqm?.q12 = answers[11]
                tsqm?.q13 = answers[12]
                tsqm?.q14 = answers[13]
            }
        }
        else{
            let tsqm = TSQM(version: version, q1: answers[0], q2: answers[1], q3: answers[2], q4: answers[3], q5: answers[4], q6: answers[5], q7: answers[6], q8: answers[7], q9: answers[8], q10: answers[9], q11: answers[10], q12: answers[11], q13: answers[12], q14: answers[13], partition: getPartitionValue())
            try! realm!.write{
                realm!.add(tsqm)
            }
        }
        
    }
    
    func getTSQM(version: Int)->[String]{
        let tsqms = realm?.objects(TSQM.self).filter("version == \(version)")
        if tsqms?.count == 0{
            return Array(repeating: "Not selected", count: TSQMquestions.count)
        }
        else{
            return (tsqms?.first!.getAnswersFromFields())!
        }
    }
    
    func hasTSQM(version: Int)->Bool{
        let tsqms = realm?.objects(TSQM.self).filter("version == \(version)")
        if tsqms?.count == 0{
            return false
        }
        else{
            return true
        }
    }
    
    func getTSQMDate(of version: Int)->Date{
        let tsqms = realm?.objects(TSQM.self).filter("version == \(version)")
        if tsqms?.count == 0{
            return Date()
        }
        else{
            return getDateFromString((tsqms?.first!.date)!)
        }
    }
    
    func isTSQMLocked(version: Int)->Bool{
        if version == 0{
            return false
        }
        if hasTSQM(version: version) {
            return false
        }
        
        let dateOfLastTSQM = getTSQMDate(of: version-1)
        if timeIntervalToWeeks(timeInterval: (Date() - dateOfLastTSQM) ) < PHASE_DURATION_WEEKS{
            return true
        }
        else{
            return false
        }
    }
}

// MARK: IP
extension RealmManager{
    
    // not editable
    func submitIP(answers: [String]){
        let ip = InjectionPhobiaForm(q1: answers[0], q2: answers[1], q3: answers[2], q4: answers[3], q5: answers[4], q6: answers[5], q7: answers[6], q8: answers[7], partition: getPartitionValue())
            try! realm!.write{
                realm!.add(ip)
            }
    }
    
    func getIP()->[String]{
        let ip = realm?.objects(InjectionPhobiaForm.self)
        if ip?.count == 0{
            return Array(repeating: "Not selected", count: IPquestions.count)
        }
        else{
            return (ip?.first!.getAnswersFromFields())!
        }
    }
}

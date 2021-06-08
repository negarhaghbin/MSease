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
    static let OBJECT_TYPES = [User.self, Reminder.self, Note.self, Injection.self, TSQM.self, InjectionPhobiaForm.self, Step.self, Image.self]
    
    private init() {
    }
    
    func printPath(){
        let path = realm!.configuration.fileURL!.path
        print("Path: \(String(describing: path))")
    }
    
    func connectToMongoDB()->App{
        return App(id: "mseaseapp-wrhfs")
    }
    
    func setRealm(realm: Realm, handler: @escaping()->()){
        self.realm = realm
        print("here")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            handler()
//        }
        
    }
    
    func getPartitionValue()->String{
        guard let syncConfiguration = realm?.configuration.syncConfiguration else {
            fatalError("Sync configuration not found! Realm not opened with sync?")
        }

        return syncConfiguration.partitionValue!.stringValue!
    }
    
    func getUsername() -> String {
        return UserDefaults.standard.string(forKey: "email")!
    }
    
    func getUser()->User{
        return realm!.objects(User.self).first!
    }
    
    func setProfilePicture(profilePictureData: Data){
        let user = getUser()
        try! realm!.write{
            user.profilePicture = profilePictureData
        }
    }
    
    func getProfilePicture()->Data?{
        let user = getUser()
        return user.profilePicture
    }
    
    func removeProfilePicture(){
        let user = getUser()
        try! realm!.write{
            user.profilePicture = nil
        }
    }
    
    // MARK: - Step
    
    func updateDB(date: Date, steps: Int){
        if let oldSteps = getSteps(date: date){
            try! realm!.write{
                oldSteps.count = steps
            }
        }else{
            addStep(Step(date: date.getUSFormat(), count: steps, partition: getPartitionValue()))
        }
    }
    
    func getSteps(date: Date)->Step?{
        let predicate = NSPredicate(format: "date = %@", date.getUSFormat())
        return realm!.objects(Step.self).filter(predicate).first
    }
    
    func addStep(_ step: Step){
        try! realm!.write {
            realm!.add(step)
        }
        
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
        let result = realm!.objects(Note.self).filter(predicate).sorted(byKeyPath: "time", ascending: false)
        
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
            oldNote?.imageURLs.removeAll()
            oldNote?.imageURLs.append(objectsIn: newNote.imageURLs)
            oldNote?.symptomNames.removeAll()
            oldNote?.symptomNames.append(objectsIn: newNote.symptomNames)
        }
    }
    
    private func deleteImagesInBucket(imageNames: [String], bucketName: String, completion: ()->()){
        for image in imageNames{
            app.currentUser?.functions.deleteImage([AnyBSON(image), AnyBSON(bucketName)]){ (_) in
                DispatchQueue.main.async {
                    self.deleteImage(imageName: image)
                }
            }
        }
        completion()
    }
    
    func removeNote(note: Note){
        deleteImagesInBucket(imageNames: note.getImageNames(), bucketName: note._id.stringValue, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                app.currentUser?.functions.deleteNoteBucket([AnyBSON(note._id.stringValue)]) { (_) in
                    DispatchQueue.main.async {
                        try! self.realm!.write {
                            self.realm!.delete(note)
                        }
                    }
                }
            }
        })
    }
    
    func addImage(newImage: Image){
        try! realm!.write{
            realm!.add(newImage)
        }
    }
    
    func getImageThumbnail(id: String) -> UIImage{
        do {
            let _id = try ObjectId(string: id)
            let image = realm!.object(ofType: Image.self, forPrimaryKey: _id)
            return UIImage(data: (image?.thumbNail)!)!
        } catch{
            print("###error: object id \(id) cannot be made.")
            return UIImage()
        }
    }
    
    func deleteImage(imageName: String){
        do {
            let _id = try ObjectId(string: imageName)
            let image = realm!.object(ofType: Image.self, forPrimaryKey: _id)
            try! realm!.write {
                realm!.delete(image!)
            }
        } catch{
            print("Error: object id \(imageName) cannot be deleted.")
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
    
    private func getInjectionsForLimb(limb: Limb)->Results<Injection>{
        let name = limb.name
        let result = realm!.objects(Injection.self).filter("limbName == '\(name)'")
        return result
    }
    
    func getRecentInjectionsForLimb(limb: Limb)->[Results<Injection>]{
        let injections = getInjectionsForLimb(limb: limb)
        var result : [Results<Injection>] = []
        
        for injectionDateOffsetFromToday in 0...5{
            var dayComponent = DateComponents()
            dayComponent.day = -1*injectionDateOffsetFromToday
            let theCalendar = Calendar.current
            let date = theCalendar.date(byAdding: dayComponent, to: Date())!
            
            let injectionsOnDate = injections.filter("date == '\(date.getUSFormat())'")
            result.append(injectionsOnDate)
        }
         
        return result
    }
    
    func getInjections(for date: Date) -> Results<Injection>{
        let predicate = NSPredicate(format: "date = %@", date.getUSFormat())
        let result = realm!.objects(Injection.self).filter(predicate).sorted(byKeyPath: "time", ascending: false)
        return result
    }
    
    func addPostInjectionData(injection: Injection, painScale: Int, note: String, symptoms: [String], reactions: [String]){
        try! realm!.write{
            injection.painScale = painScale
            injection.note = note
            injection.symptomNames.append(objectsIn: symptoms)
            injection.reactionNames.append(objectsIn: reactions)
        }
    }
    
    func removeInjection(injection: Injection){
        try! realm!.write {
            realm!.delete(injection)
        }
    }
    
    func haveInjections(for date: Date) -> Bool{
        let predicate = NSPredicate(format: "date beginswith %@", date.getUSFormat())
        let result = realm!.objects(Injection.self).filter(predicate)
        return result.count == 0 ? false : true
    }
    
    func editInjection(id: ObjectId, limbName: String, selectedCellX: Int, selectedCellY: Int){
        let oldInjection = realm!.object(ofType: Injection.self, forPrimaryKey: id)
        try! realm!.write{
            oldInjection?.limbName = limbName
            oldInjection?.selectedCellX = selectedCellX
            oldInjection?.selectedCellY = selectedCellY
        }
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
    
    func hasSignedConsent(realmA: Realm) -> Bool {
        let user = realmA.objects(User.self).first
        return user!.hasSignedConsent
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
        let alertController = UIAlertController(title: "Do you want to sign out?", message: "If you sign out you will no longer receive reminders. Your data will not be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: {
            _ -> Void in
            app.currentUser?.logOut { (_) in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                    let onboardingVC = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
                    RealmManager.shared.removeCredentials()
                    onboardingVC.walkthroughPageViewController?.currentIndex = walkthroughPages.count - 1
//                    vc.navigationController?.popViewController(animated: true)
                    vc.tabBarController?.selectedIndex = 0
                    let homeVCNavigationController = vc.tabBarController?.selectedViewController as! UINavigationController
                    homeVCNavigationController.setViewControllers([onboardingVC], animated: true)
                    
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.present(alertController, animated: true)
    }
    
    func acceptConsent(){
        let user = realm!.objects(User.self).first
        try! realm!.write{
            user!.hasSignedConsent = true
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
    
    func getPretestData()->[String]{
        let pretestData = realm?.objects(User.self).first?.getPretestData()
        
        guard let _ = pretestData else {
            return["", "", "", "", ""]
        }
        return [pretestData!.gender,
                pretestData!.birthday,
                pretestData!.typeOfMS,
                pretestData!.diagnosisDate,
                pretestData!.treatmentBeginningDate]
    }
    
    func hasGeneralData()->Bool{
        let user = realm?.objects(User.self).first
        if user?.birthday == ""{
            return false
        }
        else{
            return true
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

    func submitIP(answers: [String]){
        if hasInjectionPhobiaForm(){
            let ip = realm?.objects(InjectionPhobiaForm.self).first
            try! realm!.write{
                ip?.q1 = answers[0]
                ip?.q2 = answers[1]
                ip?.q3 = answers[2]
                ip?.q4 = answers[3]
                ip?.q5 = answers[4]
                ip?.q6 = answers[5]
                ip?.q7 = answers[6]
                ip?.q8 = answers[7]
            }
        }
        else{
            let ip = InjectionPhobiaForm(q1: answers[0], q2: answers[1], q3: answers[2], q4: answers[3], q5: answers[4], q6: answers[5], q7: answers[6], q8: answers[7], partition: getPartitionValue())
                try! realm!.write{
                    realm!.add(ip)
                }
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
    
    func hasInjectionPhobiaForm()->Bool{
        let ip = realm?.objects(InjectionPhobiaForm.self)
        if ip?.count == 0{
            return false
        }
        else{
            return true
        }
    }
}

// MARK: Mascot
extension RealmManager{
    func setMascot(name mascot: String){
        let user = realm!.objects(User.self).first
        try! realm!.write{
            user?.mascot = mascot
        }
    }
    
    func getMascot()->String{
        if let mascot = realm!.objects(User.self).first?.mascot{
            return mascot
        }
        else{
            return "Drummer"
        }
    }
}

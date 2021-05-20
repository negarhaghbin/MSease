//
//  Step.swift
//  MSease
//
//  Created by Negar on 2021-05-19.
//

import RealmSwift
import HealthKit

let healthStore = HKHealthStore()

class Step: Object {
    @objc dynamic var count : Int = 0
    @objc dynamic var date : String = ""
    
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition : String = ""
    
    static var counter = 0
    
    override static func primaryKey() -> String? {
      return "_id"
    }
    
    convenience init(date: String, count: Int, partition: String) {
        self.init()
        self.date = date
        self.count = count
        self._partition = partition
    }
}
    
    func getSteps(date: Date){
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Unable to get the step count type ***")
        }

        let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { (query, completionHandler, errorOrNil) in
            if let error = errorOrNil {
                print("not authorized: \(error)")
                return
            }
            
            getStepsCount(date: date){ steps in
                DispatchQueue.main.async {
                    RealmManager.shared.updateDB(date: date, steps: Int(steps))
                }
            }
            completionHandler()
        }

        healthStore.execute(query)
    }
    
    func askAuthorization(completion: () -> ()){
        if HKHealthStore.isHealthDataAvailable() {
            let stepsCount = HKObjectType.quantityType(forIdentifier: .stepCount)!

            healthStore.requestAuthorization(toShare: [], read: [stepsCount]) { (success, error) in
                    if error != nil {
                        print("HealthKit permission denied.")
                        print(error ?? "")
                    }  
                }
            }
            else{
                print("health not available")
            }
            completion()
        }
    
    func getStepsCount(date: Date, completion: @escaping (Double) -> Void) {
            let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            let (start, end) = date.getWholeDate()

            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])

            let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    completion(Double(-1))
                    return
                }
                completion(sum.doubleValue(for: HKUnit.count()))
            }

            healthStore.execute(query)
        }
    


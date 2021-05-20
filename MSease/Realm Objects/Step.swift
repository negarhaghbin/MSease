//
//  Step.swift
//  MSease
//
//  Created by Negar on 2021-05-19.
//

import HealthKit

let healthStore = HKHealthStore()

class Step{
    static var counter = 0
    
    class func getSteps(date: Date){
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Unable to get the step count type ***")
        }

        let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { (query, completionHandler, errorOrNil) in
            if let error = errorOrNil {
                print("not authorized: \(error)")
                return
            }
            
            getStepsCount(date: date){ steps in
                Step.counter = Int(steps)
            }
            completionHandler()
        }

        healthStore.execute(query)
    }
    
    class func askAuthorization(completion: () -> ()){
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
    
    private class func getStepsCount(date: Date, completion: @escaping (Double) -> Void) {
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
    
}

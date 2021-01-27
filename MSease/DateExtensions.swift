//
//  DateExtensions.swift
//  MSease
//
//  Created by Negar on 2021-01-27.
//

import Foundation

extension Date{
    func getUSFormat()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
}

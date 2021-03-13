//
//  WalkthroughPage.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import Foundation

var walkthroughPages : [WalkthroughPage] = []
class WalkthroughPage{
    var heading : String?
    var subheading : String?
    var imageName : String?
    
    var index : Int?
    
    convenience init(heading: String, subheading: String, imageName: String, index: Int) {
        self.init()
        self.heading = heading
        self.subheading = subheading
        self.imageName = imageName
        self.index = index
    }
}

func fillWalkthroughPages(){
    walkthroughPages.append(WalkthroughPage(heading: "Welcome to MSease!", subheading: "Keep everything in one place.", imageName: "page0", index: 0))
    walkthroughPages.append(WalkthroughPage(heading: "Add injections and symptoms", subheading: "Record your daily symptoms effortlessly.", imageName: "page1", index: 1))
    walkthroughPages.append(WalkthroughPage(heading: "Set customizable reminders", subheading: "Never forget a thing.", imageName: "page2", index: 2))
    walkthroughPages.append(WalkthroughPage(heading: "Gain useful insights", subheading: "Spot patterns between your injections, your symptoms, and your mood.", imageName: "page3", index: 3))
    
}

//
//  Page.swift
//  MSease
//
//  Created by Negar on 2021-03-11.
//

import Foundation

var walkthroughPages : [Page] = []
var arTutorialPages : [Page] = []
struct Page{
    var heading : String?
    var subheading : String?
    var imageName : String?
    
    var index : Int?
    
//    convenience init(heading: String, subheading: String, imageName: String, index: Int) {
//        self.init()
//        self.heading = heading
//        self.subheading = subheading
//        self.imageName = imageName
//        self.index = index
//    }
    
    static func fillARTutorialPages(){
        arTutorialPages.append(Page(heading: "", subheading: "Move the camera to left and right to initialize the space.", imageName: "tutorial0", index: 0))
//        arTutorialPages.append(Page(heading: "", subheading: "Keep moving the camera until the focus square finds a surface.", imageName: "tutorial1", index: 1))
        arTutorialPages.append(Page(heading: "", subheading: "Tap on the surface to place grid and mascot.", imageName: "tutorial2", index: 1))
        arTutorialPages.append(Page(heading: "", subheading: "Rescale or reposition the objects.", imageName: "tutorial3", index: 2))
        arTutorialPages.append(Page(heading: "", subheading: "Select a cell and choose done to log the injection.", imageName: "tutorial4", index: 3))
    }
    
    static func fillWalkthroughPages(){
        walkthroughPages.append(Page(heading: "Welcome to MS EaseIAR", subheading: "Our goal is to help you through your MS injection treatment.", imageName: "welcome", index: 0))
        walkthroughPages.append(Page(heading: "Remember", subheading: "Set up reminders for injections and medication refills.", imageName: "notification", index: 1))
        walkthroughPages.append(Page(heading: "Visualize", subheading: "Use augmented reality to help visualize the best injection location.", imageName: "ar", index: 2))
        walkthroughPages.append(Page(heading: "Journal", subheading: "Log your symptoms and side-effects.", imageName: "journal", index: 3))
//        walkthroughPages.append(Page(heading: "Gain useful insights", subheading: "Spot patterns between your injections, your symptoms, and your mood.", imageName: "insight", index: 3))
        walkthroughPages.append(Page(heading: "Get started", subheading: "Sign up for an account or login.", imageName: "signup", index: 4))
    }
}



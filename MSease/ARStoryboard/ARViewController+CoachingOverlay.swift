//
//  ARViewController+CoachingOverlay.swift
//  MSease
//
//  Created by Negar on 2021-02-26.
//

import UIKit
import ARKit

extension ARViewController: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        statusContainerView.isHidden = true
        bottomContainerView.isHidden = true
        focusSquare?.isEnabled = false
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        statusContainerView.isHidden = false
        bottomContainerView.isHidden = false
        focusSquare?.isEnabled = true
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        restartExperience()
    }

    func setupCoachingOverlay() {
        
        coachingOverlay.session = arview.session
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arview.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        
        coachingOverlay.activatesAutomatically = true
        
        //TODO: change to something meaningful
        if selectedLimbName! == limb.leftThigh.rawValue || selectedLimbName! == limb.rightThigh.rawValue{
            coachingOverlay.goal = .horizontalPlane
        }
        else{
            coachingOverlay.goal = .tracking
        }
        
    }

}

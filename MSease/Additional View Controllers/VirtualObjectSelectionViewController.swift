//
//  VirtualObjectSelectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-24.
//

import UIKit
import ARKit

// MARK: - ObjectCell

class ObjectCell: UITableViewCell {
    static let reuseIdentifier = "MascotCell"
    
    @IBOutlet weak var objectTitleLabel: UILabel!
    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var vibrancyView: UIVisualEffectView!
    
    var modelName = "" {
        didSet {
            objectTitleLabel.text = modelName.capitalized
            objectImageView.image = UIImage(named: modelName)
        }
    }
}

// MARK: - VirtualObjectSelectionViewControllerDelegate

protocol VirtualObjectSelectionViewControllerDelegate: class {
    func virtualObjectSelectionViewController(_ selectionViewController: VirtualObjectSelectionViewController, didSelectObject: VirtualObject)
    func virtualObjectSelectionViewController(_ selectionViewController: VirtualObjectSelectionViewController, didDeselectObject: VirtualObject)
}

class VirtualObjectSelectionViewController: UITableViewController {
    
    var virtualObjects = [VirtualObject]()
    var selectedVirtualObjectRow = -1
    weak var delegate: VirtualObjectSelectionViewControllerDelegate?
    weak var sceneView: ARSCNView?
    private var lastObjectAvailabilityUpdateTimestamp: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    func updateObjectAvailability() {
        guard let sceneView = sceneView else { return }
        
        // Update object availability only if the last update was at least half a second ago.
        if let lastUpdateTimestamp = lastObjectAvailabilityUpdateTimestamp,
            let timestamp = sceneView.session.currentFrame?.timestamp,
            timestamp - lastUpdateTimestamp < 0.5 {
            return
        } else {
            lastObjectAvailabilityUpdateTimestamp = sceneView.session.currentFrame?.timestamp
        }
                
//        var newEnabledVirtualObjectRow = Int()
        for (row, object) in VirtualObject.availableObjects.enumerated() {
            // Enable row always if item is already placed, in order to allow the user to remove it.
//            if selectedVirtualObjectRow == row {
//                newEnabledVirtualObjectRow = row
//            }
            
            // Enable row if item can be placed at the current location
            if let query = sceneView.getRaycastQuery(for: object.allowedAlignment),
                let result = sceneView.castRay(for: query).first {
                object.mostRecentInitialPlacementResult = result
                object.raycastQuery = query
//                newEnabledVirtualObjectRow = row
            } else {
                object.mostRecentInitialPlacementResult = nil
                object.raycastQuery = nil
            }
        }
        
        // Only reload changed rows
//        let changedRows = newEnabledVirtualObjectRows.symmetricDifference(enabledVirtualObjectRows)
//        enabledVirtualObjectRow = newEnabledVirtualObjectRow
//        let indexPaths = changedRows.map { row in IndexPath(row: row, section: 0) }

//        DispatchQueue.main.async {
//            self.tableView.reloadRows(at: indexPaths, with: .automatic)
//        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellIsEnabled = enabledVirtualObjectRows.contains(indexPath.row)
//        guard cellIsEnabled else { return }
        
        let object = virtualObjects[indexPath.row]
        
        // Check if the current row is already selected, then deselect it.
        if (selectedVirtualObjectRow == indexPath.row) {
            delegate?.virtualObjectSelectionViewController(self, didDeselectObject: object)
        } else {
            delegate?.virtualObjectSelectionViewController(self, didSelectObject: object)
        }

        dismiss(animated: true, completion: nil)
    }
        
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return virtualObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectCell.reuseIdentifier, for: indexPath) as? ObjectCell else {
            fatalError("Expected `\(ObjectCell.self)` type for reuseIdentifier \(ObjectCell.reuseIdentifier). Check the configuration in Main.storyboard.")
        }
        
        cell.modelName = virtualObjects[indexPath.row].modelName

        if (selectedVirtualObjectRow == indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        let cellIsEnabled = true
//            enabledVirtualObjectRows.contains(indexPath.row)
        if cellIsEnabled {
            cell.vibrancyView.alpha = 1.0
        }
//        else {
//            cell.vibrancyView.alpha = 0.1
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cellIsEnabled = (enabledVirtualObjectRow == indexPath.row)
//        guard cellIsEnabled else { return }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cellIsEnabled = (enabledVirtualObjectRow == indexPath.row)
//        guard cellIsEnabled else { return }

        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }

}


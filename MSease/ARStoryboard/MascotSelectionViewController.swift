//
//  MascotSelectionViewController.swift
//  MSease
//
//  Created by Negar on 2021-01-24.
//

import UIKit
import ARKit
import RealityKit


// MARK: - ObjectCell

class MascotCell: UITableViewCell {
    static let reuseIdentifier = "MascotCell"
    
    @IBOutlet weak var mascotTitleLabel: UILabel!
    @IBOutlet weak var mascotImageView: UIImageView!
    @IBOutlet weak var vibrancyView: UIVisualEffectView!
    
    var modelName = "" {
        didSet {
            mascotTitleLabel.text = modelName.capitalized
            mascotImageView.image = UIImage(named: modelName)
        }
    }
}

// MARK: - VirtualObjectSelectionViewControllerDelegate

protocol MascotSelectionViewControllerDelegate: class {
    func mascotSelectionViewController(_ selectionViewController: MascotSelectionViewController, didSelectObjectAt: Int)
    func mascotSelectionViewController(_ selectionViewController: MascotSelectionViewController, didDeselectObjectAt: Int)
}

class MascotSelectionViewController: UITableViewController {
    var mascots = [Mascot]()
    var selectedMascotRow = -1
    weak var delegate: MascotSelectionViewControllerDelegate?
    weak var sceneView: ARView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectedMascotRow == indexPath.row) {
            delegate?.mascotSelectionViewController(self, didDeselectObjectAt: indexPath.row)
        } else {
            delegate?.mascotSelectionViewController(self, didSelectObjectAt: indexPath.row)
        }

        dismiss(animated: true)
    }
        
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mascots.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MascotCell.reuseIdentifier, for: indexPath) as? MascotCell else {
            fatalError("Did not find `\(MascotCell.self)` type for reuseIdentifier \(MascotCell.reuseIdentifier).")
        }
        
        cell.modelName = mascotNames[indexPath.row]

        if (selectedMascotRow == indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        let cellIsEnabled = true
        if cellIsEnabled {
            cell.vibrancyView.alpha = 1.0
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .clear
    }

}


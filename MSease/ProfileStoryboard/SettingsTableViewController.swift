//
//  SettingsTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-27.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet var mascots: [MascotTableViewCell]?
    @IBOutlet weak var mascotLabel: UILabel!
    
    // MARK: - Variables
    enum rows : Int{
        case mascot = 0
        case none
        case drummer
        case plane
        case robot
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        let mascot = RealmManager.shared.getMascot()
        mascotLabel.text = mascot
        for mascotCell in mascots!{
            if mascotCell.titleLabel.text == mascot{
                mascotCell.accessoryType = .checkmark
            }
        }
    }
    
    // MARK: - Table view
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(46.0)
        switch indexPath.row {
        case rows.mascot.rawValue+1...rows.robot.rawValue:
            height = mascots![indexPath.row-1].isHidden ? 0.0 : 100.0
        default:
            height = CGFloat(46.0)
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case rows.mascot.rawValue:
            for cell in mascots!{
                cell.isHidden = !cell.isHidden
            }
        case rows.mascot.rawValue+1...rows.robot.rawValue:
            for mascot in mascots!{
                mascot.accessoryType = .none
            }
            mascots![indexPath.row-1].accessoryType = .checkmark
            
            let newMascot = mascots![indexPath.row-1].titleLabel?.text
            mascotLabel.text = newMascot
            RealmManager.shared.setMascot(name: newMascot!)
                        
        default:
            break
        }
        AnimateTableCell(indexPath: indexPath)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

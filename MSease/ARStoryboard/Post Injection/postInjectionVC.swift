//
//  postInjectionVC.swift
//  MSease
//
//  Created by Negar on 2021-04-09.
//

import UIKit

var PISelectedSymptomNames : [String] = []
var PISelectedReactionNames : [String] = []

class postInjectionVC: UITableViewController, UITextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var options: [UIButton]!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reactionsCollectionView: UICollectionView!
    @IBOutlet weak var symptomsCollectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Variables
    enum cellid : String{
        case ReactionsCollection = "reactionCollectionCell"
        case SymptomsCollection = "symptomCollectionCell"
    }
    
    var injection : Injection?{
        didSet{
            selectedPain = injection!.painScale
            PISelectedSymptomNames = injection!.getSymptoms()
            PISelectedReactionNames = injection!.getReactions()
        }
    }
    
    var selectedPain : Int = 0
    
    lazy var partitionValue = RealmManager.shared.getPartitionValue()
    
    // MARK: - View Controllers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        textView.inputAccessoryView = toolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set button selected
        styleButtons()
        if let selectedPainButton = self.view.viewWithTag(selectedPain) as? UIButton{
            StylingUtilities.styleFilledPainscaleButton(selectedPainButton, range: selectedPain)
        }
        
        textView.text = injection?.note
        symptomsCollectionView.reloadData()
        reactionsCollectionView.reloadData()
        
    }
    
    // MARK: - Note Text View
    func textViewDidBeginEditing(_ textView: UITextView) {
        if injection?.note == "Add a note..."{
            textView.text = ""
        }
        textView.textColor = UIColor.label
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        let content = (textView.text == "Add a note..." ? "" : textView.text)!
        RealmManager.shared.addPostInjectionData(injection: injection!, painScale: selectedPain, note: content, symptoms: PISelectedSymptomNames, reactions: PISelectedReactionNames)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func painButtonTapped(_ sender: UIButton) {
        if let prevPainButton = self.view.viewWithTag(selectedPain) as? UIButton{
            StylingUtilities.stylePainscaleButton(prevPainButton, range: selectedPain)
        }
        selectedPain = Int((sender.titleLabel?.text)!)!
        if let selectedPainButton = self.view.viewWithTag(selectedPain) as? UIButton{
            StylingUtilities.styleFilledPainscaleButton(selectedPainButton, range: selectedPain)
        }
    }
    
    // MARK: - Helpers
    func styleButtons(){
        for (index, option) in options.enumerated(){
            StylingUtilities.stylePainscaleButton(option, range: index+1)
        }
        
        StylingUtilities.styleFilledButton(submitButton)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}

// MARK: - UICollectionViewDelegate
extension postInjectionVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.reactionsCollectionView{
            return reactions.count
        }
        else if collectionView == self.symptomsCollectionView{
            return symptoms.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.reactionsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid.ReactionsCollection.rawValue, for: indexPath) as! SymptomsCollectionViewCell
            cell.image.image = UIImage(named: reactions[indexPath.row].imageName)
            cell.name.text = reactions[indexPath.row].name
            if PISelectedReactionNames.contains(reactions[indexPath.row].name){
                cell.checkmarkImage.isHidden = false
            }
            else{
                cell.checkmarkImage.isHidden = true
            }
            return cell
        }
        else if collectionView == self.symptomsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid.SymptomsCollection.rawValue, for: indexPath) as! SymptomsCollectionViewCell
            cell.image.image = UIImage(named: symptoms[indexPath.row].imageName)
            cell.name.text = symptoms[indexPath.row].name
            if PISelectedSymptomNames.contains(symptoms[indexPath.row].name){
                cell.checkmarkImage.isHidden = false
            }
            else{
                cell.checkmarkImage.isHidden = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.reactionsCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? SymptomsCollectionViewCell{
                if cell.checkmarkImage.isHidden{
                    PISelectedReactionNames = cell.add(to: PISelectedReactionNames)
                }
                else{
                    PISelectedReactionNames = cell.remove(from: PISelectedReactionNames)
                }
            }
        }
        else if collectionView == self.symptomsCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? SymptomsCollectionViewCell{
                if cell.checkmarkImage.isHidden{
                    PISelectedSymptomNames = cell.add(to: PISelectedSymptomNames)
                }
                else{
                    PISelectedSymptomNames = cell.remove(from: PISelectedSymptomNames)
                }
            }
        }
    }
}



//
//  InjectionTableViewController.swift
//  MSease
//
//  Created by Negar on 2021-04-12.
//

import UIKit

class InjectionTableViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var options: [UIButton]!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var limbCell: UITableViewCell!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reactionsCollectionView: UICollectionView!
    @IBOutlet weak var symptomsCollectionView: UICollectionView!
//    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Variables
    enum cellid : String{
        case ReactionsCollection = "reactionCollectionCell"
        case SymptomsCollection = "symptomCollectionCell"
    }
    
    enum sections : Int{
        case limb = 0
        case painScale
        case reactions
        case symptoms
        case note
    }
    
    var injection : Injection?{
        didSet{
            selectedPain = injection!.painScale
            PISelectedSymptomNames = injection!.getSymptoms()
            PISelectedReactionNames = injection!.getReactions()
        }
    }
    var grid2D : [[UIImageView]] = []
    
    var isNewInjection: Bool?
    
    var selectedPain : Int?
    
    var partitionValue = RealmManager.shared.getPartitionValue()
    
    // MARK: - View Controllers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        textView.inputAccessoryView = toolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        styleButtons()
        
        if selectedPain != 0{
            StylingUtilities.styleFilledPainscaleButton(options[selectedPain!-1], range: selectedPain!)
        }

        textView.text = injection?.note
        symptomsCollectionView.reloadData()
        reactionsCollectionView.reloadData()
        
        titleLabel.text = injection?.limbName
        
        let injectedLimb = Limb.getLimb(name: injection!.limbName)
        bodyImage.image = UIImage(named: injectedLimb.imageName)!
        prepareGrid(limbGrid: injectedLimb)
        
        // FIXME : -hidden or not?
        //self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    // MARK: - Note Text View
    func textViewDidBeginEditing(_ textView: UITextView) {
        if injection?.note == "Add a note..."{
            textView.text = ""
        }
        textView.textColor = UIColor(named: "Label Color")
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        let content = (textView.text == "Add a note..." ? "" : textView.text)!
        RealmManager.shared.addPostInjectionData(injection: injection!, painScale: selectedPain!, note: content, symptoms: PISelectedSymptomNames, reactions: PISelectedReactionNames)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func painButtonTapped(_ sender: UIButton) {
        if selectedPain != 0{
            StylingUtilities.stylePainscaleButton(options[selectedPain!-1], range: selectedPain!)
        }
        selectedPain = Int((sender.titleLabel?.text)!)!
        StylingUtilities.styleFilledPainscaleButton(options[selectedPain!-1], range: selectedPain!)
    }
    
    // MARK: - Helpers
    func styleButtons(){
        for (index,option) in options.enumerated(){
            StylingUtilities.stylePainscaleButton(option, range: index+1)
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func hideExtraRowsAndCols(hidden:[(x: Int, y: Int)]){
        for block in hidden{
            self.grid2D[block.x][block.y].isHidden = true
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sections.limb.rawValue{
            if injection?.limbName == "Abdomen"{
                return CGFloat(170)
            }
            else{
                return CGFloat(250)
            }
        }
        else if indexPath.section == sections.painScale.rawValue{
            return CGFloat(250)
        }
        else if indexPath.section == sections.note.rawValue{
            return CGFloat(170)
        }
        else{
            return CGFloat(122)
        }
    }
    
    // FIXME: For big screens
    func prepareGrid(limbGrid: Limb){
        var cells : [(x: Int, y: Int)] = []
        cells.append((x: injection!.selectedCellX, y: injection!.selectedCellY))
        
        let width : Double?
        if limbGrid.name == "Abdomen"{
            width = Double(limbCell.contentView.frame.width/20)
        }
        else{
            width = Double(limbCell.contentView.frame.width/15)
        }
        
        for i in 0..<limbGrid.numberOfRows{
            grid2D.append([])
            for j in 0..<limbGrid.numberOfCols{
                let xVal = Double((0.75+Double(j))*width! - Double(2*j))
                let yVal = Double((2.25+Double(i))*width! - Double(i))
                let frame = CGRect(x: xVal, y: yVal, width: width!, height: width!)
                let imageView = UIImageView(frame: frame)
                imageView.image = UIImage(systemName: "square.fill")
                
                if (injection!.selectedCellX == i) && (injection?.selectedCellY == j){
                    imageView.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                }
                
                grid2D[i].append(imageView)
                limbCell.contentView.addSubview(imageView)
            }
        }
        hideExtraRowsAndCols(hidden: Array(limbGrid.hiddenCells))
    }
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }

}

// MARK: - UICollectionViewDelegate
extension InjectionTableViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
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



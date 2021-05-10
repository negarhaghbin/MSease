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
    
    @IBOutlet weak var limbPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyImage: UIImageView!
    @IBOutlet weak var limbPickerCell: UITableViewCell!
    @IBOutlet weak var limbCell: UITableViewCell!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reactionsCollectionView: UICollectionView!
    @IBOutlet weak var symptomsCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
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
    
    var injection : Injection?
    var grid2D : [[UIImageView]] = []
    
    var isNewInjection: Bool?
    var date : Date?{
        didSet{
            self.title = date?.getUSFormat()
        }
    }
    var selectedPain : Int?
    var selectedCell : (x: Int, y: Int)?{
        didSet{
            if selectedCell != nil{
                saveButton.isEnabled = true
            }
            else{
                saveButton.isEnabled = false
            }
        }
    }
    
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
        styleButtons()
        
        selectedPain = injection?.painScale
        PISelectedSymptomNames = injection?.getSymptoms() ?? []
        PISelectedReactionNames = injection?.getReactions() ?? []
        if selectedPain != nil && selectedPain != 0{
            StylingUtilities.styleFilledPainscaleButton(options[selectedPain!-1], range: selectedPain!)
        }
        if injection != nil{
            selectedCell = (x: injection!.selectedCellX, y: injection!.selectedCellY)
            let pickerRow = rowInPicker(title: injection!.limbName)
            limbPicker.selectRow(pickerRow, inComponent: 0, animated: false)
        }
        titleLabel.text = injection?.limbName ?? limbs[limbPicker.selectedRow(inComponent: 0)].name
        
        
        textView.text = injection?.note
        symptomsCollectionView.reloadData()
        reactionsCollectionView.reloadData()
        
        let injectedLimb = Limb.getLimb(name: injection?.limbName ?? limb.abdomen.rawValue)
        bodyImage.image = UIImage(named: injectedLimb.imageName)!
        prepareGrid(limbGrid: injectedLimb)
        
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
        if injection == nil {
            injection = Injection(limbName: titleLabel.text!, selectedCellX: selectedCell!.x, selectedCellY: selectedCell!.y, hasUsedAR: false, date: date, partition: partitionValue)
            RealmManager.shared.addInjection(newInjection: injection!)
        }
        else{
            RealmManager.shared.editInjection(id: injection!._id, limbName: titleLabel.text!, selectedCellX: selectedCell!.x, selectedCellY: selectedCell!.y)
        }
        
        RealmManager.shared.addPostInjectionData(injection: injection!, painScale: selectedPain ?? 0, note: content, symptoms: PISelectedSymptomNames, reactions: PISelectedReactionNames)
        
//        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func painButtonTapped(_ sender: UIButton) {
        if selectedPain != nil && selectedPain != 0{
            StylingUtilities.stylePainscaleButton(options[selectedPain!-1], range: selectedPain!)
        }
        selectedPain = Int((sender.titleLabel?.text)!)!
        StylingUtilities.styleFilledPainscaleButton(options[selectedPain!-1], range: selectedPain!)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if tappedImage.tintColor == UIColor(hex: StylingUtilities.InjectionCodes[StylingUtilities.InjectionCodes.count-1].0) {
            if selectedCell != nil{
                grid2D[selectedCell!.x][selectedCell!.y].tintColor = UIColor(hex: StylingUtilities.InjectionCodes[StylingUtilities.InjectionCodes.count-1].0)
            }
            
            tappedImage.tintColor = UIColor(hex: StylingUtilities.InjectionCodes[0].0)
            
            for i in 0..<grid2D.count{
                for j in 0..<grid2D[i].count{
                    if grid2D[i][j] == tappedImage{
                        selectedCell = (x: i, y:j)
                        return
                    }
                }
            }
            
        }
        else{
            tappedImage.tintColor = UIColor(hex: StylingUtilities.InjectionCodes[StylingUtilities.InjectionCodes.count-1].0)
            selectedCell = nil
        }
        
    }
    
    // MARK: - Table View Controller
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: sections.limb.rawValue){
            limbPicker.isHidden = !limbPicker.isHidden
        }
        AnimateTableCell(indexPath: indexPath)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sections.limb.rawValue{
            if indexPath.row == 0{
                return CGFloat(50)
            }
            if indexPath.row == 1{
                return limbPicker.isHidden ? CGFloat(0) : CGFloat(200)
            }
            else{
                return titleLabel.text == "Abdomen" ? CGFloat(170) : CGFloat(250)
            }
        }
        else if indexPath.section == sections.painScale.rawValue{
            return CGFloat(250)
        }
        else if indexPath.section == sections.note.rawValue{
            return CGFloat(170)
        }
        else{
            return CGFloat(150)
        }
    }
    
    // MARK: - Helpers
    
    func rowInPicker(title:String)->Int{
        for (i, limb) in limbs.enumerated(){
            if limb.name == title{
                return i
            }
        }
        return -1
    }
    
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
    
    
    // FIXME: For big screens
    func prepareGrid(limbGrid: Limb){
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
                imageView.tintColor = UIColor(hex: StylingUtilities.InjectionCodes[StylingUtilities.InjectionCodes.count-1].0)
                imageView.isUserInteractionEnabled = true
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                imageView.addGestureRecognizer(tapGestureRecognizer)
                
                if (selectedCell?.x == i) && (selectedCell?.y == j){
                    imageView.tintColor = UIColor(hex: StylingUtilities.InjectionCodes[0].0)
                }
                
                grid2D[i].append(imageView)
                limbCell.contentView.addSubview(imageView)
            }
        }
        hideExtraRowsAndCols(hidden: Array(limbGrid.hiddenCells))
    }
    
    func removePreviousGrid(){
        for subview in limbCell.contentView.subviews{
            let imageSubview = subview as! UIImageView
            if imageSubview.image == UIImage(systemName: "square.fill"){
                imageSubview.removeFromSuperview()
            }
        }
        grid2D = []
        selectedCell = nil
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

extension InjectionTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return limbs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return limbs[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedLimbName = limbs[pickerView.selectedRow(inComponent: 0)].name
        titleLabel.text = selectedLimbName
        removePreviousGrid()
        let injectedLimb = Limb.getLimb(name: selectedLimbName)
        bodyImage.image = UIImage(named: injectedLimb.imageName)!
        prepareGrid(limbGrid: injectedLimb)
        tableView.reloadData()
    }
    
}


//
//  FullscreenImageViewController.swift
//  MSease
//
//  Created by Negar on 2021-02-24.
//

import UIKit
import RealmSwift

class FullscreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageName : String?{
        didSet{
            app.currentUser?.functions.getImage([AnyBSON(imageName!)]){ [self]
                data, error in
                let binaryData = Data(base64Encoded: (data?.binaryValue)!)
                imageUI = UIImage(data: binaryData!)
            }
        }
    }
    
    var imageUI : UIImage?{
        didSet{
            refreshUI()
        }
    }
    
    var selectedImages: [String]?{
        didSet{
            print(selectedImages)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refreshUI() {
        DispatchQueue.main.sync {
            self.imageView.image = imageUI
        }
    }
    
    @IBAction func deleteImage(_ sender: Any){
        let alertController = UIAlertController(title: "Are you sure?", message: "This image will be deleted.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            _ -> Void in
            // FIXME: delete images from aws too
//            app.currentUser?.functions.deleteImage([AnyBSON(self.imageName!)]) { (_) in
                DispatchQueue.main.async {
                    self.removeImage()
                    self.navigationController?.popViewController(animated: true)
                    let vc = self.navigationController?.topViewController as! SymptomsCollectionViewController
                    vc.selectedImages = self.selectedImages!
                    
                }
//            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func removeImage(){
        RealmManager.shared.deleteImage(imageName: imageName!)
        let index = selectedImages!.firstIndex(of: imageName!)
        selectedImages?.remove(at: index!)
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

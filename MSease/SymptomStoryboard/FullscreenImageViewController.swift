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
    
    var imageInfo : (imageName: String, bucketName: String)?{
        didSet{
            app.currentUser?.functions.getImage([AnyBSON(imageInfo!.imageName), AnyBSON(imageInfo!.bucketName)]){ [unowned self]
                data, error in
                if let binaryValue = data?.binaryValue{
                    let binaryData = Data(base64Encoded: binaryValue)
                    imageUI = UIImage(data: binaryData!)
                }
            }
        }
    }
    
    var imageUI : UIImage?{
        didSet{
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image =  RealmManager.shared.getImageThumbnail(id: imageInfo!.imageName)
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

            app.currentUser?.functions.deleteImage([AnyBSON(self.imageInfo!.imageName), AnyBSON(self.imageInfo!.bucketName)]) { (_) in
                DispatchQueue.main.async {
                    self.removeImage()
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func removeImage(){
        RealmManager.shared.deleteImage(imageName: imageInfo!.imageName)
        let index = selectedImages.firstIndex(of: imageInfo!.imageName)
        selectedImages.remove(at: index!)
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

//
//  PreviewVC.swift
//  Capture Screen
//
//  Created by Akshay on 20/01/2020.
//  Copyright © 2020 Akshay Deep Singh All rights reserved.
//

import UIKit
import Photos

class PreviewVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var image:UIImage?
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = self.image {
            self.imageView.image = image
        }else {
            self.deleteButtonAction()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func deleteButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction() {
        if let image = self.image {
            
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized, .notDetermined:
                try? PHPhotoLibrary.shared().performChangesAndWait {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                    // Generate Notification
                    self.appDelegate?.scheduleNotification(notificationType: "Local Notification with Action", image: image)
                    self.navigationController?.popViewController(animated: true)
                }
            default:
                let alert = UIAlertController(title: "Photos Permissions", message: "Please allow photos read white permission.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

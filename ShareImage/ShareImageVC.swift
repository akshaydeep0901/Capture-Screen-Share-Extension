//
//  ShareImageVC.swift
//  ShareImage
//
//  Created by Akshay on 20/01/2020.
//  Copyright © 2020 Akshay Deep Singh All rights reserved.
//

import Foundation
import UIKit
import Photos
import Social
import MobileCoreServices

class ShareImageVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.image {
            self.imageView.image = image
        }else {
            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
        }
        
        self.manageImages()
    }
    
    func manageImages() {
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        
        for (index, attachment) in (content.attachments!).enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { [weak self] data, error in
                    
                    if error == nil, let url = data as? URL, let _ = self {
                        do {
                            let rawData = try Data(contentsOf: url)
                            let rawImage = UIImage(data: rawData)
                            self?.image = rawImage!
                            self?.imageView.image = self?.image
                            if index == (content.attachments?.count)! - 1 {
                                DispatchQueue.main.async {
                                    
                                }
                            }
                        }
                        catch let exp {
                            print("GETTING EXCEPTION \(exp.localizedDescription)")
                        }
                        
                    } else {
                        print("GETTING ERROR")
                        let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func deleteButtonAction() {
        self.extensionContext!.cancelRequest(withError:NSError())
    }
}

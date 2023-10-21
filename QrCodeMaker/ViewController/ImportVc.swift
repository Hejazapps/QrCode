//
//  GalleryPickerViewController.swift
//  FinalDocumentScanner
//
//  Created by MacBook Pro Retina on 19/3/20.
//  Copyright © 2020 MacBook Pro Retina. All rights reserved.
//

import UIKit
import Photos
import IHProgressHUD

protocol ClassBVCDelegate {
    func changeIndex()
}
class ImportVc: UIViewController {
    
    
    var delegate: ClassBVCDelegate?
    var currentImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if(Store.sharedInstance.getPopValue() || Store.sharedInstance.getsshouldShowHomeScreen()) {

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sadiq"), object: nil)
            return
            // Store.sharedInstance.setPopValue(value: false)
        }
        Store.sharedInstance.setPopValue(value: false)
        Store.sharedInstance.setshouldShowHomeScreen(value: false)
        Store.sharedInstance.setshouldShowScanner(value: false)
    }
    
    func showPicker () {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePickerIphone") as! ImagePickerIphone
        //let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(vc, animated: false, completion: nil)
            // topController should now be your topmost view controller
        }
        
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
}

extension PHAsset {
    func image(targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?) -> UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: targetSize, contentMode: contentMode, options: options, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
}

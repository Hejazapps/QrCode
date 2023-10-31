//
//  MainTabVc.swift
//  QrCodeScanner
//
//  Created by MacBook Pro Retina on 5/4/20.
//  Copyright © 2020 MacBook Pro Retina. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class MainTabVc: UITabBarController,UITabBarControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    let vc = ScannerVC()
    var codeValue:String!
    var myView:UIView!
    func changeIndex() {
        self.tabBar.isHidden = false
        self.selectedIndex = 0
        
    }

    func changeIndex1() {
        self.tabBar.isHidden = false
        self.selectedIndex = 0
    }
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData(notification:)), name:NSNotification.Name(rawValue: "sadiq"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData1(notification:)), name:NSNotification.Name(rawValue: "hide"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData2(notification:)), name:NSNotification.Name(rawValue: "createdTab"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData2(notification:)), name:NSNotification.Name(rawValue: "homeTab"), object: nil)
        
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        //self.tabBar.unselectedItemTintColor = UIColor.gray
        self.delegate = self
        myView = UIView(frame: CGRect(x: 0, y: -900, width: self.view.frame.width, height: 100))
       
        myView.backgroundColor = UIColor(red: 18.0/255.0, green: 120.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        self.view.addSubview(myView)
        
        
        let allViewsInXibArray = Bundle.main.loadNibNamed("ButtonView", owner: self, options: nil)
        let myView1 = allViewsInXibArray?.first as! ButtonView
        myView1.frame = myView.bounds
        myView.addSubview(myView1)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func reloadData2(notification: NSNotification) {
        
        
        if notification.name == NSNotification.Name(rawValue: "homeTab"){
            
            self.selectedIndex = 0
            
        } else if notification.name == NSNotification.Name(rawValue: "createdTab"){
            self.selectedIndex = 2
        }
        
        
    }
    
    @objc func reloadData1(notification: NSNotification) {
        
        if notification.name == NSNotification.Name(rawValue: "hide"){
           var value = -1000
            if let image = notification.userInfo?["image"] as? Int {
                if image > 0 {
                    value = Int(self.view.frame.height - 100)
                }
                
                myView.frame.origin.y = CGFloat(value)
                
            }
        }
         
    }
    
    @objc func reloadData(notification: NSNotification) {
        
        if notification.name == NSNotification.Name(rawValue: "sadiq"){
            if (Store.sharedInstance.getshouldShowHistoryPage()) {
                self.selectedIndex = 3
                
            }
            else{
                self.selectedIndex = 0
            }
           // Store.sharedInstance.setShowHistoryPage(value: false)
            self.tabBar.isHidden = false
        }

        
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController is ImportVc{
//            Store.sharedInstance.setPopValue(value: false)
//            Store.sharedInstance.setshouldShowHomeScreen(value: false)
//            Store.sharedInstance.setshouldShowScanner(value: false)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImportVc") as! ImportVc
//            vc.delegate = self
//            vc.showPicker()
//            self.tabBar.isHidden = true
//        }
        
        
        if let secondVC = viewController as? SecondViewController {
            print("SecondVC is selected")
            Store.sharedInstance.setPopValue(value: false)
            Store.sharedInstance.setshouldShowHomeScreen(value: false)
            Store.sharedInstance.setshouldShowScanner(value: false)
            secondVC.selectPhotoFromSavedPhotosAlbum()
        }
        
        
    }

    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .denied: alertToEncourageCameraAccessInitially()
        default: print("sadiq")
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "Scan with Camera",
            message: "To scan your Qr Codes allow access camera",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "ALLOW ACCESS", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showView() {
        
        self.checkCamera()
        self.definesPresentationContext = true
        vc.modalPresentationStyle = .overCurrentContext
        vc.setupScanner() { (code) in
            self.codeValue = code
            self.dismiss(animated: true, completion: self.showResult)
        }
        
        
        self.definesPresentationContext = true
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }

    func showResult() {
        
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}



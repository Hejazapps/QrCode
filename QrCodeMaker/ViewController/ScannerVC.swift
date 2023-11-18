//
//  ScannerVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import AVFoundation
import IHProgressHUD
import KRProgressHUD
import AudioToolbox

public class ScannerVC: UIViewController {
    
    @IBOutlet weak var gotosettings: UIButton!
    @IBOutlet weak var permissionView: UIView!
    let soundID: SystemSoundID = 1104
    
    public lazy var headerViewController:HeaderVC = .init()
    
    public lazy var cameraViewController:CameraVC = .init()
    
    /// 动画样式
    public var animationStyle:ScanAnimationStyle = .default{
        didSet{
            cameraViewController.animationStyle = animationStyle
        }
    }
    
    // 扫描框颜色
    public var scannerColor:UIColor = .red{
        didSet{
            cameraViewController.scannerColor = scannerColor
        }
    }
    
    public var scannerTips:String = ""{
        didSet{
            cameraViewController.scanView.tips = scannerTips
        }
    }
    
    /// `AVCaptureMetadataOutput` metadata object types.
    public var metadata = AVMetadataObject.ObjectType.metadata {
        didSet{
            cameraViewController.metadata = metadata
        }
    }
    
    public var successBlock:((String)->())?
    
    public var errorBlock:((Error)->())?
    
    
    /// 设置标题
    public override var title: String?{
        
        didSet{
            
            if navigationController == nil {
                headerViewController.title = title
            }
        }
        
    }
    
    
    /// 设置Present模式时关闭按钮的图片
    public var closeImage: UIImage?{
        
        didSet{
            
            if navigationController == nil {
                headerViewController.closeImage = closeImage ?? UIImage()
            }
        }
        
    }
    
    override public func viewDidLoad() {
        print("ScannerVC -> viewDidLoad()")
        super.viewDidLoad()
        
        setupUI()
        
        
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraViewController.startCapturing()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        KRProgressHUD.dismiss()
        //DBmanager.shared.initDB()
        
        self.checkCameraAccess()
        gotosettings.layer.cornerRadius = 15.0
        gotosettings.clipsToBounds = true
        
    }
    
    
    func presentCameraSettings() {
//        let alertController = UIAlertController(title: "Error",
//                                      message: "Camera access is denied",
//                                      preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
//        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
//            if let url = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
//                    // Handle
//                })
//            }
//        })

         
        permissionView.isHidden = false
        self.view.bringSubviewToFront(permissionView)
    }
    
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            print("Hello")
        }
    }
    
}




// MARK: - CustomMethod
extension ScannerVC{
    
    func setupUI() {
        print("ScannerVC -> setupUI()")
        if title == nil {
            title = "Scan"
        }
        
        view.backgroundColor = .black
        
        headerViewController.delegate = self
        
        cameraViewController.metadata = metadata
        
        cameraViewController.animationStyle = animationStyle
        
        cameraViewController.delegate = self
        
        add(cameraViewController)
        print("Added cameraVC")
        
        if navigationController == nil {
            
            //add(headerViewController)
            
            view.bringSubviewToFront(headerViewController.view)
            
        }
    }
    
    
    func gotoView1(qrCodeLink:String) {
        
        let value2 = QrcOodearray.getArray(text: qrCodeLink)
        let value = QrParser.getBarCodeObj(text: qrCodeLink)
        
        let value3 = QrParser.getBarCodeObj(text: value)
        var type = ""
        if value.count > 0 {
            var outputResult = value.components(separatedBy: "^") as NSArray
            type = (outputResult[1] as? String)!
            print("bal = \(type)")
            
        }
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVc") as! ShowResultVc
        vc.stringValue = qrCodeLink
        vc.modalPresentationStyle = .fullScreen
        vc.showText = value
        vc.currenttypeOfQrBAR = type
        vc.createDataModelArray = value2
        vc.isFromScanned = true
        UIApplication.topMostViewController?.present(vc, animated: true, completion: {
            
            
        })
        
    }
    
    
    
    
    public func setupScanner(_ title:String? = nil, _ color:UIColor? = nil, _ style:ScanAnimationStyle? = nil, _ tips:String? = nil, _ success:@escaping ((String)->())){
        
        if title != nil {
            self.title = title
        }
        
        if color != nil {
            scannerColor = color!
        }
        
        if style != nil {
            animationStyle = style!
        }
        
        if tips != nil {
            scannerTips = tips!
        }
        
        successBlock = success
        
    }
    
    
}




// MARK: - HeaderViewControllerDelegate
extension ScannerVC:HeaderViewControllerDelegate{
    
    
    /// 点击关闭
    public func didClickedCloseButton() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}



extension ScannerVC:CameraViewControllerDelegate{
    
    func didOutput(_ code: String ,type: String) {
        
        print("outpout  = \(code)")
        
        
        let a = UserDefaults.standard.integer(forKey: "Link")
        
        if a == 2 {
            if code.containsIgnoringCase(find: "https") {
                guard let url = URL(string: code) else {
                    return //be safe
                }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                return
            }
        }
        
        
        let b = UserDefaults.standard.integer(forKey: "vibrate")
        
        if b == 2 {
            print("Vibrating")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        let c = UserDefaults.standard.integer(forKey: "Beep")
        
        if c == 2 {
            print("Playing beep")
            AudioServicesPlaySystemSound(SystemSoundID(1110))
        }
        
        let shouldPlayCaptureSound = UserDefaults.standard.integer(forKey: "sound") == 2
        if shouldPlayCaptureSound {
            print("Playing capture")
            AudioServicesPlaySystemSound(SystemSoundID(1108))
        }
        
        let fullNameArr = type.components(separatedBy: ".")
        let name = fullNameArr[2] as? String
        let image = BarCodeGenerator.getBarCodeImage(type: name!, value: code)
        
        // print("image ratio size  = \(image!.size.width)")
        
        let v = QrcOodearray.getArray(text: code)
        
        
        if let value = image {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVc") as! ShowResultVc
            vc.stringValue = code
            vc.modalPresentationStyle = .fullScreen
            vc.isFromScanned = true
            vc.isfromQr = false
            vc.currenttypeOfQrBAR = name!
            
            self.present(vc, animated: true)
            
            
        }
        
        else {
            
            self.gotoView1(qrCodeLink: code)
            
        }
        
        cameraViewController.stopCapturing()
        
        successBlock?(code)
        
    }
    
    func didReceiveError(_ error: Error) {
        
        errorBlock?(error)
        
    }
    
}

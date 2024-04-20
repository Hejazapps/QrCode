//
//  QRScannerController.swift
//  QRCodeScanner
//
//  Created by Nitin Aggarwal on 22/05/21.
//

import UIKit
import AVFoundation

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Properties
     @IBOutlet weak var permissionView: UIView!
    @IBOutlet weak var gotosettings: UIButton!
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var isPermissionGiven = false
    public var successBlock:((String)->())?
     
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Check for camera permission has given or not.
        if isPermissionGiven {
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        } else {
            checkCameraPermission()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // stop capture session when this screen will disappear.
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    
    // MARK: - Private Methods
    private func initialSetup() {
        view.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancelAction))
        cancelButton.tintColor = .white
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc private func handleCancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoSettings(_ sender: Any) {
        
       
        self.openAppSpecificSettings()
        
    }
    
    @objc func openAppSpecificSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        let optionsKeyDictionary = [UIApplication.OpenExternalURLOptionsKey(rawValue: "universalLinksOnly"): NSNumber(value: true)]
        
        UIApplication.shared.open(url, options: optionsKeyDictionary, completionHandler: nil)
    }
    
    
    public func setupScanner(_ title:String? = nil, _ color:UIColor? = nil, _ style:ScanAnimationStyle? = nil, _ tips:String? = nil, _ success:@escaping ((String)->())){
        
       
        successBlock = success
        
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                self.isPermissionGiven = true
                self.setupCaptureSession()
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                DispatchQueue.main.async {
                    if success {
                        self.isPermissionGiven = true
                        self.setupCaptureSession()
                    } else {
                        self.isPermissionGiven = false
                        self.accessDenied()
                    }
                }
            }
            
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.isPermissionGiven = false
                self.accessDenied()
            }
            
        @unknown default:
            DispatchQueue.main.async {
                self.isPermissionGiven = false
                self.accessDenied()
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (captureSession != nil ) {
            
            captureSession.startRunning()
            
        }
     
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        try! videoCaptureDevice.lockForConfiguration()
        videoCaptureDevice.focusPointOfInterest = self.view.frame.origin
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failedSession()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        } else {
            failedSession()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        let holeWidth: CGFloat = 270
        let hollowedView = UIView(frame: view.frame)
        hollowedView.backgroundColor = .clear

        let hollowedLayer = CAShapeLayer()

        let focusRect = CGRect(origin: CGPoint(x: (view.frame.width - holeWidth) / 2, y: (view.frame.height - holeWidth) / 2), size: CGSize(width: holeWidth, height: holeWidth))
        let holePath = UIBezierPath(roundedRect: focusRect, cornerRadius: 12)
        let externalPath = UIBezierPath(rect: hollowedView.frame).reversing()
        holePath.append(externalPath)
        holePath.usesEvenOddFillRule = true
        
        hollowedLayer.path = holePath.cgPath
        hollowedLayer.fillColor = UIColor.black.cgColor
        hollowedLayer.opacity = 0.5
        
        hollowedView.layer.addSublayer(hollowedLayer)
        view.addSubview(hollowedView)

        let scannerPlaceholderView = UIImageView(frame: focusRect)
      
        scannerPlaceholderView.image = UIImage(named: "qr_scan_placeholder")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        scannerPlaceholderView.tintColor = UIColor(red: 18.0/255, green: 119.0/255, blue: 254.0/255, alpha: 1.0)
        scannerPlaceholderView.contentMode = .scaleAspectFill
        scannerPlaceholderView.clipsToBounds = true
        self.view.addSubview(scannerPlaceholderView)
        self.view.bringSubviewToFront(scannerPlaceholderView)
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: focusRect)
    }
    
    private func failedSession() {
        captureSession = nil
        showAlert(message: "Your device does not support scanning a code from an item. Please use a device with a camera.")
    }
    
    private func accessDenied() {
         
        permissionView.isHidden = false
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(actionButton)
        present(alert, animated: true, completion: nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       
       
        if let metadataObject = metadataObjects.first {
            captureSession.stopRunning()
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
                
              
                captureSession.startRunning()
                return
            }
            
            print("test qr code found \(object.stringValue) \(object.type.rawValue)")
            
            didOutput(object.stringValue ?? "", type: object.type.rawValue)
             
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
                
                captureSession.startRunning()
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
        
        captureSession.stopRunning()
        
        successBlock?(code)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        self.captureSession = nil
    }
}


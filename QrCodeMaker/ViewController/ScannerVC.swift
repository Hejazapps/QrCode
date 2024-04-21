//
//  QRScannerController.swift
//  QRCodeScanner
//
//  Created by Nitin Aggarwal on 22/05/21.
//

import UIKit
import AVFoundation

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - Properties
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var isPermissionGiven = false
    public var successBlock:((String)->())?

    @IBOutlet weak var gotosettings: UIButton!
    @IBOutlet weak var permissionView: UIView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        permissionView.isHidden = true
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
        self.setNotification()
    }
    
  
    
    func setNotification() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("[murad] success Push authorization")
            } else {
                print("[murad] error Push authorization: \(String(describing: error?.localizedDescription))")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // stop capture session when this screen will disappear.
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    
    public func setupScanner(_ title:String? = nil, _ color:UIColor? = nil, _ style:ScanAnimationStyle? = nil, _ tips:String? = nil, _ success:@escaping ((String)->())){
        
       
        successBlock = success
        
    }
    
    
    @objc func openAppSpecificSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        let optionsKeyDictionary = [UIApplication.OpenExternalURLOptionsKey(rawValue: "universalLinksOnly"): NSNumber(value: true)]
        
        UIApplication.shared.open(url, options: optionsKeyDictionary, completionHandler: nil)
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
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async { [self] in
                permissionView.isHidden = true
                self.isPermissionGiven = true
                self.setupCaptureSession()
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                DispatchQueue.main.async {
                    if success {
                        self.isPermissionGiven = true
                        self.permissionView.isHidden = true
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
    
    @IBAction func gotoSettings(_ sender: Any) {
        
        self.openAppSpecificSettings()
        
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
                
                captureSession.stopRunning()
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
            metadataOutput.metadataObjectTypes = [.qr]
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
        scannerPlaceholderView.image = UIImage(named: "qr_scan_placeholder")
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
        captureSession = nil
        permissionView.isHidden = false
        
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(actionButton)
        present(alert, animated: true, completion: nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            
            captureSession.stopRunning()
            return
        }
        
        
        didOutput(object.stringValue ?? "", type: object.type.rawValue)
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

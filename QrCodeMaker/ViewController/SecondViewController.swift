//
//  SecondViewController.swift
//  TabBarImagePicker
//
//  Created by Md. Ikramul Murad on 29/10/23.
//

import UIKit
import UniformTypeIdentifiers
import Photos
import Vision
import ZXingObjC
import IHProgressHUD

class SecondViewController: UIViewController, UINavigationControllerDelegate {
    
    
    var picker: UIImagePickerController?
    var currentBarCode = ""
    var alreadySelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
       
    }
    var isCodeFound = false
    
    
    @available(iOS 11.0, *)
    var vnBarCodeDetectionRequest : VNDetectBarcodesRequest{
        let request = VNDetectBarcodesRequest { (request,error) in
            
            if let error = error as NSError? {
                print("Error in detecting - \(error)")
                return
            }
            else {
                
                guard let observations = request.results as? [VNBarcodeObservation]
                else {
                    return
                }
                var type = ""
                var text = ""
                var barcodeBoundingRects = [CGRect]()
                for barcode in observations {
                    barcodeBoundingRects.append(barcode.boundingBox)
                    let barcodeType = String(barcode.symbology.rawValue)
                    if type.count == 0
                    {
                        type = String(barcode.symbology.rawValue).replacingOccurrences(of: "VNBarcodeSymbology", with: "")
                    }
                    if let payload = barcode.payloadStringValue {
                        text =  payload
                    }
                    
                    
                }
                
                
                if type.containsIgnoringCase(find: "ean13") {
                    self.currentBarCode = "EAN-13"
                    DispatchQueue.main.async {
                        self.setBarCode(currentBarCode: self.currentBarCode,value: text)
                    }
                    
                }
                
                else if type.containsIgnoringCase(find: "CODE128") {
                    self.currentBarCode = "Code 128"
                    DispatchQueue.main.async {
                        self.setBarCode(currentBarCode: self.currentBarCode,value: text)
                    }
                    
                }
                
                else if type.containsIgnoringCase(find: "CODE39") {
                    self.currentBarCode = "Code 39"
                    DispatchQueue.main.async {
                        self.setBarCode(currentBarCode: self.currentBarCode,value: text)
                    }
                    
                }
                
                else if type.containsIgnoringCase(find: "EAN8") {
                    self.currentBarCode = "EAN-8"
                    DispatchQueue.main.async {
                        self.setBarCode(currentBarCode: self.currentBarCode,value: text)
                    }
                    
                }
                
                else if type.containsIgnoringCase(find: "UPCA") {
                    self.currentBarCode = "UPC-A"
                    DispatchQueue.main.async {
                        self.setBarCode(currentBarCode: self.currentBarCode,value: text)
                    }
                    
                }
                
                else if type.containsIgnoringCase(find: "UPCE") {
                    self.currentBarCode = "UPC-E"
                    DispatchQueue.main.async {
                        self.setBarCode(currentBarCode: self.currentBarCode,value: text)
                    }
                    
                }
                else {
                    self.setBarCode(currentBarCode: "", value: "")
                }
            }
        }
        return request
    }
    
    
    
    @available(iOS 11.0, *)
     static var vnBarCodeDetectionRequest : VNDetectBarcodesRequest{
        let request = VNDetectBarcodesRequest { (request,error) in
            if let error = error as NSError? {
                
                DispatchQueue.main.async {
                    //IHProgressHUD.dismiss()
                }
                
                print("Error in detecting - \(error)")
                return
            }
            else {
                DispatchQueue.main.async {
                    // IHProgressHUD.dismiss()
                }
            }
        }
        return request
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    
        
        if Store.sharedInstance.shouldShowHomeScreen {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
      
        print("nosto")
       
    }
    
    func photoLibraryAvailabilityCheck()
    {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.processSnapShotPhotos()
            case .restricted:
                self.showAlert()
            case .denied:
                self.showAlert()
            default:
                // place for .notDetermined - in this callback status is already determined so should never get here
                break
            }
        }
    }
    
    
    func showAlert()
    {
        alreadySelected = false
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Photos Access required",
                message: "To scan codes from images the app needs Photos access",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) -> Void in
                Store.sharedInstance.setshouldShowHomeScreen(value: true)
               
                self.tabBarController?.selectedIndex = 0
                 
                
            }))
            alert.addAction(UIAlertAction(title: "Allow Access", style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    func barcodeFormatToString(format:ZXBarcodeFormat,value:String){
        switch (format) {
        case kBarcodeFormatAztec:
            currentBarCode = "Aztec"
            
        case kBarcodeFormatCodabar:
            currentBarCode = ""
            
        case kBarcodeFormatCode39:
            currentBarCode = "Code 39"
            
            
        case kBarcodeFormatCode128:
            currentBarCode = "Code 128"
            
        case kBarcodeFormatDataMatrix:
            currentBarCode = "Data Matrix"
            
        case kBarcodeFormatEan8:
            currentBarCode = "EAN-8"
            
        case kBarcodeFormatEan13:
            currentBarCode = "EAN-13"
            
        case kBarcodeFormatITF:
            currentBarCode = "ITF"
            
            
        case kBarcodeFormatUPCA:
            currentBarCode = "UPC-A"
            
        case kBarcodeFormatUPCE:
            currentBarCode = "UPC-E"
        default: break
            
        }
        
        self.setBarCode(currentBarCode: currentBarCode,value: value)
        
    }
    
    
    func setBarCode(currentBarCode:String,value:String)
    {
        print("halua1")
        alreadySelected = false
        if(currentBarCode.count < 1 && !isCodeFound)
        {
            print("halua2")
            let alert = UIAlertController(title: "Note", message: "Can not Detect Any Code", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                self.dismiss(animated: true) { [weak self] in
                    self?.tabBarController?.selectedIndex = 0
                }
            }))
            
            DispatchQueue.main.sync {
                
                UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                    
                })
            }
             
            
        }
        else
        
        {
            
            let image = BarCodeGenerator.getBarCodeImage(type: currentBarCode, value: value)
            
             
            if let value1 = image {
                isCodeFound = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVc") as! ShowResultVc
                vc.stringValue = value
                vc.modalPresentationStyle = .fullScreen
                vc.image = image
                vc.isFromScanned = true
                vc.isfromQr = false
                vc.currenttypeOfQrBAR = currentBarCode
                vc.isFromGallery = true
                
                self.dismiss(animated: true) { [weak self] in
                     
                    UIApplication.topMostViewController?.present(vc, animated: true, completion: {
                       
                    })
                    
                }
                
                
            }
            else {
                
                print("halua")
                let alert = UIAlertController(title: "Note", message: "Can not Detect Any Code", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                    
                    
                 
                    self.dismiss(animated: true) { [weak self] in
                        self?.tabBarController?.selectedIndex = 0
                    }
                    
                    
                   
                }))
                DispatchQueue.main.sync {
                    
                    UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                        
                    })
                }
               
            }
            
        }
    }
    
    
    func selectedImage(selectedImage:UIImage) {
       
        
        print("hahahahhaha")
        let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let ciImage:CIImage=CIImage(image:selectedImage)!
        var qrCodeLink=""
        
        let features=detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            qrCodeLink += feature.messageString!
        }
        
        if qrCodeLink=="" {
            
            let luminanceSource: ZXLuminanceSource = ZXCGImageLuminanceSource(cgImage:  selectedImage.cgImage)
            let binarizer = ZXHybridBinarizer(source: luminanceSource)
            let bitmap = ZXBinaryBitmap(binarizer: binarizer)
            let hints: ZXDecodeHints = ZXDecodeHints.hints() as! ZXDecodeHints
            let QRReader = ZXMultiFormatReader()
            currentBarCode = ""
            // throw/do/catch and all that jazz
            do {
                let result = try QRReader.decode(bitmap, hints: hints)
                self.barcodeFormatToString(format: result.barcodeFormat,value:result.text)
                
                
            } catch let err as NSError {
                
                // IHProgressHUD.show(withStatus: "Detecting ......")
                print("hahahahhaha1")
                self.createVisionRequest(image: selectedImage)
            }
        }else{
            IHProgressHUD.dismiss()
            self.gotoView1(qrCodeLink: qrCodeLink)
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
        vc.isFromGallery  = true
        self.dismiss(animated: true) { [weak self] in
             
            UIApplication.topMostViewController?.present(vc, animated: true, completion: {
               
            })
            
        }
        
        
    }
    
    
    func createVisionRequest(image: UIImage)
    {
        guard let cgImage = image.cgImage else {
            return
        }
        if #available(iOS 11.0, *) {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            
            
            let vnRequests = [self.vnBarCodeDetectionRequest ]
            
            DispatchQueue.global(qos: .background).async {
                do{
                    try requestHandler.perform(vnRequests)
                    
                    
                    
                }catch let error as NSError {
                    print("Error in performing Image request: \(error)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
   
    
    
    
    func  processSnapShotPhotos() {
        
        
        DispatchQueue.main.async {
            
            guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
                print("Source type isn't available")
                return
            }
            
            if self.picker == nil {
                print("Picker is nil. Need to init picker")
                self.picker = UIImagePickerController()
                
            
                self.picker?.delegate = self
                self.picker?.sourceType = .savedPhotosAlbum
                self.picker?.mediaTypes = [UTType.image.identifier]
                self.picker?.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
                self.picker?.modalPresentationStyle = .fullScreen
            }
            
            
            if let v =  self.picker {
                self.present(v,animated: true)
            }
           
            
        }
    }
    
    func selectPhotoFromSavedPhotosAlbum() {
        
        self.photoLibraryAvailabilityCheck()
      
    }
}

extension SecondViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let okImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if alreadySelected {
                print("ttouched")
                return
            }
            self.selectedImage(selectedImage:okImage)
        }
        alreadySelected = true
       
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel()")
        
        dismiss(animated: true) { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }
    }
}

//
//  ImagePickerIphone.swift
//  FinalDocumentScanner
//
//  Created by MacBook Pro Retina on 29/3/20.
//  Copyright © 2020 MacBook Pro Retina. All rights reserved.
//

import UIKit
import Photos
import Vision
import ZXingObjC
import IHProgressHUD
import RSBarcodes_Swift
import SVProgressHUD
import KRProgressHUD


class ImagePickerIphone: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var currentBarCode = ""
    var arr2Name = NSArray(objects: "EAN-13","EAN-8","UPC-A","UPC-E","Code128","ITF","Code39","Codabar","Data-Matrix","Aztec-Code")
    var tempSp:UIView! = nil
    var isCodeFound = false
    
    var isSelected = false
    
    @IBOutlet weak var collectionview: UICollectionView!
    var allPhotos : PHFetchResult<PHAsset>? = nil
    let imagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Photos Access required",
                message: "To scan codes from images the app needs Photos access",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) -> Void in
                Store.sharedInstance.setshouldShowHomeScreen(value: true)
               
                self.dismiss(animated: true)
                 
                
            }))
            alert.addAction(UIAlertAction(title: "Allow Access", style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.funcToCall()
    }
    func processSnapShotPhotos() {
        
        
        DispatchQueue.main.async {
            
            
            self.imagePickerController.allowsEditing = false //If you want edit option set "true"
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.delegate = self
            self.imagePickerController.modalPresentationStyle = .fullScreen
            self.present(self.imagePickerController, animated: true, completion: nil)
            
        }
    
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isSelected {
            isSelected = false
            return
        }
        
        if Store.sharedInstance.shouldShowHistoryPage || Store.sharedInstance.shouldShowHomeScreen {
            self.dismiss(animated: false)
            
        }
        self.photoLibraryAvailabilityCheck()
    }
    
    func funcToCall() {
        Store.sharedInstance.setshouldShowHomeScreen(value: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        Store.sharedInstance.setshouldShowHomeScreen(value: true)
    }
    
    func createVisionRequest(image: UIImage)
    {
        guard let cgImage = image.cgImage else {
            return
        }
        if #available(iOS 11.0, *) {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            
            
            let vnRequests = [self.vnBarCodeDetectionRequest]
            
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
    
     
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    @objc fileprivate func targetMethod(){
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        isSelected = true
        picker.dismiss(animated: true)
        self.selectedImage(selectedImage: image)

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
    
    
    func selectedImage(selectedImage:UIImage) {
        
        
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
                self.createVisionRequest(image: selectedImage)
            }
        }else{
            IHProgressHUD.dismiss()
            self.gotoView1(qrCodeLink: qrCodeLink)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IHProgressHUD.dismiss()
        isSelected = false
    }
    
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
    
    func getScreenshot(view:UIView) -> UIImage? {
        //creates new image context with same size as view
        // UIGraphicsBeginImageContextWithOptions (scale=0.0) for high res capture
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        
        // renders the view's layer into the current graphics context
        if let context = UIGraphicsGetCurrentContext() { view.layer.render(in: context) }
        
        // creates UIImage from what was drawn into graphics context
        let screenshot: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        // clean up newly created context and return screenshot
        UIGraphicsEndImageContext()
        return screenshot
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
    
    func dismissView() {
        
        self.funcToCall()
        
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        tempSp = spinnerView
    }
    
    func removEs() {
        
        DispatchQueue.main.async { [self] in
            tempSp?.removeFromSuperview()
            tempSp = nil
        }
    }
    
    func setBarCode(currentBarCode:String,value:String)
    {
        
        if(currentBarCode.count < 1 && !isCodeFound)
        {
            let alert = UIAlertController(title: "Note", message: "Can not Detect Any Code", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                self.dismissView()
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
                
                
                
                UIApplication.topMostViewController?.present(vc, animated: true, completion: {
                    
                })
                
                
            }
            else {
                let alert = UIAlertController(title: "Note", message: "Can not Detect Any Code", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                    self.dismissView()
                }))
                
                DispatchQueue.main.sync {
                    
                    UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                        
                    })
                }
            }
            
        }
    }
    
}

extension ImagePickerIphone: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:0, height:0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let value =  allPhotos {
            return value.count
        }
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let mainViewWidth = UIScreen.main.bounds.width
        let viewWidth = (mainViewWidth - 5 * 10) / 4
        let height =  viewWidth
        
        return CGSize(width: viewWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ImageViewCell
        
        let mainViewWidth = UIScreen.main.bounds.width
        let viewWidth = (mainViewWidth - 5 * 10) / 4
        let height =  viewWidth
        
        cell.backgroundColor = UIColor.red
        cell.widthForView.constant = viewWidth
        cell.imv.image = UIImage(named: "image_picker")
        if let assets = allPhotos {
            
            cell.imv.image = assets[indexPath.row].thumbnailImage
            cell.imv.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelected {
            return
        }
        
        isSelected = true
        
        IHProgressHUD.show()
        
        
        if let assets = allPhotos {
            self.selectedImage(selectedImage: assets[indexPath.row].thumbnailImage)
        }
        
        
        
    }
}



extension PHAsset {
    var thumbnailImage : UIImage {
        get {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 1000, height: 1000), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
            })
            return thumbnail
        }
    }
}


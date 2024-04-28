//
//  ShowResultVc.swift
//  QrCode&BarCodeMizan
//
//  Created by Macbook pro 2020 M1 on 18/3/23.
//

import UIKit
import AVFoundation
import MessageUI
import IHProgressHUD
import KRProgressHUD
import QRCode
import EventKit
import EventKitUI
import Contacts
import NetworkExtension
import StoreKit

protocol dismissImagePicker {
    func  dimissAllClass()
}

class ShowResultVc: UIViewController, MFMessageComposeViewControllerDelegate, sendImage, sendUpdatedArray, EKEventEditViewDelegate, MFMailComposeViewControllerDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        if action.rawValue == 0 {
            
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        eventF = controller.event
        
        var event = Event()
        
        if let eventV = controller.event?.title {
            event.summary = eventV
            
            // self.createDataModelArray.append(ResultDataModel(title: "Title", description: event.summary!))
        }
        
        if let startDate = controller.event?.startDate {
            // Store.sharedInstance.setstartDate(date: startDate)
            event.dtstart = startDate
            // let a = startDate.toString()
            //self.createDataModelArray.append(ResultDataModel(title: "Start", description:a))
        }
        
        if let endDate = controller.event?.endDate {
            // Store.sharedInstance.setstartDate(date: endDate)
            event.dtend = endDate
            //let a = endDate.toString()
            // self.createDataModelArray.append(ResultDataModel(title: "End", description:a))
        }
        
        if let location = controller.event?.location {
            event.location = location
            //self.createDataModelArray.append(ResultDataModel(title: "Location", description: event.location!))
        }
        
        if let note = controller.event?.notes {
            event.descr = note
            //self.createDataModelArray.append(ResultDataModel(title: "Notes", description: event.descr!))
        }
        
        let calendar = Calendar1(withComponents: [event])
        let iCalString = calendar.toCal()
        
        let value = QrParser.getBarCodeObj(text: iCalString)
        
        
        showText = value
        outputResult = showText.components(separatedBy: "^") as NSArray
        showText = (outputResult[0] as? String)!
        tablewView.reloadData()
        stringValue = iCalString
        self.updateAll()
        tablewView.reloadData()
        
        
        
        eventF = controller.event
        controller.dismiss(animated: true)
        
    }
    
    func processYelpData(ar: [ResultDataModel], sh: String, st: String) {
        
        if !isfromQr {
            
            stringValue = st
            var output = "BarCode Detail"
            output =  output + "\n\n"
            output = output + stringValue
            
            barLabelText.text = stringValue
            if let img = BarCodeGenerator.getBarCodeImage(type: currenttypeOfQrBAR, value: stringValue) {
                
                image = img
                
                labelText.text = output
                
                let height = image.size.height
                let width = image.size.width
                
                print(width)
                print(height)
                
                imv.image = image
                //barTextValue.text = stringValue
                qrCodeShowView.isHidden = true
                
            }
            
            return
        }
        
        
        createDataModelArray = ar
        
        showText = sh
        outputResult = showText.components(separatedBy: "^") as NSArray
        showText = (outputResult[0] as? String)!
        tablewView.reloadData()
        stringValue = st
        self.updateAll()

        tablewView.reloadData()
    }
    
    
    
    func sendScreenSort(image: UIImage ,position: String,shape:String,logo:UIImage?,color1:UIColor,color2:UIColor) {
        
        
        position1 = position
        shape1 = shape
        logo1 = logo
        
        widthForMainView.constant = imageviewHolder.frame.width
        heightForMainView.constant = imageviewHolder.frame.height - CGFloat(deductionValue)
        
        colora =  color1
        colorb = color2
        
        self.updateAll()
        
        let size = AVMakeRect(aspectRatio: imv.image!.size, insideRect: imv.frame)
        widthForMainView.constant = size.width
        heightForMainView.constant = size.height
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var editContentView: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var customizeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barTextValue: UILabel!
    
    @IBOutlet weak var imv: UIImageView!
    
    @IBOutlet weak var imageviewHolder: UIView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var barCodeView: UIView!
    @IBOutlet weak var qrCodeStackValue: UIStackView!
    
    @IBOutlet weak var tablewView: UITableView!
    
    @IBOutlet weak var widthForMainView: NSLayoutConstraint!
    @IBOutlet weak var heightForMainView: NSLayoutConstraint!
    @IBOutlet weak var heightForScrollView: NSLayoutConstraint!
    @IBOutlet weak var heightForView: NSLayoutConstraint!
    var store: CNContactStore!
    
    
    var idF = ""
    var showText  = ""
    var stringValue  = ""
    var isfromQr = true
    var  isFromScanned = false
    var image:UIImage! = nil
    var outputResult:NSArray!
    var currentData: DetectedInfo?
    var currenttypeOfQrBAR = ""
    
    var  isfromUpdate = false
    
    var createDataModelArray = [ResultDataModel]()
    var eventF:EKEvent?
    var contactCard:CNMutableContact!
    var delegateDis: dismissImagePicker?
    
    @IBOutlet weak var heightForView1: NSLayoutConstraint!
    
    @IBOutlet weak var barLabelText: UILabel!
    
    @IBOutlet weak var bnTextContent: UIButton!
    @IBOutlet weak var qrCodeShowView: UIView!
    var deductionValue = 0
    var position1 = "square"
    var shape1 = "square"
    var logo1:UIImage? = nil
    var colora = UIColor.black
    var colorb  = UIColor.white
    
    let doc = QRCode.Document()
    
    var contacts:[CNContact] = []
    var isFromGallery = false
    //var type = ""
    
    @IBAction func gotoCustomizeDesign(_ sender: Any) {
        
        self.gotocustomizeDeisgn()
    }
    
    func gotocustomizeDeisgn() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomizeDesignViewController") as! CustomizeDesignViewController
        vc.modalPresentationStyle = .fullScreen
        vc.stringValue = stringValue
        vc.delegate = self
        vc.position = position1
        vc.shape = shape1
        vc.logoImage = logo1
        vc.foreGroundColor = colora
        vc.backgroundColor = colorb
        
        self.present(vc, animated: true)
        
    }
    
    
    func updateImage(imGW:UIImage) {
        
        
        let widthRatio = 0.2
        let heightRatio = 0.2
        let centerX = 0.5
        let centerY = 0.5
        doc.logoTemplate = QRCode.LogoTemplate(
            image:  (imGW.cgImage!),
            path: CGPath(
                rect: CGRect(x: centerX - widthRatio / 2, y: centerY - heightRatio / 2, width: widthRatio, height: heightRatio),
                transform: nil
            )
        )
        
    }
    
    func updatePosition(name:String) {
        
        if name.containsIgnoringCase(find: "BarsHorizontal") {
            doc.design.shape.eye = QRCode.EyeShape.BarsHorizontal()
        }
        if name.containsIgnoringCase(find: "BarsVertical") {
            doc.design.shape.eye = QRCode.EyeShape.BarsVertical()
        }
        if name.containsIgnoringCase(find: "Circle") {
            doc.design.shape.eye = QRCode.EyeShape.Circle()
        }
        if name.containsIgnoringCase(find: "CorneredPixels") {
            doc.design.shape.eye = QRCode.EyeShape.CorneredPixels()
        }
        if name.containsIgnoringCase(find: "Leaf") {
            doc.design.shape.eye = QRCode.EyeShape.Leaf()
        }
        if name.containsIgnoringCase(find: "Pixels") {
            doc.design.shape.eye = QRCode.EyeShape.Pixels()
        }
        if name.containsIgnoringCase(find: "RoundedOuter") {
            doc.design.shape.eye = QRCode.EyeShape.RoundedOuter()
        }
        if name.containsIgnoringCase(find: "RoundedPointingIn") {
            doc.design.shape.eye = QRCode.EyeShape.RoundedPointingIn()
        }
        if name.containsIgnoringCase(find: "RoundedRect") {
            doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
        }
        if name.containsIgnoringCase(find: "Square") {
            doc.design.shape.eye = QRCode.EyeShape.Square()
        }
        if name.containsIgnoringCase(find: "Square") {
            doc.design.shape.eye = QRCode.EyeShape.Square()
        }
        if name.containsIgnoringCase(find: "Squircle") {
            doc.design.shape.eye = QRCode.EyeShape.Squircle()
        }
        if name.containsIgnoringCase(find: "Shield") {
            doc.design.shape.eye = QRCode.EyeShape.Shield()
        }
        
    }
    
    
    func updateShape(name:String) {
        
        if name.containsIgnoringCase(find: "horizontal") {
            doc.design.shape.onPixels = QRCode.PixelShape.Horizontal()
        }
        if name.containsIgnoringCase(find: "pointy") {
            doc.design.shape.onPixels = QRCode.PixelShape.Pointy()
        }
        if name.containsIgnoringCase(find: "circle") {
            doc.design.shape.onPixels = QRCode.PixelShape.Circle()
        }
        if name.containsIgnoringCase(find: "curvepixel") {
            doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel()
        }
        if name.containsIgnoringCase(find: "flower") {
            doc.design.shape.onPixels = QRCode.PixelShape.Flower()
        }
        if name.containsIgnoringCase(find: "roundedEndIndent") {
            doc.design.shape.onPixels = QRCode.PixelShape.RoundedEndIndent()
        }
        if name.containsIgnoringCase(find: "roundedPath") {
            doc.design.shape.onPixels = QRCode.PixelShape.RoundedPath()
        }
        if name.containsIgnoringCase(find: "roundedRect") {
            doc.design.shape.onPixels = QRCode.PixelShape.RoundedRect()
        }
        if name.containsIgnoringCase(find: "sharp") {
            doc.design.shape.onPixels = QRCode.PixelShape.Sharp()
        }
        if name.containsIgnoringCase(find: "shiny") {
            doc.design.shape.onPixels = QRCode.PixelShape.Shiny()
        }
        if name.containsIgnoringCase(find: "square") {
            doc.design.shape.onPixels = QRCode.PixelShape.Square()
        }
        if name.containsIgnoringCase(find: "squircle") {
            doc.design.shape.onPixels = QRCode.PixelShape.Squircle()
        }
        if name.containsIgnoringCase(find: "star") {
            doc.design.shape.onPixels = QRCode.PixelShape.Star()
        }
        if name.containsIgnoringCase(find: "vertical") {
            doc.design.shape.onPixels = QRCode.PixelShape.Vertical()
        }
        
    }
    
    
    func updateAll() {
        
        doc.utf8String =  stringValue
        doc.errorCorrection = .high
        doc.design.backgroundColor(UIColor.clear.cgColor)
        if position1.count > 1 {
            self.updatePosition(name: position1)
        }
        
        if shape1.count > 1 {
            self.updateShape(name: shape1)
        }
        
        if  let v = logo1  {
            self.updateImage(imGW: v)
        }
        else {
            doc.logoTemplate = nil
        }
        
        doc.design.foregroundColor(colora.cgColor)
        doc.design.backgroundColor(colorb.cgColor)
        
        let path = doc.path(CGSize(width: 1000, height: 1000))
        let image = doc.uiImage(CGSize(width: 1000, height: 1000), dpi: 216)
        imv.image = image
    }
    
    
    private func requestContactsAccess() {
        
        store.requestAccess(for: .contacts) {granted, error in
            if granted {
                
                DispatchQueue.main.async {
                    self.accessGrantedForContacts()
                }
                
            }
        }
    }
    
    
    private func checkContactsAccess() {
           switch CNContactStore.authorizationStatus(for: .contacts) {
           // Update our UI if the user has granted access to their Contacts
           case .authorized:
               self.accessGrantedForContacts()
               
           // Prompt the user for access to Contacts if there is no definitive answer
           case .notDetermined :
               self.requestContactsAccess()
               
           // Display a message if the user has denied or restricted access to Contacts
           case .denied,
                .restricted:
               let alert = UIAlertController(title: "Privacy Warning!",
                                             message: "Permission was not granted for Contacts.",
                                             preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           @unknown default:
               print("sadiqul amin")
           }
       }
       private func accessGrantedForContacts() {
           
           let mutableContact:CNMutableContact!
           
           if stringValue.containsIgnoringCase(find: "MECARD") {
               mutableContact = contactCard
           }
           else{
               mutableContact = contacts.first!.mutableCopy() as! CNMutableContact
           }
           
           
           IHProgressHUD.show(withStatus: "Saving ........")
           let request = CNSaveRequest()
           request.add(mutableContact, toContainerWithIdentifier: nil)
           do{
               try store.execute(request)
               DispatchQueue.main.async {
                   IHProgressHUD.dismiss()
               }
               
               self.showToast(message: "Contact has been added", font: .systemFont(ofSize: 12.0))
               
           } catch let err{
               DispatchQueue.main.async {
                   IHProgressHUD.dismiss()
               }
               print("Failed to save the contact. \(err)")
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(showText)
        store = CNContactStore()
        if isfromQr {
            Store.sharedInstance.shouldShowLabel = false
        }
        if showText.count > 0 {
            outputResult = showText.components(separatedBy: "^") as NSArray
            showText = (outputResult[0] as? String)!
            // type = (outputResult[1] as? String)!
            //print(type)
            
            
           
        }
        tablewView.separatorColor = UIColor.clear
        
        print("mamammamamamamamammaa: \(stringValue)")
        
        
        
        if stringValue.containsIgnoringCase(find: "vcard") {
            
            if let data = stringValue.data(using: .utf8) {
                 do{
                     contacts = try CNContactVCardSerialization.contacts(with: data)
                     let contact = contacts.first
                     
                     
                    
                 }
                catch{
                    // Error Handling
                     print(error.localizedDescription)
                 }
             }
            
        }
        
        if  isfromQr {
            self.updateAll()
        }
        else {
            var output = "BarCode Detail"
            output =  output + "\n\n"
            output = output + stringValue
            
            
            if let img = BarCodeGenerator.getBarCodeImage(type: currenttypeOfQrBAR, value: stringValue) {
                
                
                image = img
                
                labelText.text = output
                
                let height = image.size.height
                let width = image.size.width
                
                print(width)
                print(height)
                
                imv.image = image
                //barTextValue.text = stringValue
                qrCodeShowView.isHidden = true
                
            }
            
            
        }
        
        if Store.sharedInstance.shouldShowLabel {
            deductionValue = 70
            barLabelText.isHidden = false
            barLabelText.text = stringValue
        }
        else {
            deductionValue = 0
            barLabelText.isHidden = true
            barLabelText.text = ""
        }
        Store.sharedInstance.shouldShowLabel = false
        
        
        
        if isfromQr {
            if isfromUpdate {
                createDataModelArray = (UserDefaults.standard.object(forKey: "array\(idF)") as! [[String:String]]).map{ ResultDataModel(dictionary:$0) }
                var stringValue1 = "colora\(idF)"
                var stringValue2 = "colorb\(idF)"
                colora = UserDefaults.standard.color(forKey: stringValue1)!
                colorb = UserDefaults.standard.color(forKey: stringValue2)!
            }
            self.updateAll()
            
            
                     
            
            
        }
        
        
        if isfromUpdate {
            guard let data = UserDefaults.standard.data(forKey: "logo\(idF)") else { return }
            let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
            logo1 = UIImage(data: decoded)
            self.updateAll()
        }
        
    }
    
    
    
    @IBAction func gotoEditContent(_ sender: Any) {
        
        
        if let v =  eventF {
            let eventController = EKEventEditViewController()
            eventController.event = v
            eventController.editViewDelegate = self
            eventController.modalPresentationStyle = .fullScreen
            self.present(eventController, animated: true)
            return
        }
        
        
        
        
        
        if !isfromQr {
            createDataModelArray.removeAll()
            createDataModelArray.append(ResultDataModel(title: "Enter value", description: stringValue))
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditVc") as! EditVc
        vc.modalPresentationStyle = .fullScreen
        vc.createDataModelArray = createDataModelArray
        vc.delegate = self
        vc.currenttypeOfQrBAR = currenttypeOfQrBAR
        vc.isFromQr = isfromQr
        self.present(vc, animated: true)
        
        
    }
    
    func saveData() {
        
        
        
        if isfromUpdate {
            DBmanager.shared.updateTableData(id: idF, Text: stringValue, position: position1, shape: shape1, logo: currenttypeOfQrBAR)
            
            
            
        }
        else if isfromQr {
            
            if isFromScanned  {
                Store.sharedInstance.currentIndexPath = "1"
                DBmanager.shared.insertRecordIntoFile(Text: stringValue, codeType: "1", indexPath: "1",position: position1, shape: shape1, logo: currenttypeOfQrBAR)
            }
            else {
                Store.sharedInstance.currentIndexPath = "2"
                DBmanager.shared.insertRecordIntoFile(Text: stringValue, codeType: "1", indexPath: "2",position: position1, shape: shape1, logo: currenttypeOfQrBAR)
            }
        }
        else {
            
            if isFromScanned  {
                Store.sharedInstance.currentIndexPath = "1"
                DBmanager.shared.insertRecordIntoFile(Text: stringValue, codeType: "2", indexPath: "1",position: position1, shape: shape1, logo: currenttypeOfQrBAR)
            }
            else {
                Store.sharedInstance.currentIndexPath = "2"
                DBmanager.shared.insertRecordIntoFile(Text: stringValue, codeType: "2", indexPath: "2",position: position1, shape: shape1, logo: currenttypeOfQrBAR)
            }
        }
        
        DBmanager.shared.getMaxIdForRecord() { [weak self] id in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            var id = id
            
            print(idF)
            if idF.count > 0 {
                id  = Int(idF) ?? 0
            }
            
            
            let cfcpArray = createDataModelArray.map{ $0.dictionaryRepresentation}
            UserDefaults.standard.set(cfcpArray, forKey: "array\(id)")
            
            let fileName = "Image\(id)"
            
            if isfromQr {
                saveImageInDocumentDirectory(image: imv.image!, fileName: fileName)
            }
            else {
                if Store.sharedInstance.shouldShowLabel {
                    
                }
                else {
                    saveImageInDocumentDirectory(image: imv.image!, fileName: fileName)
                }
            }
            
            var stringValue = "colora\(id)"
            var stringValue1 = "colorb\(id)"
            
            UserDefaults.standard.set(colora, forKey: stringValue)
            UserDefaults.standard.set(colorb, forKey: stringValue1)
            
            if let v = logo1 {
                guard let data = v.jpegData(compressionQuality: 1.0) else { return }
                let encoded = try! PropertyListEncoder().encode(data)
                UserDefaults.standard.set(encoded, forKey: "logo\(id)")
            }
        }
        
       
        
        
    }
    
    @IBAction func gotoSve(_ sender: Any) {
        
    
        self.saveData()
        
        
        Store.sharedInstance.setPopValue(value: true)
        Store.sharedInstance.setShowHistoryPage(value: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sadiq"), object: nil)
       // self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        delegateDis?.dimissAllClass()
        
        
        let defaults = UserDefaults.standard
        
        var valueOfText  = defaults.integer(forKey: "no_of_image")
        
        let boolValue = UserDefaults.standard.bool(forKey: "given")
         
        
        if (valueOfText % 5 == 0 && boolValue == false) {
            
            let alertView = SwiftAlertView(title: "Rate ScannR App",
                                           message: "If you enjoy using ScannR App, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!",
                                           buttonTitles: ["Rate Example App", "Remind me later", "No, thank"])
            alertView.delegate = self
            alertView.transitionType = .vertical
            alertView.appearTime = 0.2
            alertView.disappearTime = 0.2
            alertView.show()
            UserDefaults.standard.set(valueOfText + 1, forKey:"no_of_image")
            return
        }
        
        else if( valueOfText % 5 == 0 && valueOfText < 30){
            
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        }
        
        UserDefaults.standard.set(valueOfText + 1, forKey:"no_of_image")
        self.dismiss(animated: true)
        
    }
    
    
    @IBAction func gotoShare(_ sender: Any) {
        
        let imageShare = [ imv.image! ]
        
        let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        widthForMainView.constant = imageviewHolder.frame.width
        heightForMainView.constant = imageviewHolder.frame.height - CGFloat(deductionValue)
        
        
        
        let size = AVMakeRect(aspectRatio: imv.image!.size, insideRect: imv.frame)
        widthForMainView.constant = size.width
        heightForMainView.constant = size.height
    }
    
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
        
        
        
        
        if stringValue.containsIgnoringCase(find: "geo") || stringValue.containsIgnoringCase(find: "vcalendar") {
            bnTextContent.isHidden = true
        }
        
        if stringValue.containsIgnoringCase(find: "WIFI") {
            
            bnTextContent.setTitle("Connect", for: .normal)
        }
        if stringValue.containsIgnoringCase(find: "tel") {
            bnTextContent.setTitle("Call", for: .normal)
        }
        if stringValue.containsIgnoringCase(find: "sms") {
            bnTextContent.setTitle("SMS", for: .normal)
        }
        if showText.containsIgnoringCase(find: "Url") {
            bnTextContent.setTitle("Go to Url", for: .normal)
        }
        
        if stringValue.containsIgnoringCase(find: "mailto") {
            bnTextContent.setTitle("Email", for: .normal)
        }
        
        if stringValue.containsIgnoringCase(find: "vcard") {
            bnTextContent.setTitle("Add to Contact", for: .normal)
        }
        
        if stringValue.containsIgnoringCase(find: "mecard") {
            bnTextContent.setTitle("Add to Contact", for: .normal)
        }
        
        
        
        
        if currenttypeOfQrBAR.containsIgnoringCase(find: "event") || currenttypeOfQrBAR.containsIgnoringCase(find: "location") {
            editContentView.isHidden =  true
        }
        
        if !isfromQr  {
            customizeView.isHidden =  true
            heightForView1.constant =  100
        }
        else {
            
            customizeView.isHidden =  false
            labelText.text = "QrCode Detail"
        }
        IHProgressHUD.dismiss()
        
        //Store.sharedInstance.image = image
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismiss(animated: true, completion: nil)

    }
    
    func sendEmail(subject:String?,mailAddress:String?,cc:String?,meessage:String?) {
           if MFMailComposeViewController.canSendMail() {
               let mail = MFMailComposeViewController()
               mail.mailComposeDelegate = self
               mail.modalPresentationStyle = .fullScreen
               if let mailAddressV = mailAddress
               {
                   mail.setToRecipients([mailAddressV])
               }
               if let meessageV = meessage
               {
                   mail.setMessageBody(meessageV, isHTML: false)
               }
               
               if let subjectV = subject
               {
                   mail.setSubject(subjectV)
               }
               if let cctV = cc
               {
                   mail.setCcRecipients([cctV])
               }
               
               present(mail, animated: true)
               
           } else {
               let alert = UIAlertController(title: "Note", message: "Email is not configured!", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "", message: "Check Your Internet!", preferredStyle: .alert)
            
             let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
             })
             alert.addAction(ok)
             DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
        })
        
    }
    
    
    @IBAction func copyText(_ sender: Any) {
        
        
        if stringValue.containsIgnoringCase(find: "vcard") {
            
            self.checkContactsAccess()
            return
        }
        
        if stringValue.containsIgnoringCase(find: "mecard") {
            
            
                contactCard = CNMutableContact()
                let value  = dict["vCard1"]
                var ar = value!.components(separatedBy: ",")  as? NSArray
                var array =  NSMutableArray(array: ar!) as! [String]
                var tempText = stringValue
                let maV = tempText.components(separatedBy: ";")
                tempText = tempText.replacingOccurrences(of: "mecard:", with: "")
                tempText = tempText.replacingOccurrences(of: "MECARD:", with: "")
                
                
                for item in maV {
                    if(item.containsIgnoringCase(find:MeCardCostant.KEY_NAME)) {
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_NAME, with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_NAME.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: "mecard:", with: "")
                        parsed = parsed.replacingOccurrences(of: "MECARD:", with: "")
                        let name = parsed.components(separatedBy: ",")
                        
                        
                        
                        if name.count == 1 {
                            array[0] = "First Name: " + name[0]
                            contactCard.givenName = name[0]
                            
                            print("yes")
                        }
                        
                        else if name.count == 2  {
                            array[0] = "First Name: " + name[1]
                            array[1] = "Last Name: " +  name[0]
                            
                            contactCard.givenName = name[1]
                            contactCard.familyName = name[0]
                            
                            print("yes1")
                        }
                    }
                    
                    if(item.containsIgnoringCase(find:MeCardCostant.KEY_TELEPHONE)) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_TELEPHONE.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_TELEPHONE.uppercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: "mecard:", with: "")
                        parsed = parsed.replacingOccurrences(of: "MECARD:", with: "")
                        
                        
                        if parsed.count >= 1 {
                            array[2] =  "Phone Number: " + parsed
                        }
                        
                        let phoneNumber = CNPhoneNumber(stringValue: array[2])
                        let labelled = CNLabeledValue(label: "TEL", value:  phoneNumber)
                        contactCard.phoneNumbers = [labelled]
                        
                    }
                    
                    if(item.containsIgnoringCase(find:MeCardCostant.KEY_EMAIL)) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_EMAIL.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_EMAIL.uppercased(), with: "")
                        
                        
                        if parsed.count >= 1 {
                            array[3] =  "Email: " + parsed
                        }
                        let workEmail = CNLabeledValue(label:"Work Email", value:array[2]  as NSString)
                        contactCard.emailAddresses = [workEmail]
                        
                    }
                    
                    if(item.containsIgnoringCase(find:MeCardCostant.KEY_URL)) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_URL.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_URL.uppercased(), with: "")
                        
                        
                        if parsed.count >= 1 {
                            array[4] =  "URL: " + parsed
                        }
                        
                        let URL = CNLabeledValue(label:"URL", value:array[4]  as NSString)
                        contactCard.urlAddresses = [URL]
                        
                        
                    }
                    
                    if(item.containsIgnoringCase(find:MeCardCostant.KEY_NICK_NAME)) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_NICK_NAME.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_NICK_NAME.uppercased(), with: "")
                        
                        
                        if parsed.count >= 1 {
                            array[5] =  "NickName: " + parsed
                        }
                        
                        contactCard.nickname = array[5]
                    }
                    
                    if(item.containsIgnoringCase(find:MeCardCostant.KEY_ADDRESS)) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_ADDRESS.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_ADDRESS.uppercased(), with: "")
                        
                        if parsed.count >= 1 {
                            array[6] =  "Address: " + parsed
                        }
                        
                        let address = CNMutablePostalAddress()
                        address.street =  array[6]
                        let home = CNLabeledValue<CNPostalAddress>(label:CNLabelHome, value:address)
                        contactCard.postalAddresses = [home]
                    }
                    
                    if item.containsIgnoringCase(find:MeCardCostant.KEY_ORG) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_ORG.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_ORG.uppercased(), with: "")
                        
                        if parsed.count >= 1 {
                            array[7] =  "Organization: " + parsed
                        }
                        
                        contactCard.organizationName = array[7]
                    }
                    
                    if item.containsIgnoringCase(find:MeCardCostant.KEY_NOTE) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_NOTE.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_NOTE.uppercased(), with: "")
                        
                        if parsed.count >= 1 {
                            array[8] =  "Note: " + parsed
                        }
                    }
                    
                    if item.containsIgnoringCase(find:MeCardCostant.KEY_DAY) {
                        
                        var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_DAY.lowercased(), with: "")
                        parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_DAY.uppercased(), with: "")
                        
                        if parsed.count >= 1 {
                            array[9] =  "Birthday: " + parsed
                        }
                        contactCard.note = array[7]
                    }
                }
            
            self.checkContactsAccess()
            return
        }
        
        
        if stringValue.containsIgnoringCase(find: "wifi") {
            
            var array = stringValue.components(separatedBy: ";")
            
            var name = ""
            var password = ""
            var type = ""
            
            for item in array {
                var mal = (item as? String)!.replacingOccurrences(of: "WIFI:", with: "", options: .literal, range: nil)
                mal = mal.replacingOccurrences(of: "wifi:", with: "", options: .literal, range: nil)
                
                if mal.containsIgnoringCase(find: "T:") {
                    
                    type =   mal.replacingOccurrences(of: "T:", with: "", options: .literal, range: nil)
                }
                
                if mal.containsIgnoringCase(find: "S:") {
                    
                    name =   mal.replacingOccurrences(of: "S:", with: "", options: .literal, range: nil)
                }
                if mal.containsIgnoringCase(find: "P:") {
                    
                    password =   mal.replacingOccurrences(of: "P:", with: "", options: .literal, range: nil)
                }
                 
            }
            
            
            NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: name)
            
            var valuem = false
            if type.containsIgnoringCase(find: "wep") {
                valuem = true
            }
            
            let wiFiConfig = NEHotspotConfiguration(ssid: name, passphrase: password, isWEP: valuem)
            wiFiConfig.joinOnce = true
            NEHotspotConfigurationManager.shared.apply(wiFiConfig) { error in
                if let error = error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                     }
                }
                else {
                    // user confirmed
                }
            }
            
            return
            
        }
        
       
        
        
        if stringValue.containsIgnoringCase(find: "mailto") {
            
            var email = ""
            var  cc = ""
            var  subject = ""
            var body = ""
            
            
            let array = showText.components(separatedBy: "\n\n")
            
            for item in array {
                
                if let v = item as? String {
                    
                    if v.containsIgnoringCase(find: "email") {
                        let ar = v.components(separatedBy: ":")
                        
                        if ar.count > 1 {
                            email = ar[1]
                        }
                        
                    }
                    
                    if v.containsIgnoringCase(find: "cc") {
                        let ar = v.components(separatedBy: ":")
                        
                        if ar.count > 1 {
                            cc = ar[1]
                        }
                    }
                    
                    if v.containsIgnoringCase(find: "subject") {
                        let ar = v.components(separatedBy: ":")
                        
                        if ar.count > 1 {
                            subject = ar[1]
                        }
                    }
                    
                    if v.containsIgnoringCase(find: "body") {
                        let ar = v.components(separatedBy: ":")
                        if ar.count > 1 {
                            body = ar[1]
                        }
                    }
                }
            }
             
            
            if currentReachabilityStatus == .notReachable {
                self.showAlert()
                return
            }
            
            self.sendEmail(subject: subject, mailAddress: email, cc: cc, meessage: body)
            return
        }
        
       
        
        if stringValue.containsIgnoringCase(find: "tel") {
            var phoneNumber = stringValue.replacingOccurrences(of: "tel", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: "TEL", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: "Tel", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: ":", with: "")
            phoneNumber = phoneNumber.trimmingCharacters(in: .whitespaces)
            self.dialNumber(number: phoneNumber)
            return
        }
        if stringValue.containsIgnoringCase(find: "SMS") {
            
            var sms = stringValue.replacingOccurrences(of: "sms", with: "")
            sms = sms.replacingOccurrences(of: "SMS", with: "")
            sms = sms.replacingOccurrences(of: "Sms", with: "")
            sms = sms.trimmingCharacters(in: .whitespaces)
            
            
            
            if let ar = sms.components(separatedBy: ":")  as? NSArray {
                
                if ar.count > 1 {
                    
                    if (MFMessageComposeViewController.canSendText()) {
                        let temp = (ar[1] as? String)!
                        var array:[String] = []
                        array.append(temp)
                        let controller = MFMessageComposeViewController()
                        controller.body = ar[2] as? String
                        controller.recipients =  [array[0]]
                        controller.messageComposeDelegate = self
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            }
            
           return
            
        }
        
        if showText.containsIgnoringCase(find: "url") {
            
            if currentReachabilityStatus == .notReachable {
                self.showAlert()
                return
            }
            
            guard let url = URL(string: stringValue) else {
                return //be safe
            }
            
            guard UIApplication.shared.canOpenURL(url) else {
                print("Can't open url!")
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            return
        }
        
        
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.string =  stringValue
        
        self.showToast(message: "Text has been copied to clipboard", font: .systemFont(ofSize: 12.0))
        
        
        
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        
        
        if isFromGallery {
            Store.sharedInstance.shouldShowHomeScreen = true
        }
        
        if isFromScanned  {
            
            if !isfromUpdate {
                
                let e = UserDefaults.standard.integer(forKey: "history")
                
                if e == 2 {
                    self.saveData()
                }
            }
        }
        Store.sharedInstance.showPickerT = true
        self.dismiss(animated: true)
    }
    
    func parseDataForVCard(result:String) {
        
    }
    
    func parseDataForMECard(result:String) {
        
    }
    
    func parseDataForBarCode() {
        
    }
    
}

extension ShowResultVc: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as!ExpandableCellTableViewCell
        cell.lbl.text = ""
        cell.lbl.text = showText
        
        print(showText)
        cell.selectionStyle = .none
        cell.lbl.textColor  = UIColor.black
        return cell
    }
}
extension ShowResultVc: SwiftAlertViewDelegate {
    func alertView(_ alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if(buttonIndex == 0) {
            
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
        }
        
        self.dismiss(animated: true)
        UserDefaults.standard.set(false, forKey: "given")
    }

    func didPresentAlertView(alertView: SwiftAlertView) {
        print("Did Present Alert View\n")
    }

    func didDismissAlertView(alertView: SwiftAlertView) {
        print("Did Dismiss Alert View\n")
    }
    
     
}

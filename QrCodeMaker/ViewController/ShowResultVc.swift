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
        
        doc.design.foregroundColor(colora.cgColor)
        doc.design.backgroundColor(colorb.cgColor)
        
        let path = doc.path(CGSize(width: 1000, height: 1000))
        let image = doc.uiImage(CGSize(width: 1000, height: 1000), dpi: 216)
        imv.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(showText)
        
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
    @IBAction func gotoSve(_ sender: Any) {
        
        
        DBmanager.shared.initDB()
        
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
        
        var id = DBmanager.shared.getMaxIdForRecord()
        
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
        
        
        
        Store.sharedInstance.setPopValue(value: true)
        Store.sharedInstance.setShowHistoryPage(value: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sadiq"), object: nil)
       // self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
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
        
        
        //DBmanager.shared.initDB()
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
        
        print(stringValue)
        if stringValue.containsIgnoringCase(find: "tel") {
            bnTextContent.setTitle("Call", for: .normal)
        }
        if stringValue.containsIgnoringCase(find: "sms") {
            bnTextContent.setTitle("Sms", for: .normal)
        }
        if showText.containsIgnoringCase(find: "Url") {
            bnTextContent.setTitle("Go to Url", for: .normal)
        }
        
        if stringValue.containsIgnoringCase(find: "mailto") {
            bnTextContent.setTitle("Email", for: .normal)
        }
        
        
        
        
        if currenttypeOfQrBAR.containsIgnoringCase(find: "event") || currenttypeOfQrBAR.containsIgnoringCase(find: "location") {
            editContentView.isHidden =  true
        }
        
        if !isfromQr  {
            customizeView.isHidden =  true
        }
        else {
            
            customizeView.isHidden =  false
            labelText.text = "QrCode Detail"
        }
        IHProgressHUD.dismiss()
        
        //Store.sharedInstance.image = image
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
               let alert = UIAlertController(title: "Note", message: "Email is not configured", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
    
    @IBAction func copyText(_ sender: Any) {
        
        if showText.containsIgnoringCase(find: "url") {
            guard let url = URL(string: stringValue) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
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
             
            
            self.sendEmail(subject: subject, mailAddress: email, cc: cc, meessage: body)
            
        }
        
        if stringValue.containsIgnoringCase(find: "tel") {
            var phoneNumber = stringValue.replacingOccurrences(of: "tel", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: "TEL", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: "Tel", with: "")
            phoneNumber = phoneNumber.replacingOccurrences(of: ":", with: "")
            phoneNumber = phoneNumber.trimmingCharacters(in: .whitespaces)
            self.dialNumber(number: phoneNumber)
            
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
            
            print(sms)
            
        }
        
        
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        
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

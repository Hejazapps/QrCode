//
//  Constant.swift
//  NewQrCode
//
//  Created by Mehedi on 4/24/21.
//

import UIKit
import Contacts
import ZXingObjC
import RSBarcodes_Swift
import CDCodabarView





//MARK: Result Data Provider
class Constant: NSObject {
    
    static func getTypeFromRawValue(rawValue: Int) -> String {
        var type = ""
        switch rawValue {
        case 0:
            type = "FORMAT_ALL_FORMATS"
            break
        case 4096:
            type = "FORMAT_AZTEC"
            break
        case 8:
            type = "FORMAT_CODABAR"
            break
        case 1:
            type = "FORMAT_CODE_128"
            break
        case 2:
            type = "FORMAT_CODE_39"
            break
        case 4:
            type = "FORMAT_CODE_93"
            break
        case 16:
            type = "FORMAT_DATA_MATRIX"
            break
        case 32:
            type = "FORMAT_EAN_13"
            break
        case 64:
            type = "FORMAT_EAN_8"
            break
        case 128:
            type = "FORMAT_ITF"
            break
        case 2048:
            type = "FORMAT_PDF417"
            break
        case 256:
            type = "QrCode"
            //            switch valueType {
            //            case .wiFi:
            //               type = "Wifi"
            //                break
            //            case .URL:
            //                type = "Url"
            //                break
            //            case .ISBN:
            //               type = "ISBN"
            //               break
            //            case .SMS:
            //               type = "SMS"
            //               break
            //            case .email:
            //                type = "Email"
            //                break
            //            case .phone:
            //                type = "Phone"
            //                break
            //            case .product:
            //                type = "Product"
            //                break
            //            case .text:
            //                type = "Text"
            //            case .unknown:
            //                type = "Unknown"
            //            default:
            //                type = "QrCode"
            //                break
            //            // See API reference for all supported value types
            //            }
            break
        case -1:
            type = "FORMAT_UNKNOWN"
            break
        case 512:
            type = "FORMAT_UPC_A"
            break
        case 1024:
            type = "FORMAT_UPC_E"
            break
        case 11:
            type = "TYPE_CALENDAR_EVENT"
            break
        case 12:
            type = "TYPE_DRIVER_LICENSE"
            break
        case 2:
            type = "TYPE_EMAIL"
            break
        case 10:
            type = "TYPE_GEO"
            break
        case 3:
            type = "TYPE_ISBN"
            break
        case 4:
            type = "TYPE_PHONE"
            break
        case 5:
            type = "TYPE_PRODUCT"
            break
        case 6:
            type = "TYPE_SMS"
            break
        case 7:
            type = "TYPE_TEXT"
            break
        case 8:
            type = "TYPE_URL"
            break
        case 9:
            type = "TYPE_WIFI"
            break
        default:
            print("Not Found")
        }
        return type
    }
    
}

//MARK: Get All QR Code Data In ResultDataModel Formate
 
//MARK: Get Title of Type
extension Constant {
    
    static func getUrlType(isforTitle: Bool, string: String) -> String{
        
        if string.contains("sms") || string.contains("Sms") || string.contains("SMS") {
            if isforTitle {
                
                return "SMS"
            }else{
                
                return "SMS:"
            }
        }
        
        if string.contains("facebook") || string.contains("Facebook") || string.contains("FACEBOOK") {
            if isforTitle {
                return "Facebook"
            }else{
                return "Facebook Link:"
            }
        }
        
        if string.contains("instagram") || string.contains("Instagram") || string.contains("INSTAGRAM") {
            if isforTitle {
                return "Instagram"
            }else{
                return "Instagram ID:"
            }
        }
        
        if string.contains("app") || string.contains("App") || string.contains("APP") {
            
            if isforTitle {
                return "App Store"
            }else{
                return "App Store App Link:"
            }
        }
        
        if string.contains("twitter") || string.contains("Twitter") || string.contains("TWITTER") {
            if isforTitle {
                return "Twitter"
            }else{
                return "Twitter ID:"
            }
            
        }
        
        if string.contains("map") || string.contains("Map") || string.contains("MAP") {
            
            if isforTitle {
                return "Goole Map Location"
            }else{
                return "Goole Map Location Link:"
            }
        }
        
        if string.contains("google") || string.contains("Google") || string.contains("GOOGLE") || string.contains("http") || string.contains("Http") || string.contains("HTTP"){
            if isforTitle {
                return "URL"
            }else{
                return "Link:"
            }
        }
        
        return "Not Match"
    }
}

//MARK: Get Data From String In ResultDataModel Format

extension Constant {
    
    static func getVNData(result: String) -> [ResultDataModel]{
        print("Result  ", result)
        var contacts:[CNContact] = []
        
        if let data = result.data(using: .utf8) {
            do{
                contacts = try CNContactVCardSerialization.contacts(with: data)
                print("Contacts  ", contacts)
                let contact = contacts.first
                print("\(String(describing: contact?.familyName))")
            }
            catch{
                // Error Handling
                print(error.localizedDescription)
            }
            return self.extractQrCodeDataFromVCard(text: result, contacts: contacts)
        }
        return [ResultDataModel]()
    }
    
    static fileprivate func extractQrCodeDataFromVCard(text: String, contacts: [CNContact]) -> [ResultDataModel] {
        //var currentType: String?
        var result = [ResultDataModel]()
        
        let dict = ["Image": "Enter Link/Text,Select an Image","Email": "Enter Email Address,CC,Subject,Email Body", "Url": "Enter Url","Phone": "Enter Phone Number","SMS": "Enter Phone Number,Enter Message","Text":"Enter Text","vCard": "First Name, Last Name,Phone,Email, Url,NickName, Address, Organization, city, jobTitle, Street, Zip, State, Country, Website","Facebook": "Enter FaceBook Link","Instagram": "Enter Instagram Id","Twitter": "Enter Twitter Id","Skype": "Enter Skype Id","Calendar": "EventName,EvenLocation,Note","Google Map Location": "Enter Location Link","AppStore": "Enter AppStore Link","BarCode":"Text"]
        var array:[String] = []
        
        
        if text.contains("VCARD") {
            // currentType = "VCARD"
            let value  = dict["vCard"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            print("WH  ", ar)
            array =  NSMutableArray(array: ar!) as! [String]
            let contact = contacts.first
            var mailValue = "Email: "
            if let emailAddresses = contact?.emailAddresses{
                for mail in emailAddresses {
                    
                    var value1 =  String(describing: mail.value)
                    mailValue = mailValue +  value1
                    mailValue = mailValue + " "
                }
            }
            
            
            
            
            if let postalAddresses = contact?.postalAddresses{
                
                if let firstName  = contact?.givenName {
                    if firstName.count > 0 {
                        array[0] = "First Name: " + firstName
                    }
                }
                
                if let familyname  = contact?.familyName
                {
                    if familyname.count > 0 {
                        array[1] =  "Last Name: " + familyname
                    }
                }
                
                var phoneValue = "Phone No: "
                
                if let phoneNumbers = contact?.phoneNumbers
                {
                    var i = 0
                    for phoneNumber in  phoneNumbers{
                        i += 1
                        phoneValue = phoneValue + phoneNumber.value.stringValue
                        phoneValue = phoneValue + (phoneNumbers.count != i ? ", ": "" )
                    }
                    let phoneNumbers: [String] = contact!.phoneNumbers.compactMap { (phoneNumber: CNLabeledValue) in
                        guard let number = phoneNumber.value.value(forKey: "digits") as? String else { return nil }
                        return number
                    }
                    
                }
                
                if phoneValue.count > 0 {
                    array[2]  = phoneValue
                }
                if mailValue.count > 0 {
                    array[3]  = mailValue
                }
                
                
                let notesValue = contact?.note
                let notesValueS = "Notes: " + (notesValue ?? "")
                array[4]  = notesValueS
                
                
                if let nickName = contact?.nickname{
                    if nickName.count > 0 {
                        array[5]  = "NickName: " + nickName
                    }
                }
                
                if let orginization = contact?.organizationName
                {
                    if orginization.count > 0 {
                        array[6] = "Organization: " + orginization
                    }
                }
                
                
                var jobValue = "Job Title: "
                if let job = contact?.jobTitle{
                    
                    jobValue =  jobValue + job
                    array[7] = jobValue
                }
                
                
                var address = "Address: "
                for add in postalAddresses{
                    
                    address = address +  add.value.street
                    address = address + " "
                    
                    if let addressString = (((add as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value")) as? CNPostalAddress {
                        let mailAddress = CNPostalAddressFormatter.string(from:addressString, style: .mailingAddress)
                        array[8] = "Street: " + addressString.street
                        array[9] = "City: " + addressString.city
                        array[10] = "Zip: " + addressString.postalCode
                        array[11] = "State: " + addressString.state
                        array[12] = "Country: " + addressString.country
                    }
                    
                }
            }
            
            
            //  print("Info  ", contact?.contactType,"  ", contact?.departmentName,"   ", contact?.jobTitle,"  ", contact?.phoneticOrganizationName)
            
            
            var webValue = "Website: "
            if let webAddresses = contact?.urlAddresses{
                for web in webAddresses {
                    
                    let value =  String(describing: web.value)
                    webValue = webValue +  value
                    webValue = webValue + " "
                }
                array[13] = webValue
            }
            
            
        }
        
        let topTitle = "Qr-Code Type:"
        let topDesription = "VCard"
        result.append(ResultDataModel(title: topTitle, description: topDesription))
        
        for data in array {
            var now = data.components(separatedBy: ":")
            let t = now.first
            now.removeFirst()
            let d = now.first
            if t != nil && d != nil {
                result.append(ResultDataModel(title: t!, description: d!))
            }
        }
        print("ArrayResult  ", array)
        return result
    }
    
    func isdigit(value:String)->Bool{
        if value == "+"{
            return true
        }
        if value >= "0" && value <= "9" {
            return true
        }
        return false
    }
    
    
    
    static func getQrDataFromGalleryForCalender(text: String) -> [ResultDataModel] {
        print("Text  ", text)
        
        var calendarValue: MXLCalendar!
        let calendarManager = MXLCalendarManager()
        calendarManager.parse(icsString: text) { (calendar, error) in
            calendarValue = calendar
        }
        
        let dict = ["Image": "Enter Link/Text,Select an Image","Email": "Enter Email Address,CC,Subject,Email Body", "Url": "Enter Url","Phone": "Enter Phone Number","SMS": "Enter Phone Number,Enter Message","Text":"Enter Text","vCard":"First Name,Last Name,Phone,Email,Url,NickName,Address,Organization","Facebook": "Enter FaceBook Link","Instagram": "Enter Instagram Id","Twitter": "Enter Twitter Id","Skype": "Enter Skype Id","Calendar": "EventName,EvenLocation,Note","Google Map Location": "Enter Location Link","AppStore": "Enter AppStore Link","BarCode":"Text"]
        
        var array = [ResultDataModel]()
        if text.contains("VCALENDAR") {
            
            //            titleLabelF.text = " Type: " + currentType
            //            currentType = "VCALENDAR"
            let value  = dict["Calendar"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            var array =  NSMutableArray(array: ar!) as! [String]
            
            if let eventName = calendarValue.events[0].eventSummary
            {
                array[0] =  "Name: " + eventName
            }
            
            if let eventLocal = calendarValue.events[0].eventLocation
            {
                array[1] =  "Location: " + eventLocal
            }
            
            if let eventNote = calendarValue.events[0].eventDescription
            {
                array[2] =  "Note: " + eventNote
            }
            print("Array Calender  ", array)
        }
        
        return array
    }
    
    static func getQrDataFromMECard(text: String) -> [ResultDataModel] {
        print("MeCard  ", text)
        var tempText = text
        let maV = tempText.components(separatedBy: ";")
        tempText = tempText.replacingOccurrences(of: "mecard:", with: "")
        tempText = tempText.replacingOccurrences(of: "MECARD:", with: "")
        var result = [ResultDataModel]()
        
        let dict = ["Image": "Enter Link/Text,Select an Image",
                    "Email": "Enter Email Address,CC,Subject,Email Body", "Url": "Enter Url",
                    "Phone": "Enter Phone Number","SMS": "Enter Phone Number,Enter Message",
                    "Text": "Enter Text",
                    "vCard": "First Name,Last Name,Phone,Email,Url,NickName,Address,Organization","Facebook": "Enter FaceBook Link",
                    "Instagram": "Enter Instagram Id",
                    "Twitter": "Enter Twitter Id",
                    "Skype": "Enter Skype Id",
                    "Calendar": "EventName,EvenLocation,Note",
                    "Google Map Location": "Enter Location Link",
                    "AppStore": "Enter AppStore Link",
                    "BarCode":"Text"]
        
        // var array = [ResultDataModel]()
        if text.containsIgnoringCase(find: "MECARD"){
            //currentType = "MECARD"
            let value  = dict["vCard"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            var array =  NSMutableArray(array: ar!) as! [String]
            
            for item in maV
            {  print("Item  ", item,"   ::   ", (item.containsIgnoringCase(find:MeCardCostant.KEY_NAME)))
                
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_NAME))
                {
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_NAME, with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_NAME.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: "mecard:", with: "")
                    parsed = parsed.replacingOccurrences(of: "MECARD:", with: "")
                    let name = parsed.components(separatedBy: ",")
                    print("Parse  ", parsed.count,"  **   ", parsed)
                    if(name.count == 1)
                    {
                        array[0] = "First Name: " + name[0]
                        //contactCard.givenName = name[0]
                    }
                    else if(name.count == 2)
                    {
                        array[0] = "First Name: " + name[1]
                        array[1] = "Last Name: " +  name[0]
                    }
                }
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_TELEPHONE))
                {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_TELEPHONE.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_TELEPHONE.uppercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: "mecard:", with: "")
                    parsed = parsed.replacingOccurrences(of: "MECARD:", with: "")
                    
                    
                    if(parsed.count >= 1)
                    {
                        array[3] =  "Phone Number: " + parsed
                    }
                    let phoneNumber = CNPhoneNumber(stringValue: array[3])
                    let labelled = CNLabeledValue(label: "TEL", value:  phoneNumber)
                    // contactCard.phoneNumbers = [labelled]
                    
                    
                }
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_EMAIL))
                {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_EMAIL.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_EMAIL.uppercased(), with: "")
                    
                    
                    if(parsed.count >= 1)
                    {
                        array[3] =  "Email: " + parsed
                    }
                    let workEmail = CNLabeledValue(label:"Work Email", value:array[2]  as NSString)
                    //contactCard.emailAddresses = [workEmail]
                    
                    
                }
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_URL))
                {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_URL.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_URL.uppercased(), with: "")
                    
                    
                    if(parsed.count >= 1)
                    {
                        array[4] =  "URL: " + parsed
                    }
                    let URL = CNLabeledValue(label:"URL", value:array[4]  as NSString)
                    // contactCard.urlAddresses = [URL]
                    
                    
                }
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_NICK_NAME))
                {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_NICK_NAME.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_NICK_NAME.uppercased(), with: "")
                    
                    
                    if(parsed.count >= 1 )
                    {
                        array[5] =  "NickName: " + parsed
                    }
                    //contactCard.nickname = array[5]
                }
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_ADDRESS))
                {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_ADDRESS.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_ADDRESS.uppercased(), with: "")
                    
                    if(parsed.count >= 1)
                    {
                        array[6] =  "Address: " + parsed
                    }
                    let address = CNMutablePostalAddress()
                    address.street =  array[6]
                    let home = CNLabeledValue<CNPostalAddress>(label:CNLabelHome, value:address)
                    //contactCard.postalAddresses = [home]
                }
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_ORG))
                {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_ORG.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_ORG.uppercased(), with: "")
                    
                    if(parsed.count >= 1)
                    {
                        array[7] =  "Organization: " + parsed
                    }
                    //  contactCard.organizationName = array[7]
                }
                
            }
            
            let topTitle = "Qr-Code Type:"
            let topDesription = "MeCard"
            result.append(ResultDataModel(title: topTitle, description: topDesription))
            
            for data in array {
                var now = data.components(separatedBy: ":")
                let t = now.first
                now.removeFirst()
                let d = now.first
                if t != nil && d != nil {
                    result.append(ResultDataModel(title: t!, description: d!))
                }
            }
        }
        // print("Arra  ", result)
        return result
    }
}


 

//MARK: Create Data Provider
extension Constant {
    
    static func getBarCodeCrateVcImageArrayForCollectionView() -> ([String], [UIImage]) {
        let barCodeName = ["1.Ean-13", "2.Ean-8", "3.UPC-A", "4.UPC-E","5.Code-128", "6.Code-39", "7.ITF", "8.Codabar", "10.AztecCode", "11.PDF-417"]
        
        var barCodeImage = [UIImage]()
        for bName in barCodeName {
            barCodeImage.append(UIImage(named: bName)!)
        }
        return (barCodeName, barCodeImage)
    }
    
    static func getQrCodeCrateVcImageArrayForCollectionView() -> ([String], [UIImage]){
        
        let qrCodeName = ["1.Url", "2.Email", "3.Phone", "4.Sms", "5.Text", "6.vCard", "7.Facebook", "8.Instagram", "9.Twitter", "10.Calendar", "11.EmailAddress", "12.AppStore", "13.GoogleMap"]
        
        var qrCodeImage = [UIImage]()
        for qName in qrCodeName {
            qrCodeImage.append(UIImage(named: qName)!)
        }
        return (qrCodeName, qrCodeImage)
    }
    
    static func getInputCratePerameterDict() -> Dictionary<String, String> {
        let dict = ["Image": "Enter Link/Text,Select an Image",
                    "Email": "Enter Email Address,CC,Subject,Email Body",
                    "Url": "Enter Url",
                    "Phone": "Enter Phone Number",
                    "SMS": "Enter Phone Number,Enter Message",
                    "Text": "Enter Text",
                    "vCard": "First Name,Last Name,Phone,Email,Url,NickName,Address,Organization",
                    "Facebook": "Enter FaceBook Link",
                    "Instagram": "Enter Instagram Id",
                    "Twitter": "Enter Twitter Id",
                    "Skype": "Enter Skype Id",
                    "Calendar": "EventName, EvenLocation, Note",
                    "GoogleMap": "Enter Location Link",
                    "AppStore": "Enter AppStore Link",
                    "BarCode":"Text"]
        return dict
    }
    
    static func removeNumbering(string: String) -> String {
        var temp = string
        
        for ch in temp {
            temp.removeFirst()
            if ch == "."{
                break
            }
        }
        return temp
    }
    
    static func getInputParemeterByType(type: String) -> [CreateDataModel] {
        var array = [CreateDataModel]()
        
        switch type {
        case "MECARD":
            return self.getMECARDParemeter()
        case "Wechat":
            return self.getWechat()
        case "Snapchat":
            return self.getWechat()
        case "TikTok":
            return self.getSpotify()
        case "Google Plus":
            return self.getGoogePlus()
        case "DuckDuck Go":
            return self.getDuckDuckGo()
        case "Box":
            return self.getBox()
        case "One Drive":
            return self.getOneDrive()
        case "Flickr":
            return self.geFlickr()
        case "WhatsApp":
            return self.getWhatsapp()
        case "Viber":
            return self.getViber()
        case "Bing Search":
            return self.getBingSearch()
        case "Google Search":
            return self.getGoogleSearch()
        case "MMS":
            return self.getMMS()
        case "BarCode":
            return self.getBarCode()
        case "Pinterest":
            return self.getPinerest()
        case "Youtube Video":
            return self.getYoutubeVideo()
        case "Tumblr":
            return self.tumblrLink()
        case "LinkedIn":
            return self.getLinkedinUrl()
        case "Youtube":
            return self.getYoutubeLink()
        case "Google Drive":
            return self.getGoogleDrive()
        case "Yahoo":
            return self.getYahooLink()
        case "Linkedin":
            return self.getLinkedinUrl()
        case "Dropbox":
            return self.getDropBoxParameter()
        case "Email":
            return self.getMailParemeter()
        case "EmailAddress":
            return self.getMailAddressParemeter()
        case "Wifi":
            return self.getWifiParemeter()
        case "Website":
            return self.getUrlParemeter()
        case "Phone Number":
            return self.getPhoneParemeter()
        case "Sms":
            return self.getSMSParemeter()
        case "Text":
            return self.getTextParemeter()
        case "Vcard":
            return self.getvCardParemeter()
        case "Mecard":
            return self.getvCardParemeter()
        case "Facebook":
            return self.getFacebookParemeter()
        case "Instagram":
            return self.getInstagramParemeter()
        case "Twitter":
            return self.getTwitterParemeter()
        case "Skype":
            return self.getSkypeParemeter()
        case "Calendar":
            return self.getCalenderParemeter()
        case "GoogleMap":
            return self.getGoogleMapParemeter()
        case "App Store":
            return self.getAppStoreParemeter()
        case "iCloud":
            return self.getIcloudLink()
        case "Youtube":
            return self.getYoutubeLink()
        case "Ean-13":
            return self.getEan_13_BarCodeParemeter()
        case "Ean-8":
            return self.getEan_8_BarCodeParemeter()
        case "UPC-A":
            return self.getUPC_A_BarCodeParemeter()
        case "UPC-E":
            return self.getUPC_E_BarCodeParemeter()
        case "Code-128":
            return self.getCode_128_BarCodeParemeter()
        case "Code-39":
            return self.getCode_39_BarCodeParemeter()
        case "ITF":
            return self.getITFBarCodeParemeter()
        case "Codabar":
            return self.getCodabarBarCodeParemeter()
        case "DataMatrix":
            return self.getDataMatrixBarCodeParemeter()
        case "AztecCode":
            return self.getAztecCodeBarCodeParemeter()
        case "PDF-417":
            return self.getPDF_417_BarCodeParemeter()
        default:
            return array
            
        }
    }
    
    static func getBox()-> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter fields",text: "https://www.box.com/home",height: 110))
        return array
    }
    
    static func getDuckDuckGo()-> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter fields",text: "",height: 110))
        return array
    }
    
    static func getSpotify()-> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter link",text: "https://www.tiktok.com/",height: 110))
        return array
    }
    
    static func getWechat()-> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter profile link",text: "",height: 110))
        return array
    }
    
    
    static func getGoogePlus()-> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter fields",text: "https://plus.google.com/",height: 110))
        return array
    }
    
    static func getOneDrive()-> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter fields",text: "https://www.onedrive.live.com",height: 110))
        return array
    }
    //QrCode
    static func getMailParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Email Address:", height: 110))
        array.append(CreateDataModel(title: "Cc:", height: 110))
        array.append(CreateDataModel(title: "Subject:", height: 110))
        array.append(CreateDataModel(title: "Body:", height: 300))
        return array
    }
    
    static func getDropBoxParameter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter fields",text: "https://www.dropbox.com/",height: 110))
        return array
    }
    
    static func getMailAddressParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Email Address:", height: 110))
        return array
    }
    
    static func getWifiParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Network Name:", height: 110))
        array.append(CreateDataModel(title: "Password:", height: 110))
        array.append(CreateDataModel(title: "Encription:", height: 110))
        array.append(CreateDataModel(title: "Hidden:", height: 110))
        return array
    }
    
    static func getUrlParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Link:", height: 110))
        return array
    }
    
    
    static func geFlickr() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter fields",text: "https://www.flickr.com/",height: 110))
        return array
    }
    
    static func getGoogleSearch() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter search item:", height: 110))
        return array
    }
    
    static func getBingSearch() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter search item:", height: 110))
        return array
    }
    
    static func getViber() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter number:", height: 110))
        return array
    }
    
    static func getWhatsapp() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter number:", height: 110))
        return array
    }
    
    static func getPhoneParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Phone Number:", height: 110))
        return array
    }
    
    static func getSMSParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Phone Number:", height: 110))
        array.append(CreateDataModel(title: "Message:", height: 400))
        return array
    }
    
    static func getTextParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter Text:", height: 400))
        return array
    }
    
    static func getvCardParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "First Name:", height: 110))
        array.append(CreateDataModel(title: "Last Name:", height: 110))
        array.append(CreateDataModel(title: "Mobile:", height: 110))
        array.append(CreateDataModel(title: "Phone:", height: 110))
        array.append(CreateDataModel(title: "Fax:", height: 110))
        array.append(CreateDataModel(title: "Email:", height: 110))
        array.append(CreateDataModel(title: "Company:", height: 110))
        array.append(CreateDataModel(title: "Your Job:", height: 110))
        array.append(CreateDataModel(title: "Street:", height: 110))
        array.append(CreateDataModel(title: "City:", height: 110))
        array.append(CreateDataModel(title: "Zip:", height: 110))
        array.append(CreateDataModel(title: "State:", height: 110))
        array.append(CreateDataModel(title: "Country:", height: 110))
        array.append(CreateDataModel(title: "Website:", height: 110))
        return array
    }
    
    static func getMECARDParemeter() -> [CreateDataModel] {
        
       
        
        
        
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "First Name:", height: 110))
        array.append(CreateDataModel(title: "Last Name:", height: 110))
        array.append(CreateDataModel(title: "Phone:", height: 110))
        array.append(CreateDataModel(title: "Email:", height: 110))
        array.append(CreateDataModel(title: "Url:", height: 110))
        array.append(CreateDataModel(title: "Nick Name:", height: 110))
        array.append(CreateDataModel(title: "Address:", height: 110))
        array.append(CreateDataModel(title: "Organization:", height: 110))
        array.append(CreateDataModel(title: "Note:", height: 180))
        array.append(CreateDataModel(title: "Birthday:", height: 110))
        return array
    }
    
    static func getFacebookParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Facebook Link", text: "https://www.facebook.com/", height: 110))
        return array
    }
    
    static func getInstagramParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Instagram ID:", text: "https://www.instagram.com/", height: 110))
        return array
    }
    
    static func getTwitterParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Twitter ID:", text: "https://www.twitter.com/", height: 110))
        return array
    }
    
    static func getSkypeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Skype ID:", text: "https://www.skype.com/", height: 110))
        return array
    }
    
    static func getCalenderParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Title:", height: 110))
        array.append(CreateDataModel(title: "Start Time:", height: 110))
        array.append(CreateDataModel(title: "End Time:", height: 110))
        array.append(CreateDataModel(title: "Location:", height: 110))
        array.append(CreateDataModel(title: "Description:", height: 300))
        return array
    }
    
    static func getGoogleMapParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Google Map Location:", height: 110))
        return array
    }
    
    static func getAppStoreParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "App Store App Link:", text: "https://www.apple.com/", height: 110))
        return array
    }
    
    static func getIcloudLink() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Icloud link:", text: "https://www.icloud.com/", height: 110))
        return array
    }
    
    static func getYoutubeLink() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Youtube link:", text: "https://www.youtube.com/", height: 110))
        return array
    }
    
    static func getGoogleDrive() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Link:", text: "https://drive.google.com/", height: 110))
        return array
    }
    
    static func getPinerest() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Link:", text: "https://www.pinterest.com/", height: 110))
        return array
    }
    
    static func getYoutubeVideo() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "EnterYoutube Id:", text: "", height: 110))
        return array
    }
    
    
    static func getMMS() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter Number:", text: "", height: 110))
        array.append(CreateDataModel(title: "Enter Subject:", text: "", height: 110))
        array.append(CreateDataModel(title: "Enter Message:", text: "", height: 230))
        return array
    }
    
    static func getBarCode() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Enter Code:", text: "", height: 110))
        return array
    }
    
    static func tumblrLink() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "link:", text: "https://www.tumblr.com/", height: 110))
        return array
    }
    
    static func linkedin() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "link:", text: "https://www.linkedin.com/", height: 110))
        return array
    }
    
    static func getYahooLink() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Link:", text: "https://www.yahoo.com/", height: 110))
        return array
    }
    
    static func getLinkedinUrl() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Linkedin id:", text: "", height: 110))
        return array
    }
    
    static func getBarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Barcode:", height: 110))
        return array
    }
    
    //MARK: BarCode
    static func getEan_8_BarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Ean-8:", height: 110))
        return array
    }
    
    //MARK: BarCode
    static func getEan_13_BarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Ean-13:", height: 110))
        return array
    }
    
    static func getUPC_A_BarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "UPC-A:", height: 110))
        return array
    }
    
    static func getUPC_E_BarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "UPC-E:", height: 110))
        return array
    }
    
    static func getCode_128_BarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Code-128:", height: 110))
        return array
    }
    
    static func getCode_39_BarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Code-39:", height: 110))
        return array
    }
    
    static func getITFBarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "ITF:", height: 110))
        return array
    }
    
    static func getCodabarBarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Codabar:", height: 110))
        return array
    }
    
    static func getDataMatrixBarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "DataMatrix:", height: 110))
        return array
    }
    
    static func getAztecCodeBarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "Aztec:", height: 110))
        return array
    }
    
    static func getPDF_417_BarCodeParemeter() -> [CreateDataModel] {
        var array = [CreateDataModel]()
        array.append(CreateDataModel(title: "PDF-417:", height: 110))
        return array
    }
    
}

extension Constant {
    
    static func createQrCode_BarCodeByType(type: String, modelArray: [ResultDataModel], complation: @escaping ((CNMutableContact?, String?)->Void)) {
        //var array = [CreateDataModel]()
        print("Typeeeee  ", type)
        switch type {
        case "MECARD":
            let ans = self.createMeCARD(modelArray: modelArray)
            complation(nil, ans)
        case "Wechat":
            let ans = self.createWEchat(modelArray: modelArray)
            complation(nil, ans)
        case "Snapchat":
            let ans = self.createsnap(modelArray: modelArray)
            complation(nil, ans)
        case "TikTok":
            let ans = self.createSpotify(modelArray: modelArray)
            complation(nil, ans)
        case "Google Plus":
            let ans = self.createGooglePlus(modelArray: modelArray)
            complation(nil, ans)
        case "DuckDuck Go":
            let ans = self.getDuckDuckGo(modelArray: modelArray)
            complation(nil, ans)
        case "Box":
            let ans = self.createBox(modelArray: modelArray)
            complation(nil, ans)
        case "One Drive":
            let ans = self.createOneDrive(modelArray: modelArray)
            complation(nil, ans)
        case "Flickr":
            let ans = self.createFlickr(modelArray: modelArray)
            complation(nil, ans)
        case "WhatsApp":
            let ans = self.createWhatsapp(modelArray: modelArray)
            complation(nil, ans)
        case "Viber":
            let ans = self.createViber(modelArray: modelArray)
            complation(nil, ans)
        case "EAN-13":
            let ans = self.createEan13(modelArray: modelArray)
            complation(nil, ans)
        case "Google Search":
            let ans = self.createGoogleSearch(modelArray: modelArray)
            complation(nil, ans)
            
        case "MMS":
            let ans = self.createMMSS(modelArray: modelArray)
            complation(nil, ans)
            
        case "EAN-8":
            let ans = self.createEan8(modelArray: modelArray)
            complation(nil, ans)
        case "UPC-E":
            let ans = self.createUPCE(modelArray: modelArray)
            complation(nil, ans)
            
        case "Pinterest":
            let ans = self.createPinerest(modelArray: modelArray)
            complation(nil, ans)
        case "Google Drive":
            let ans = self.createGoogleDrive(modelArray: modelArray)
            complation(nil, ans)
        case "Tumblr":
            let ans = self.createTumbr(modelArray: modelArray)
            complation(nil, ans)
            
        case "App Store":
            let ans = self.createAppStore(modelArray: modelArray)
            complation(nil, ans)
        
        case "Youtube Video":
            let ans = self.createYoutubeVideo(modelArray: modelArray)
            complation(nil, ans)
            
            
        case "LinkedIn":
            let ans = self.createLinkedin(modelArray: modelArray)
            complation(nil, ans)
            
        case "Youtube":
            let ans = self.createYoutube(modelArray: modelArray)
            complation(nil, ans)
        case "Yahoo":
            let ans = self.createYahoo(modelArray: modelArray)
            complation(nil, ans)
        case "Linkedin":
            let ans = self.linkedinUrl(modelArray: modelArray)
            complation(nil, ans)
        case "iCloud":
            let ans = self.icloudUrl(modelArray: modelArray)
            complation(nil, ans)
        case "Dropbox":
            let ans = self.createDropBox(modelArray: modelArray)
            complation(nil, ans)
        case "Email":
            let ans = self.createEmail(modelArray: modelArray)
            complation(nil, ans)
        case "EmailAddress":
            let ans = self.createEmailAddress(modelArray: modelArray)
            complation(nil, ans)
        case "Wifi":
            let ans = self.createWifi(modelArray: modelArray)
            complation(nil, ans)
        case "Website":
            let ans = self.createUrl(modelArray: modelArray)
            complation(nil, ans)
        case "Phone Number":
            let ans = self.createPhone(modelArray: modelArray)
            complation(nil, ans)
        case "Sms":
            let ans = self.createSms(modelArray: modelArray)
            complation(nil, ans)
        case "Text":
            let ans = self.createText(modelArray: modelArray)
            complation(nil, ans)
        case "Vcard":
            let ans = self.createvCard(modelArray: modelArray)
            complation(ans, nil)
        case "Facebook":
            let ans = self.createFaceBook(modelArray: modelArray)
            complation(nil, ans)
        case "Instagram":
            let ans = self.createInstagram(modelArray: modelArray)
            complation(nil, ans)
        case "Twitter":
            let ans = self.createTwitter(modelArray: modelArray)
            complation(nil, ans)
        case "Skype":
            let ans = self.createSkype(modelArray: modelArray)
            complation(nil, ans)
        case "Calendar":
            let ans = self.createCalendar(modelArray: modelArray)
            complation(ans, nil)
        case "GoogleMap":
            let ans = self.createGoogleMap(modelArray: modelArray)
            complation(nil, ans)
        case "AppStore":
            let ans = self.createAppStore(modelArray: modelArray)
            complation(nil, ans)
        case "Ean-13":
            let ans = self.createEan_13(modelArray: modelArray)
            complation(nil, ans)
        case "Ean-8":
            let ans = self.createEan_8(modelArray: modelArray)
            complation(nil, ans)
        case "UPC-A":
            let ans = self.createUPC_A(modelArray: modelArray)
            complation(nil, ans)
        case "UPC-E":
            let ans = self.createUPC_E(modelArray: modelArray)
            complation(nil, ans)
        case "Code-128":
            let ans = self.createCode_128(modelArray: modelArray)
            complation(nil, ans)
        case "Code-39":
            let ans = self.createCode_39(modelArray: modelArray)
            complation(nil, ans)
        case "ITF":
            let ans = self.createITF(modelArray: modelArray)
            complation(nil, ans)
        case "Codabar":
            let ans = self.createCodabar(modelArray: modelArray)
            complation(nil, ans)
        case "Data Matrix":
            let ans = self.createDataMatrix(modelArray: modelArray)
            complation(nil, ans)
        case "Aztec":
            let ans = self.createAztecCode(modelArray: modelArray)
            complation(nil, ans)
        case "PDF417":
            let ans = self.createPDF_417(modelArray: modelArray)
            complation(nil, ans)
        case "Bing Search":
            let ans = self.createBingSearch(modelArray: modelArray)
            complation(nil, ans)
        default:
            print("Not Match")
        }
    }
    
    static func createEmail(modelArray: [ResultDataModel])  -> String {
        var mailName = "mailto:"
        var flag = 0
        for data in modelArray {
            switch data.title {
            case "Email Address:":
                mailName = mailName + data.description
                break
            case "Cc:":
                mailName = mailName + "?cc=" + data.description
                flag = 1
                break
            case "Subject:":
                if flag == 0 {
                    mailName = mailName + "?subject=" + data.description
                }
                else {
                    mailName = mailName + "&subject=" + data.description
                }
                flag = 1
                break
            case "Body:":
                if flag == 0 {
                    mailName = mailName + "?body=" + data.description
                }
                else {
                    mailName = mailName + "&body=" + data.description
                }
                flag = 1
                break
            default:
                print("Not Match")
            }
        }
        print("Mail :   ", mailName)
        return mailName
    }
    
    static func createWifi(modelArray: [ResultDataModel])  -> String {
        var tempArr = [String]()
        for i in 0 ..< 4 {
            tempArr.append("")
        }
        
        var wifi = "WIFI:"
        
        for data in modelArray {
            switch  data.title {
            case "Network Name:":
                tempArr[1] = "S:" + data.description + ";"
                break
            case "Password:":
                tempArr[2] = "P:" + data.description + ";"
                break
            case "Encription:":
                tempArr[0] = "T:" + data.description + ";"
                break
            case "Hidden:":
                tempArr[3] = "H:" + data.description + ";"
                break
            default:
                print("Not Match")
            }
        }
        for s in tempArr {
            wifi += s
        }
        print("Wifi : ", wifi)
        return wifi
    }
    
    static func createUrl(modelArray: [ResultDataModel]) -> String {
        
        
        
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        
        if !urlName.containsIgnoringCase(find: "http") || !urlName.containsIgnoringCase(find: "https") {
            
            urlName = "http://" + urlName
        }
        
        
        return urlName
    }
    
    static func createPhone(modelArray: [ResultDataModel]) -> String {
        var smsName = "tel:"
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createViber(modelArray: [ResultDataModel]) -> String {
        var smsName = "viber:add?number=+"
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    
    static func createWhatsapp(modelArray: [ResultDataModel]) -> String {
        var smsName = "whatsapp://send?phone=+"
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createDropBox(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createPinerest(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    
    static func createEan13(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createUPCE(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createEan8(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createYoutube(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createYahoo(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    
    static func createFlickr(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    
    static func createOneDrive(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func getDuckDuckGo(modelArray: [ResultDataModel]) -> String {
        var smsName = "http://duckduckgo.com/?q="
        var flag  = 0
        for data in modelArray {
            if data.description.containsIgnoringCase(find: "https") {
                smsName = data.description
                flag = 1
            }
            else {
                smsName = smsName + data.description
                flag = 0
            }
        }
        if flag == 0 {
            smsName = smsName + "&ia=lyrics"
        }
       
        return smsName
    }
    
    
    static func createGooglePlus(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    
    static func createSpotify(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createWEchat(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createsnap(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }

    static func createBox(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func icloudUrl(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func linkedinUrl(modelArray: [ResultDataModel]) -> String {
        var smsName = ""
        for data in modelArray {
            smsName = smsName + data.description
        }
        return smsName
    }
    
    static func createSms(modelArray: [ResultDataModel]) -> String {
        
        var flag  = 0
        var smsName = "sms:"
        for data in modelArray {
            
            switch data.title {
            case "Phone Number:":
                smsName = smsName + data.description
                break
            case "Message:":
                smsName = smsName + ":"
                smsName = smsName + data.description
                break
            default:
                print("Not Match")
            }
        }
        return smsName
    }
    
    static func createText(modelArray: [ResultDataModel]) -> String {
        var text = ""
        
        for data in modelArray {
            text = text + data.description
        }
        return text
    }
    
    static func createMMSS(modelArray: [ResultDataModel]) -> String {
        var text = "mmsto:"
        let index = 0
        
        for data in modelArray {
            text = text + data.description
            if index < modelArray.count - 1{
                text = text + ":"
            }
        }
        return text
    }
    
    
    static func createBingSearch(modelArray: [ResultDataModel]) -> String {
        var text = "http://www.bing.com/search?q="
        let index = 0
        var flag  = 0
        for data in modelArray {
          
            
            if data.description.containsIgnoringCase(find: "https") {
                text = data.description
                flag = 1
            }
            else {
                text = text + data.description
                flag = 0
            }
        }

        if flag == 0 {
            text = text + "&go=&qs=n&sk=&form=QBLH"
        }
        return text
    }
    
    static func createMeCARD(modelArray: [ResultDataModel])->String {
        
        let value = createMECardString(firstName: modelArray[0].description, lastName:  modelArray[1].description, phone:  modelArray[2].description, email:  modelArray[3].description, url:  modelArray[4].description, nickname:  modelArray[5].description, address:  modelArray[6].description, organization:  modelArray[7].description, note:  modelArray[8].description, birthDay:  modelArray[9].description)
        
        return value
        
    }
    
    static func createvCard(modelArray: [ResultDataModel]) -> CNMutableContact {
        let contactCard = CNMutableContact()
        let address = CNMutablePostalAddress()
        
        for data in modelArray {
            print("NOOOOO  ", data.title)
            switch data.title {
            case "First Name:":
                if data.description != ""{
                    contactCard.givenName = data.description
                }
                break
            case "Last Name:":
                if data.description != ""{
                    contactCard.familyName = data.description
                }
                break
            case "Mobile:":
                if data.description != ""{
                    let phoneNumber = CNPhoneNumber(stringValue: data.description)
                    let labelled = CNLabeledValue(label: "TEL", value: phoneNumber)
                    contactCard.phoneNumbers.append(labelled)
                }
                break
            case "Phone:":
                if data.description != ""{
                    let phoneNumber = CNPhoneNumber(stringValue: data.description)
                    let labelled = CNLabeledValue(label: "TEL", value: phoneNumber)
                    contactCard.phoneNumbers.append(labelled)
                }
                break
            case "Fax:":
                if data.description != ""{
                    let phoneNumber = CNPhoneNumber(stringValue: data.description)
                    let labelled = CNLabeledValue(label: "TEL", value: phoneNumber)
                    contactCard.phoneNumbers.append(labelled)
                }
                break
            case "Email:":
                if data.description != ""{
                    let workEmail = CNLabeledValue(label:"Work Email", value: data.description  as NSString)
                    contactCard.emailAddresses = [workEmail]
                }
                break
            case "Company:":
                if data.description != ""{
                    contactCard.organizationName = data.description
                }
                break
            case "Your Job:":
                if data.description != ""{
                    contactCard.jobTitle = data.description
                }
                break
            case "Street:":
                if data.description != ""{
                    address.street =  data.description
                }
                break
            case "City:":
                if data.description != ""{
                    address.city = data.description
                }
                break
            case "Zip:":
                if data.description != ""{
                    address.postalCode = data.description
                }
                break
            case "State:":
                if data.description != ""{
                    address.state = data.description
                }
                break
            case "Country:":
                if data.description != ""{
                    address.country = data.description
                    let home = CNLabeledValue<CNPostalAddress>(label: CNLabelHome, value: address)
                    contactCard.postalAddresses = [home]
                }
                break
            case "Website:":
                if data.description != ""{
                    let URL = CNLabeledValue(label:"URL", value: data.description as NSString)
                    contactCard.urlAddresses = [URL]
                }
                break
            default:
                print("Not match")
            }
        }
        
        for i in modelArray {
            print("Now  ", i)
        }
        return contactCard
    }
    
    static func createFaceBook(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        
        return urlName
    }
    
    
    static func createGoogleSearch(modelArray: [ResultDataModel]) -> String {
        var urlName = "http://www.google.com/search?ie=UTF-8&q="
        for data in modelArray {
            if data.description.containsIgnoringCase(find: "https") {
                urlName = data.description
            }
            else {
                urlName = urlName + data.description
            }
        }
        
        return urlName
    }
    
    static func tumble(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        
        return urlName
    }
    
    static func createEmailAddress(modelArray: [ResultDataModel]) -> String {
        var emailName = "MAILTO:"
        for data in modelArray {
            emailName = emailName + data.description
        }
        return emailName
    }
    
    static func createInstagram(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    static func createTwitter(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    
    static func createSkype(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    
    static func createCalendar(modelArray: [ResultDataModel]) -> CNMutableContact {
        let contactCard = CNMutableContact()
        return contactCard
    }
    
    static func createGoogleMap(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    
    static func createAppStore(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    
    static func createYoutubeVideo(modelArray: [ResultDataModel]) -> String {
        var urlName = "https://www.youtube.com/watch?v="
        for data in modelArray {
            
            if data.description.containsIgnoringCase(find: "https") {
                urlName = data.description
            }
            else {
                urlName = urlName + data.description
            }
            
        }
        return urlName
    }
    
    static func createTumbr(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    
    static func createGoogleDrive(modelArray: [ResultDataModel]) -> String {
        var urlName = ""
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    
    static func createLinkedin(modelArray: [ResultDataModel]) -> String {
        var urlName = "https://www.linkedin.com/"
        for data in modelArray {
            urlName = urlName + data.description
        }
        return urlName
    }
    
    
    static func createEan_13(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createEan_8(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createUPC_A(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createUPC_E(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createCode_128(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createCode_39(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createITF(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createCodabar(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createDataMatrix(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createAztecCode(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
    static func createPDF_417(modelArray: [ResultDataModel]) -> String {
        if modelArray.count > 0 {
            return modelArray[0].description
        }
        return ""
    }
    
}

//MARK: Get Result Send Action Button Title
extension Constant {
    
    static func getSendTitle(type: String) -> String {
        print("Now Type   ", type)
        switch type {
        case "Url", "Email", "EmailAddress":
            return "Go to Link"
        case "Facebook", "Twitter", "Instagram":
            return "Go to ID"
        case "Phone":
            return "Call"
        case "Sms":
            return "Send SMS"
        case "Text":
            return "Copy"
        case "vCard","MeCard":
            return "Add to Contact"
        case "GoogleMap":
            return "Go to Location"
        case "AppStore":
            return "Go to Link"
        case "":
            return ""
        case "":
            return ""
        case "":
            return ""
        case "":
            return ""
        case "":
            return ""
        default:
            return ""
        }
    }
}


//MARK: Create Image
extension Constant {
    
    static func createBarcodeAndQrCodeImage(type: String, resultString: String) -> UIImage? {
        print("Type44444  ", type,"   ", resultString)
        switch type {
        case "Email":
            let image = UIImage()
            return image
        case "EmailAddress":
            let image = UIImage()
            return image
        case "Wifi":
            let image = UIImage()
            return image
        case "Url":
            let image = UIImage()
            return image
        case "Phone":
            let image = UIImage()
            return image
        case "Sms":
            let image = UIImage()
            return image
        case "Text":
            let image = UIImage()
            return image
        case "vCard":
            let image = UIImage()
            return image
        case "Facebook":
            let image = UIImage()
            return image
        case "Instagram":
            let image = UIImage()
            return image
        case "Twitter":
            let image = UIImage()
            return image
        case "Skype":
            let image = UIImage()
            return image
        case "Calendar":
            let image = UIImage()
            return image
        case "GoogleMap":
            let image = UIImage()
            return image
        case "AppStore":
            let image = UIImage()
            return image
        case "Ean-13", "FORMAT_EAN_13":
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.ean13.rawValue)
            return image
        case "Ean-8", "FORMAT_EAN_8":
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.ean8.rawValue)
            return image
        case "UPC-A", "FORMAT_UPC_A":
            let image = self.generateDataMatrixQRCode(string: resultString, format: kBarcodeFormatUPCA) // not found
            return image
        case "UPC-E", "FORMAT_UPC_E":
            let image = self.generateDataMatrixQRCode(string: resultString, format: kBarcodeFormatUPCE) // not found
            
            return image
        case "Code-128", "FORMAT_CODE_128":
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.code128.rawValue)
            return image
        case "Code-39", "FORMAT_CODE_39":
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.code39.rawValue)
            return image
        case "ITF", "FORMAT_ITF":
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.itf14.rawValue)
            return image
        case "Codabar", "FORMAT_CODABAR":
            if(resultString.isNumericForCodeBar && resultString.count >= 1 && resultString.count<=1000) {
                let image =  self.generateCoddabar(string: resultString)
                return image
            }else{
                
                print("Invalid")
                return UIImage()
            }
            
        case "DataMatrix", "FORMAT_DATA_MATRIX": // not found in scanner
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.dataMatrix.rawValue)
            
            return image
        case "Aztec", "FORMAT_AZTEC":
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.aztec.rawValue)
            return image
        case "PDF-417", "FORMAT_PDF417":
            let image = self.generateImageForEan_8(string: resultString, type: AVMetadataObject.ObjectType.pdf417.rawValue)
            return image
        default:
            print("Not Match")
            return nil
            
        }
    }
    
    static func generateQRCodeImage(from string: String, filterName: String) -> UIImage? {
       let data = string.data(using: String.Encoding.ascii)
       print("FilterName  ", filterName)
       if let filter = CIFilter(name: filterName) {
           filter.setValue(data, forKey: "inputMessage")
           let transform = CGAffineTransform(scaleX: 3, y: 3)
           
           if let output = filter.outputImage?.transformed(by: transform) {
               return UIImage(ciImage: output)
           }
       }
       
       return nil
   }
    
    
    
    
    static func generateImageForEan_8(string: String, type: String) -> UIImage {
        var imageValue =  RSUnifiedCodeGenerator.shared.generateCode(string, machineReadableCodeObjectType: type)
        if imageValue != nil {
            if imageValue != nil {
                imageValue =  RSAbstractCodeGenerator.resizeImage(imageValue!, scale: 5.0)
                return imageValue!
            }else{
                return UIImage()
            }
        }
        return UIImage()
    }
    
    static func generateCoddabar(string: String) -> UIImage? {
        return self.generateDataMatrixQRCode(string: string, format: kBarcodeFormatCodabar)
    }
    
    
    static func generateDataMatrixQRCode(string: String, format: ZXBarcodeFormat) -> UIImage? {
            do {
                let writer = ZXMultiFormatWriter()
                let hints = ZXEncodeHints() as ZXEncodeHints
                let result = try writer.encode(string, format: format, width: 1000, height: 1000, hints: hints)
                
                if let imageRef = ZXImage.init(matrix: result) {
                    if let image = imageRef.cgimage {
                        return UIImage.init(cgImage: image)
                    }
                }
            }
            catch {
                print(error)
            }
            return nil
        }



    
}



extension UIView {
    
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
}

//
//  QrParser.swift
//  QrCode&BarCode
//
//  Created by Sadiq on 6/3/23.
//

import UIKit
import Contacts

class QrParser: NSObject {
    
    
    
    
    static func getBarCodeObj(text:String)->String {
        
        var calendarValue:MXLCalendar!
        var currentType = ""
        var contacts:[CNContact] = []
    
        
        
        var dict = ["Image": "Enter Link/Text,Select an Image",
                    "Email": "Enter Email Address,CC,Subject,Email Body",
                    "Url": "Enter Url",
                    "Phone": "Enter Phone Number",
                    "SMS": "Enter Phone Number,Enter Message",
                    "Text":"Enter Text"
                    ,"vCard":"First Name,Last Name,Phone Number,Email,Organization,Job Title,Street,City,State,Country,Postal Code,Website",
                     "vCard1":"First Name,Last Name,Phone,Email,Url,NickName,Address,Organization,Note,Birthday",
                    "Facebook": "Enter FaceBook Link",
                    "Instagram": "Enter Instagram Id",
                    "Twitter": "Enter Twitter Id",
                    "Skype": "Enter Skype Id",
                    "Calendar": "EventName,EvenLocation,Note,StartDate,EndDate",
                    "Google Map Location": "Enter Location Link",
                    "AppStore": "Enter AppStore Link",
                    "BarCode":"Text",
                    "WIFI": "Enter Network Name,Enter Password,Enter Encription,Enter network status",
                    "MMS": "Phone number,Body,Meesege"]
        
        
        
        if let data = text.data(using: .utf8) {
            do{
                contacts = try CNContactVCardSerialization.contacts(with: data)
                let contact = contacts.first
                print("\(String(describing: contact?.familyName))")
            }
            catch{
                // Error Handling
                print(error.localizedDescription)
            }
        }
        
        let calendarManager = MXLCalendarManager()
        calendarManager.parse(icsString: text) { (calendar, error) in
            calendarValue = calendar
            
        }
        
        
        
        
        if text.containsIgnoringCase(find: "MECARD") {
            
            let contactCard = CNMutableContact()
            currentType = "MECARD"
            let value  = dict["vCard1"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            var array =  NSMutableArray(array: ar!) as! [String]
            var tempText = text
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
                    }
                    
                    else if name.count == 2  {
                        array[0] = "First Name: " + name[1]
                        array[1] = "Last Name: " +  name[0]
                        
                        contactCard.givenName = name[1]
                        contactCard.familyName = name[0]
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
            
            var output = ""
            var index = 0
            
            for item in array {
                output = output + item
                
                if index < array.count - 1{
                    output = output + "\n\n"
                }
                index = index + 1
            }
            
            
            output = output + "^" + currentType
            
            return output
        }
        
        else if text.containsIgnoringCase(find: "GEO") {
            let currentType = "Location"
            var ar = text.components(separatedBy: ",")  as? NSArray
            var index = 0
            var value1 = "Longitude: "
            if let valu  =  ar {
                for item in valu {
                     var a  = item as? String
                     a = a!.replacingOccurrences(of: "GEO:", with: "")
                     a = a!.replacingOccurrences(of: "geo:", with: "")
                     a = a!.replacingOccurrences(of: "GEO: ", with: "")
                     a = a!.replacingOccurrences(of: "geo: ", with: "")
                     
                    if index == 0, let x = a {
                        value1 = value1 + "\(x)"
                    }
                    else {
                        
                        if let x = a {
                            value1 = value1 + "\n\n"
                            value1 = value1 + "Latitude: " + x
                        }
                    }
                    index = index + 1
                }
            }
            
            value1 = value1 + "^" + currentType
            return value1
            
            print(value1)
        }
       else  if text.containsIgnoringCase(find: "VCARD") {
            currentType = "Vcard"
            let value  = dict["vCard"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            var array =  NSMutableArray(array: ar!) as! [String]
            let contact = contacts.first
            var mailValue = "Email:  "
            if let emailAddresses = contact?.emailAddresses {
                for mail in emailAddresses {
                    
                    var value1 =  String(describing: mail.value)
                    mailValue = mailValue +  value1
                    mailValue = mailValue + " "
                }
            }
            
            var phoneValue = "Phone No: "
            if let phoneNumbers = contact?.phoneNumbers {
                for phoneNumber in  phoneNumbers{
                    phoneValue = phoneValue + phoneNumber.value.stringValue
                    phoneValue = phoneValue + ", "
                }
            }
            
           if let postalAddresses = contact?.postalAddresses {
                var address = "Street: "
                for add in postalAddresses{
                    address = address +  add.value.street
                    address = address + " "
                }
               
               var address1 = "City: "
               for add in postalAddresses{
                   address1 = address1 +  add.value.city
                   address1 = address1 + " "
               }
               
               
               var address2 = "State: "
               for add in postalAddresses{
                   address2 = address2 +  add.value.state
                   address2 = address2 + " "
               }
               
               var address3 = "Country: "
               for add in postalAddresses{
                   address3 = address3 +  add.value.country
                   address3 = address3 + " "
               }
               
               var address4 = "ZIp code: "
               for add in postalAddresses{
                   address4 = address4 +  add.value.postalCode
                   address4 = address4 + " "
               }
                
                if address.count > 0 {
                    array[6]  = address
                }
               
               if address1.count > 0 {
                   array[7]  = address1
               }
               
               if address2.count > 0 {
                   array[8]  = address2
               }
               
               if address3.count > 0 {
                   array[9]  = address3
               }
               if address3.count > 0 {
                   array[10]  = address4
               }
            }
           
           
            
            var notesValue = contact?.note
            var urlValue = "URL: "
            
            if let urlAddresses = contact?.urlAddresses {
                for urlValueF in  urlAddresses {
                    var value1 =  String(describing: urlValueF.value)
                    urlValue = urlValue + value1
                    urlValue = urlValue + " "
                }
            }
            
            if phoneValue.count > 0 {
                array[2]  = phoneValue
            }
            if mailValue.count > 0 {
                array[3]  = mailValue
            }
            if urlValue.count > 0 {
                array[11]  = urlValue
            }
            
            if let orginization = contact?.organizationName
            {
                if orginization.count > 0 {
                    array[4] = "Organization: " + orginization
                }
            }
           
           if let JobTitle = contact?.jobTitle
           {
               if JobTitle.count > 0 {
                   array[5] = "JobTitle: " + JobTitle
               }
           }
           
           
            if let familyname  = contact?.familyName
            {
                if familyname.count > 0 {
                    array[1] =  "Last Name: " + familyname
                }
            }
            if let firstName  = contact?.givenName
            {
                if firstName.count > 0 {
                    array[0] = "First Name: " + firstName
                }
            }
            
            var output = ""
            var index = 0
            
            for item in array {
                output = output + item
                
                if index < array.count - 1{
                    output = output + "\n\n"
                }
                index = index + 1
            }
            
            
            output = output + "^" + currentType
            
            return output
        }
        
    
        
       else if text.containsIgnoringCase(find:"tel") {
            currentType = "Phone Number"
            
            let value  = dict["Phone"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            let array =  NSMutableArray(array: ar!) as! [String]
            var index = 0
            var phoneNumber = "Phone          :  "
            var textValue = ""
            while text[index] != ":" {
                index = index + 1
            }
            index  = index + 1
            var flag = 0
            if isdigit(value: text[index]) || text[index] == "+" {
                while isdigit(value: text[index]) , index < text.count {
                    phoneNumber = phoneNumber + text[index]
                    index  = index + 1
                    flag = 1
                    if index >= text.count {
                        break
                    }
                    
                }
            }
            
            phoneNumber = phoneNumber + "^" + currentType
            return phoneNumber
            
        }
        
        else if text.containsIgnoringCase(find: "mailto") {
            currentType = "Mail"
            
            let value  = dict["Email"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            let array =  NSMutableArray(array: ar!) as! [String]
            
            let txtAppend = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            var nameValue = ""
            if let  mailToURL = URL(string: txtAppend!) {
                if let emailParameters = EmailParameters(url: mailToURL) {
                    if emailParameters.toEmails.count > 0 {
                        var name = "Email: "
                        var co = 0
                        for item in emailParameters.toEmails{
                            
                            if co%2 == 1
                            {
                                name = name + ","
                            }
                            name  = name + item
                            co = co + 1
                            
                            
                        }
                        nameValue = "Email          :   " + name.replacingOccurrences(of: "Email: ", with: "")
                    }
                    
                    if emailParameters.ccEmails.count > 0 {
                        var name = "CC: "
                        var co = 0
                        for item in emailParameters.ccEmails{
                            
                            if co%2 == 1
                            {
                                name = name + ","
                            }
                            name  = name + item
                            co = co + 1
                            
                            
                        }
                        nameValue = nameValue + "\n\n" + "CC             :  " + name.replacingOccurrences(of: "CC: ", with: "")
                    }
                    
                    if let subject1 = emailParameters.subject {
                        nameValue = nameValue + "\n\n" + "Subject       :  " + subject1
                        
                    }
                    
                    if let body1 = emailParameters.body {
                        nameValue = nameValue + "\n\n" + "Body           :  " + body1
                    }
                    
                    nameValue = nameValue + "^" + "Email"
                }
                return nameValue
            }
        }
        
        else if text.containsIgnoringCase(find:"sms"){
            
            currentType = "Sms"
            
            let value  = dict["SMS"]
            let ar = value!.components(separatedBy: ",")  as? NSArray
            if ar!.count < 2 {
                value!.components(separatedBy: ":")  as? NSArray
            }
            let  array =  NSMutableArray(array: ar!) as! [String]
            var index = 0
            var phoneNumber = ""
            var textValue = ""
            while text[index] != ":" {
                index = index + 1
            }
            index  = index + 1
            var flag = 0
            if isdigit(value: text[index]) || text[index] == "+" {
                while isdigit(value: text[index]) , index < text.count {
                    phoneNumber = phoneNumber + text[index]
                    index  = index + 1
                    flag = 1
                    if index >= text.count {
                        break
                    }
                    
                }
            }
            if index < text.count {
                while text[index] != ":" , flag == 1{
                    index = index + 1
                    
                }
                if flag == 1 {
                    index = index + 1
                }
                
                while index < text.count{
                    textValue += text[index];
                    index += 1
                }
            }
            
            var  output  = ""
            output =  "Phone Number    :  " + phoneNumber
            output = output + "\n\n"
            output =  output + "Sms                 :  " + textValue
            
            output = output + "^" + currentType
            
            
            return output
        }
        
        else if text.containsIgnoringCase(find: "VCALENDAR") {
            
            
            currentType = "Event"
            let value  = dict["Calendar"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            var array =  NSMutableArray(array: ar!) as! [String]
            var compo = text.components(separatedBy: ",")  as? NSArray
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
            if let eventNote = calendarValue.events[0].eventStartDate {
                
                array[3] =  "Event Start Day: " + eventNote.asString(style: .full)
            }
            
            if let eventNote = calendarValue.events[0].eventEndDate {
                array[4] =  "Event End Day: " + eventNote.asString(style: .full)
            }
            
            var output = ""
            var index = 0
            
            for item in array {
                output = output + item
                
                if index < array.count - 1{
                    output = output + "\n\n"
                }
                index = index + 1
            }
            
            
            output = output + "^" + currentType
            
            return output
            
        }
        else if text.containsIgnoringCase(find: "wifi") {
            var array:[String] = ["","","",""]
            if text.containsIgnoringCase(find: "WIFI") {
                currentType = "Wifi"
                var ar = text.components(separatedBy: ";")  as? NSArray ?? NSArray()
                     for item in ar {
                    var mal = (item as? String)!.replacingOccurrences(of: "WIFI:", with: "", options: .literal, range: nil)
                    mal = mal.replacingOccurrences(of: "wifi:", with: "", options: .literal, range: nil)
                    
                    if mal.containsIgnoringCase(find: "T:") {
                        
                        array[2] = "Encryption:    " +  mal.replacingOccurrences(of: "T:", with: "", options: .literal, range: nil)
                    }
                    
                    if mal.containsIgnoringCase(find: "S:") {
                        
                        array[0] = "Network Name:  " +  mal.replacingOccurrences(of: "S:", with: "", options: .literal, range: nil)
                    }
                    if mal.containsIgnoringCase(find: "P:") {
                        
                        array[1] = "Password:      " +  mal.replacingOccurrences(of: "P:", with: "", options: .literal, range: nil)
                    }
                    print(mal)
                }
                
                var output = ""
                var index = 0
                
                for item in array {
                    output = output + item
                    
                    if index < array.count - 1{
                        output = output + "\n\n"
                    }
                    index = index + 1
                }
                
                
                output = output + "^" + currentType
               return output
                
            }
        }
        
        else if text.containsIgnoringCase(find: "mmsto") {
            let currentType = "MMS"
            var array:[String] = ["","","",""]
            if let ar = text.components(separatedBy: ":")  as? NSArray {
                
                
                if ar.count > 1 {
                    let temp = ar[1] as? String
                    array[0] = "Phone number: "  +  temp!
                }
                
                if ar.count > 2 {
                    let temp = ar[2] as? String
                    array[1] = "Body: "  + (temp ?? "")
                }
                
                if ar.count > 3 {
                    let temp = ar[3] as? String
                    array[2] = "Message: "  + (temp ?? "")
                }
                
                
                var output = ""
                var index = 0
                
                for item in array {
                    output = output + item
                    
                    if index < array.count - 1{
                        output = output + "\n\n"
                    }
                    index = index + 1
                }
                
                
                output = output + "^" + currentType
                return output
            }
        }

       else  if text.isValidURL {
            
            var nameValue = ""
            currentType = "Website"
           
           if text.containsIgnoringCase(find: "duckduckgo"),text.containsIgnoringCase(find: "q=")  {
               
               currentType = "DuckDuck Go"
               
           }
           
           
           if text.containsIgnoringCase(find: "BING"),text.containsIgnoringCase(find: "q=")  {
               
               currentType = "Bing Search"
               
           }
           
           if text.containsIgnoringCase(find: "viber"),text.containsIgnoringCase(find: "number") {
               currentType = "Viber"
           }
           
           if text.containsIgnoringCase(find: "whatsapp"),text.containsIgnoringCase(find: "phone") {
               currentType = "WhatsApp"
           }
           

           if text.containsIgnoringCase(find: "search?"),text.containsIgnoringCase(find: "q="),text.containsIgnoringCase(find: "google") {
               
               currentType = "Google Search"
               
           }
           if text.containsIgnoringCase(find: "watch?"),text.containsIgnoringCase(find: "v="),text.containsIgnoringCase(find: "youtube") {
               
               currentType = "Youtube Video"
               
           }
           
            let value  = dict["Url"]
            var ar = value!.components(separatedBy: ",")  as? NSArray
            let array =  NSMutableArray(array: ar!) as! [String]
            nameValue = "Url            :  " + text
           
           
            nameValue = nameValue + "^" + currentType
            return nameValue
        }
        
        var  output  = ""
        let value  = dict["Text"]
        currentType = "Text"
        var ar = value!.components(separatedBy: ",")  as? NSArray
        let array =  NSMutableArray(array: ar!) as! [String]
        output = "Text           :  " + text
        output = output + "^" + currentType
        return output
        
        return ""
    }
    
    
    
    
}

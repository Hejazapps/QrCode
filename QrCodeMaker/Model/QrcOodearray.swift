//
//  QrParser.swift
//  QrCode&BarCode
//
//  Created by Sadiq on 6/3/23.
//

import UIKit
import Contacts

class QrcOodearray: NSObject {
    
    
    
    
    
    
    static func getArray(text:String)->[ResultDataModel] {
        
        
        if text.containsIgnoringCase(find: "mmsto") {
            let currentType = " MMS"
            var array:[String] = ["","","",""]
            
            var ar1 = [ResultDataModel]()
            ar1.append(ResultDataModel(title: "Enter Number:", description: ""))
            ar1.append(ResultDataModel(title: "Enter Subject:", description: ""))
            ar1.append(ResultDataModel(title: "Enter Message", description: ""))
            
            
            if let ar = text.components(separatedBy: ":")  as? NSArray {
                
                
                if ar.count > 1 {
                    let temp = ar[1] as? String
                    ar1[0].description = (temp ?? "")
                }
                
                if ar.count > 2 {
                    let temp = ar[2] as? String
                    ar1[1].description = (temp ?? "")
                }
                
                if ar.count > 3 {
                    let temp = ar[3] as? String
                    ar1[2].description = (temp ?? "")
                }
                
                return ar1
            }
        }
        
        if text.containsIgnoringCase(find: "duckduckgo"),text.containsIgnoringCase(find: "q=") {
            
            var ar1 = [ResultDataModel]()
            let urlParts = text.components(separatedBy: "q=")
            let paramParts = urlParts[1].components(separatedBy: "&")
            
            ar1.append(ResultDataModel(title: "Enter field", description: paramParts[0]))
            return ar1
            
            print(paramParts)
            
        }
        
        if text.containsIgnoringCase(find: "search?"),text.containsIgnoringCase(find: "q="),text.containsIgnoringCase(find: "bing") {
            
            var ar1 = [ResultDataModel]()
            let urlParts = text.components(separatedBy: "q=")
            let paramParts = urlParts[1].components(separatedBy: "&")
            
            ar1.append(ResultDataModel(title: "Enter search item", description: paramParts[0]))
            return ar1
            
        }
        
        if text.containsIgnoringCase(find: "search?"),text.containsIgnoringCase(find: "q="),text.containsIgnoringCase(find: "google") {
            
            var ar1 = [ResultDataModel]()
            let urlParts = text.components(separatedBy: "q=")
            
            ar1.append(ResultDataModel(title: "Enter search item", description: urlParts[1]))
            return ar1
            
        }
        if text.containsIgnoringCase(find: "viber"),text.containsIgnoringCase(find: "number") {
            
            var ar1 = [ResultDataModel]()
            let urlParts = text.components(separatedBy: "+")
            
            ar1.append(ResultDataModel(title: "Enter number", description: urlParts[1]))
            return ar1
            
        }
        
        if text.containsIgnoringCase(find: "whatsapp"),text.containsIgnoringCase(find: "phone") {
            
            var ar1 = [ResultDataModel]()
            let urlParts = text.components(separatedBy: "+")
            
            ar1.append(ResultDataModel(title: "Enter number", description: urlParts[1]))
            return ar1
            
        }
        if text.containsIgnoringCase(find: "watch?"),text.containsIgnoringCase(find: "v="),text.containsIgnoringCase(find: "youtube") {
            
            var ar1 = [ResultDataModel]()
            let urlParts = text.components(separatedBy: "v=")
            
            ar1.append(ResultDataModel(title: "Enter Youtube id", description: urlParts[1]))
            return ar1
            
        }
        
        
        if text.containsIgnoringCase(find: "vcard") {
            
            
            
            var array = [ResultDataModel]()
            array.append(ResultDataModel(title: "First Name:",description: ""))
            array.append(ResultDataModel(title: "Last Name:", description: ""))
            array.append(ResultDataModel(title: "Phone:", description: ""))
            array.append(ResultDataModel(title: "Email:", description: ""))
            array.append(ResultDataModel(title: "Organization:", description: ""))
            array.append(ResultDataModel(title: "Job Title:", description: ""))
            array.append(ResultDataModel(title: "Street:", description: ""))
            array.append(ResultDataModel(title: "City:", description: ""))
            array.append(ResultDataModel(title: "State:", description: ""))
            array.append(ResultDataModel(title: "Country:", description: ""))
            array.append(ResultDataModel(title: "ZipCode:", description: ""))
            array.append(ResultDataModel(title: "Website:", description: ""))
            
            var contacts:[CNContact] = []
            
            
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
            
            
            let contact = contacts.first
            var mailValue = ""
            if let emailAddresses = contact?.emailAddresses {
                for mail in emailAddresses {
                    
                    var value1 =  String(describing: mail.value)
                    mailValue = mailValue +  value1
                    mailValue = mailValue + " "
                }
            }
            
            var phoneValue = ""
            if let phoneNumbers = contact?.phoneNumbers {
                for phoneNumber in  phoneNumbers{
                    phoneValue = phoneValue + phoneNumber.value.stringValue
                    phoneValue = phoneValue + ", "
                }
            }
            
            if let postalAddresses = contact?.postalAddresses {
                var address = ""
                for add in postalAddresses{
                    address = address +  add.value.street
                    address = address + " "
                }
                
                var address1 = ""
                for add in postalAddresses{
                    address1 = address1 +  add.value.city
                    address1 = address1 + " "
                }
                
                
                var address2 = ""
                for add in postalAddresses{
                    address2 = address2 +  add.value.state
                    address2 = address2 + " "
                }
                
                var address3 = ""
                for add in postalAddresses{
                    address3 = address3 +  add.value.country
                    address3 = address3 + " "
                }
                
                var address4 = ""
                for add in postalAddresses{
                    address4 = address4 +  add.value.postalCode
                    address4 = address4 + " "
                }
                
                if address.count > 0 {
                    array[6].description  = address
                }
                
                if address1.count > 0 {
                    array[7].description  = address1
                }
                
                if address2.count > 0 {
                    array[8].description  = address2
                }
                
                if address3.count > 0 {
                    array[9].description  = address3
                }
                if address3.count > 0 {
                    array[10].description  = address4
                }
            }
            
            
            
            var notesValue = contact?.note
            var urlValue = ""
            
            if let urlAddresses = contact?.urlAddresses {
                for urlValueF in  urlAddresses {
                    var value1 =  String(describing: urlValueF.value)
                    urlValue = urlValue + value1
                    urlValue = urlValue + " "
                }
            }
            
            if phoneValue.count > 0 {
                array[2].description  = phoneValue
            }
            if mailValue.count > 0 {
                array[3].description  = mailValue
            }
            if urlValue.count > 0 {
                array[11].description  = urlValue
            }
            
            if let orginization = contact?.organizationName
            {
                if orginization.count > 0 {
                    array[4].description =  orginization
                }
            }
            
            if let JobTitle = contact?.jobTitle
            {
                if JobTitle.count > 0 {
                    array[5].description =  JobTitle
                }
            }
            
            
            if let familyname  = contact?.familyName
            {
                if familyname.count > 0 {
                    array[1].description =  familyname
                }
            }
            if let firstName  = contact?.givenName
            {
                if firstName.count > 0 {
                    array[0].description =   firstName
                }
            }
            
            return array
        }
        
        
        if text.containsIgnoringCase(find: "GEO") {
            
            var ar1 = [ResultDataModel]()
            ar1.append(ResultDataModel(title: "Longitude:", description: ""))
            ar1.append(ResultDataModel(title: "Latitude", description: ""))
            
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
                        ar1[0].description = "\(x)"
                    }
                    else {
                        
                        if let x = a {
                            value1 = value1 + "\n\n"
                            value1 = value1 + "Latitude: " + x
                            
                            ar1[1].description = "\(x)"
                        }
                    }
                    
                }
            }
            return ar1
            
            print(value1)
        }
        
        if text.containsIgnoringCase(find: "wifi") {
            
            var array = [ResultDataModel]()
            array.append(ResultDataModel(title: "Network Name:",description: ""))
            array.append(ResultDataModel(title: "Encription:", description: ""))
            array.append(ResultDataModel(title: "Password:", description: ""))
            
            
            
            if text.containsIgnoringCase(find: "WIFI") {
                
                var ar = text.components(separatedBy: ";")  as? NSArray ?? NSArray()
                for item in ar {
                    var mal = (item as? String)!.replacingOccurrences(of: "WIFI:", with: "", options: .literal, range: nil)
                    mal = mal.replacingOccurrences(of: "wifi:", with: "", options: .literal, range: nil)
                    
                    if mal.containsIgnoringCase(find: "T:") {
                        
                        array[1].description = mal.replacingOccurrences(of: "T:", with: "", options: .literal, range: nil)
                    }
                    
                    if mal.containsIgnoringCase(find: "S:") {
                        
                        array[0].description =   mal.replacingOccurrences(of: "S:", with: "", options: .literal, range: nil)
                    }
                    if mal.containsIgnoringCase(find: "P:") {
                        
                        array[2].description =    mal.replacingOccurrences(of: "P:", with: "", options: .literal, range: nil)
                    }
                    print(mal)
                }
            }
            return array
            
        }
        if text.containsIgnoringCase(find: "MECARD") {
            
            
            
            var array = [ResultDataModel]()
            array.append(ResultDataModel(title: "First Name:",description: ""))
            array.append(ResultDataModel(title: "Last Name:", description: ""))
            array.append(ResultDataModel(title: "Phone:", description: ""))
            array.append(ResultDataModel(title: "Email:", description: ""))
            array.append(ResultDataModel(title: "Url:", description: ""))
            array.append(ResultDataModel(title: "Nick Name:", description: ""))
            array.append(ResultDataModel(title: "Address:", description: ""))
            array.append(ResultDataModel(title: "Organization:", description: ""))
            array.append(ResultDataModel(title: "Note:", description: ""))
            array.append(ResultDataModel(title: "Birthday:", description: ""))
            
            
            
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
                        array[0].description =  name[0]
                        
                    }
                    
                    else if name.count == 2  {
                        array[0].description =  name[1]
                        array[1].description =  name[0]
                    }
                }
                
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_TELEPHONE)) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_TELEPHONE.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_TELEPHONE.uppercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: "mecard:", with: "")
                    parsed = parsed.replacingOccurrences(of: "MECARD:", with: "")
                    
                    
                    if parsed.count >= 1 {
                        array[2].description =  parsed
                    }
                    
                }
                
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_EMAIL)) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_EMAIL.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_EMAIL.uppercased(), with: "")
                    
                    
                    if parsed.count >= 1 {
                        array[3].description =   parsed
                    }
                    
                }
                
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_URL)) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_URL.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_URL.uppercased(), with: "")
                    
                    
                    if parsed.count >= 1 {
                        array[4].description =  parsed
                    }
                    
                }
                
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_NICK_NAME)) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_NICK_NAME.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_NICK_NAME.uppercased(), with: "")
                    
                    
                    if parsed.count >= 1 {
                        array[5].description =   parsed
                    }
                    
                    
                }
                
                if(item.containsIgnoringCase(find:MeCardCostant.KEY_ADDRESS)) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_ADDRESS.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_ADDRESS.uppercased(), with: "")
                    
                    if parsed.count >= 1 {
                        array[6].description =  parsed
                    }
                    
                }
                
                if item.containsIgnoringCase(find:MeCardCostant.KEY_ORG) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_ORG.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_ORG.uppercased(), with: "")
                    
                    if parsed.count >= 1 {
                        array[7].description =    parsed
                    }
                    
                    
                }
                
                if item.containsIgnoringCase(find:MeCardCostant.KEY_NOTE) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_NOTE.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_NOTE.uppercased(), with: "")
                    
                    if parsed.count >= 1 {
                        array[8].description =  parsed
                    }
                }
                
                if item.containsIgnoringCase(find:MeCardCostant.KEY_DAY) {
                    
                    var parsed = item.replacingOccurrences(of: MeCardCostant.KEY_DAY.lowercased(), with: "")
                    parsed = parsed.replacingOccurrences(of: MeCardCostant.KEY_DAY.uppercased(), with: "")
                    
                    if parsed.count >= 1 {
                        array[9].description =  parsed
                    }
                    
                }
            }
            return array
            
        }
        
        
        if text.containsIgnoringCase(find: "mailto") {
            
            var ar1 = [ResultDataModel]()
            ar1.append(ResultDataModel(title: "Email Address:", description: ""))
            ar1.append(ResultDataModel(title: "Cc:", description: ""))
            ar1.append(ResultDataModel(title: "Subject:", description: ""))
            ar1.append(ResultDataModel(title: "Body:", description: ""))
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
                        ar1[0].description = name.replacingOccurrences(of: "Email: ", with: "")
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
                        ar1[1].description = name.replacingOccurrences(of: "CC: ", with: "")
                    }
                    
                    if let subject1 = emailParameters.subject {
                        nameValue = nameValue + "\n\n" + "Subject       :  " + subject1
                        ar1[2].description =  subject1
                        
                    }
                    
                    if let body1 = emailParameters.body {
                        nameValue = nameValue + "\n\n" + "Body           :  " + body1
                        ar1[3].description =  body1
                    }
                    
                    
                }
                
            }
            return ar1
        }
        
        
        if text.containsIgnoringCase(find: "tel") {
            
            let ar = text.components(separatedBy: ":")
            var ar1 = [ResultDataModel]()
            ar1.append(ResultDataModel(title: "Phone Number:", description: (ar[1] as? String)!))
            return ar1
            
        }
        
        if text.containsIgnoringCase(find: "sms") {
            
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
            
            var ar1 = [ResultDataModel]()
            ar1.append(ResultDataModel(title: "Phone Number:", description: phoneNumber))
            ar1.append(ResultDataModel(title: "Message:", description: textValue))
            return ar1
            
            
        }
        
        if  text.isValidURL {
            var ar1 = [ResultDataModel]()
            ar1.append(ResultDataModel(title: "URL", description: text))
            return ar1
        }
        
        
        var ar1 = [ResultDataModel]()
        ar1.append(ResultDataModel(title: "Text", description: text))
        return ar1
        
        
        
        
        return [ResultDataModel]()
    }
    
    
    
    
    
}



//
//  MeCardGenerator.swift
//  MeCard
//
//  Created by Md. Ikramul Murad on 9/8/23.
//

let BEGIN_MECARD = "MECARD:"
let NAME = "N:"
let SOUND = "SOUND:"
let TEL = "TEL:"
let TEL_AV = "TEL-AV:"
let EMAIL = "EMAIL:"
let NOTE = "NOTE:"
let BDAY = "BDAY:"
let ADDRESS = "ADR:"
let URLF = "URL:"
let NICKNAME = "NICKNAME:"
let LINE_SEPARATOR = ";"
let KEY_ORG = "ORG:"

 
 

func createMECardString(firstName: String?,
                        lastName: String?,
                        phone: String?,
                        email: String?,
                        url: String?,
                        nickname: String?,
                        address: String?,
                        organization: String?,
                        note: String?,
                        birthDay: String?) -> String {
    var meCardString = BEGIN_MECARD
    
    meCardString.append(NAME)
    var a = ""
    var  b = ""
    
    if let x = firstName {
        a = x
    }
    
    if let x = lastName {
        b = x
    }
    
    
    meCardString.append("\(b),\(a)")
    meCardString.append(LINE_SEPARATOR)
    
    if let phone {
        meCardString.append(TEL)
        meCardString.append(phone)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if let email {
        meCardString.append(EMAIL)
        meCardString.append(email)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if let note {
        meCardString.append(NOTE)
        meCardString.append(note)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if let birthDay {
        meCardString.append(BDAY)
        meCardString.append(birthDay)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if let address {
        meCardString.append(ADDRESS)
        meCardString.append(address)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if let url {
        meCardString.append(URLF)
        meCardString.append(url)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if let nickname {
        meCardString.append(NICKNAME)
        meCardString.append(nickname)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if let organization {
        meCardString.append(KEY_ORG)
        meCardString.append(organization)
        meCardString.append(LINE_SEPARATOR)
    }
    
    if meCardString == BEGIN_MECARD {
        meCardString.append(LINE_SEPARATOR)
    }
    meCardString.append(LINE_SEPARATOR)
    
    return meCardString
}

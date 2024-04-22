//
//  Store.swift
//  FinalDocumentScanner
//
//  Created by MacBook Pro Retina on 19/10/19.
//  Copyright © 2019 MacBook Pro Retina. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
class Store: NSObject {
    
    var storeArray:NSMutableArray!
    var fontArray:NSArray!
    var fontName = "sadiq"
    var products: [SKProduct] = []
    var imageArray:NSMutableArray!
    var shouldPop:Bool!
    var shouldPresentDatabse = false
    var isNeededToUpdate = true
    var iscalledPurchase = false
    var isPurchase = false
    var needTopresent = false
    var currentItem:String!
    var isfromFastIndex = 0
    var isMessedShowen = 0
    var isSubscriptionActive  =  false
    var tabarView:UITabBarController!
    var needToShow = false
    var showImage = false
    var selectedImage:UIImage!
    var shouldShowScanner = false
    var shouldShowHomeScreen = false
    var startDate:Date? = nil
    var endDate:Date? = nil
    var shouldShowHistoryPage = false
    var colorTypeString = "1;0;0"
    var currentIndexPath =  "1"
    var shouldShowLabel = false
    var currentPosiiton = ""
    var currentShape = ""
    var currentLogo = ""
    var showPickerT = false
    var isFromHistory = true
    
    static let sharedInstance = Store()
    
    func setstartDate(date:Date?) {
        startDate = date
    }
    
    func setendDate(date:Date?) {
        endDate = date
    }
    
    func setColorTypeString(value:String) {
        colorTypeString = value
    }
    
    func getColorTypeString()->String {
        return colorTypeString
    }
    
    func setShowHistoryPage(value:Bool) {
        shouldShowHistoryPage = value
    }
    
    func getshouldShowHistoryPage()->Bool {
        return shouldShowHistoryPage
    }
    
    func getstDate ()->Date? {
        return startDate
    }
    
    func getendDate ()->Date? {
        return endDate
    }
    
    func setshouldShowHomeScreen(value:Bool) {
        shouldShowHomeScreen = value
    }
    
    func getsshouldShowHomeScreen()->Bool {
        return shouldShowHomeScreen
    }
    
    func setshouldShowScanner(value:Bool) {
        shouldShowScanner = value
    }
    
    func getshouldShowScanner()->Bool {
        return shouldShowScanner
    }
    
    func setImage(value:UIImage) {
        selectedImage = value
    }
    
    func getImage()->UIImage {
        return selectedImage
    }
    
    func needToShowImage(value:Bool) {
        showImage = value
    }
    
    func getshowImage() ->Bool {
        return showImage
    }
    
    fileprivate override init() {
        
        imageArray = NSMutableArray()
        storeArray = NSMutableArray()
        shouldPop = false
        super.init()
    }
    
    func settabarView(tabBar:UITabBarController){
        tabarView = tabBar
    }
    
    func getTabrBar()->UITabBarController {
        return tabarView
    }
    
    func setArray(array: NSMutableArray) {
        storeArray = array
    }
    
    func setIsCalledPurchase(value: Bool) {
        iscalledPurchase = value
    }
    
    func setfromFastIndex(value:Int) {
        isfromFastIndex = value
    }
    
    func getfromFastIndex () ->Int {
        return isfromFastIndex
    }
    
    func needToShowValue(value:Bool) {
        needToShow = value
    }
    
    func getneedToShow () ->Bool {
        return needToShow
    }
    
    func setisMessedShowen(value:Int) {
        isMessedShowen = value
    }
    
    func getisMessedShowen () ->Int {
        return isMessedShowen
    }
    
    func setCurrentItem(value: String) {
        currentItem = value
    }
    
    func getCurrentItem() -> String {
        return currentItem
        
    }
    
    func getsCalledPurchase()->Bool {
        return iscalledPurchase
    }
    
    func seturchase(value: Bool) {
        isPurchase = value
    }
    
    func getPurchase()->Bool {
        return isPurchase
    }
    
    func setPurchaseActive(value: Bool) {
        isSubscriptionActive = value
    }
    
    func getIsPurchaseActive()->Bool {
        return isSubscriptionActive
    }
    
    func setneedTopresent(value: Bool) {
        needTopresent = value
    }
    
    func getneedTopresent()->Bool {
        return needTopresent
    }
    
    func getArray() -> NSMutableArray {
        return storeArray
    }
    
    func setfontArray(array: NSArray) {
        fontArray = array
    }
    
    func getfontArray() -> NSArray {
        return fontArray
    }
    
    func setFontName(name: NSString) {
        fontName = name as String
    }
    
    func getFontName() -> NSString {
        return fontName as NSString
    }
    
    func setProductArray(array:NSArray) {
        products = array as! [SKProduct]
    }
    
    func getProductArray() -> NSArray {
        return products as NSArray
    }
    
    func setImageArray(array:NSMutableArray) {
        imageArray = array
    }
    
    func getImageArray() -> NSMutableArray {
        return imageArray
    }
    
    func setPopValue(value:Bool) {
        shouldPop = value
    }
    
    func getPopValue()->Bool {
        return shouldPop
    }
    
    func getIsNeededToBeUpdated()->Bool {
        return isNeededToUpdate
    }
    
    func setDatabaseValue(value:Bool) {
        shouldPresentDatabse = value
    }
    
    func setUpdateTableValue(value:Bool) {
        isNeededToUpdate = value
    }
    
    func getDatabaseValue()->Bool {
        return shouldPresentDatabse
    }
    
    func setDate(date:NSDate) {
        let returnValue: [NSString]? = UserDefaults.standard.object(forKey: "PURCHASED_EXPIRE_DATE") as? [NSString]
        
        if returnValue?.count == 0 {
            UserDefaults.standard.set(date, forKey: "PURCHASED_EXPIRE_DATE")
        }
        
    }
    
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
    
    func setDate(date:Date?) {
        if let valueForDate = date {
            UserDefaults.standard.set(valueForDate, forKey: "PURCHASED_EXPIRE_DATE")
        }
    }
    
    func verifyReciept () {
        
        
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "94835c2bce2b460f880232ea40ab5568")
        
      
           
            SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                switch result {
                    
                case .success(let receipt):
                    let productIds = Set([ "com.scannr.yearly",
                                           "com.scannr.monthly",
                                           "com.scannr.weekly" ])
                    let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                    
                    switch purchaseResult {
                    case .purchased(let expiryDate, let items):
                        self.setDate(date: expiryDate)
                        
                    case .expired(let expiryDate, let items):
                        print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                        
                        
                    case .notPurchased:
                        print("The user has never purchased \(productIds)")
                    }
                case .error(let error):
                    print("The user has never purchased")
                }
            }
            
        }
        
        
        
        func isActiveSubscription() -> Bool {
            
            
            let now = Date()
            let mile = UserDefaults.standard.value(forKey: "PURCHASED_EXPIRE_DATE") as? Date
            
            print("\(now)")
            if let mile = mile {
                print("\(mile)")
            }
            var isActive = false
            if mile != nil {
                var result: ComparisonResult? = nil
                if let mile = mile {
                    result = now.compare(mile)
                }
                switch result {
                case .orderedSame, .orderedAscending:
                    isActive = true
                case .orderedDescending:
                    isActive = false
                default:
                    if let mile = mile {
                        print("erorr dates \(mile), \(now)")
                    }
                }
            }
            return isActive
        }
    }

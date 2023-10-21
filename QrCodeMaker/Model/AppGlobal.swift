//
//  AppGlobal.swift
//  LiveWallpaper
//
//  Created by Milan Mia on 9/9/17.
//  Copyright © 2017 Milan Mia. All rights reserved.
//


import SystemConfiguration
import UIKit


var tabBarUnSelectedColor = UIColor(red: 103.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1)
var tabBarSelectedColor = UIColor.white
var tabBarBackGroundColor =  UIColor(red: 17.0/255.0, green: 130.0/255.0, blue: 254.0/255.0, alpha: 1)
var dotViewColor =  UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1)
var qrCategoryArray: NSArray!
var barCategoryArray: NSArray!
var selectedIndexList = [String]()

var backgroundColorValue:[UIColor] = []

var currentIndexFolder = -1
var currentFolderName  = ""

func generateBarCode(_ string: String) -> UIImage {
    
    if !string.isEmpty {
        
        let data = string.data(using: String.Encoding.ascii)
        
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        // Check the KVC for the selected code generator
        filter!.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter?.outputImage?.transformed(by: transform)
        
        return UIImage(ciImage: output!)
    } else {
        return UIImage()
    }
}

func checkWhichUrl (name:String) -> String {
    
    if name.containsIgnoringCase(find: "OneDrive") {
        return "One Drive"
    }
    
    if name.containsIgnoringCase(find: "Viber") {
        return "Viber"
    }
    
    if name.containsIgnoringCase(find: "Bing") {
        return "Bing Search"
    }
    
    if name.containsIgnoringCase(find: "/search") {
        return "Google Search"
    }
    
    if name.containsIgnoringCase(find: "Yahoo") {
        return "Yahoo"
    }
    
    if name.containsIgnoringCase(find: "Facebook") {
        return "Facebook"
    }
    
    if name.containsIgnoringCase(find: "Skype") {
        return "Skype"
    }
    
    if name.containsIgnoringCase(find: "apple") {
        return "App Store"
    }
    
    if name.containsIgnoringCase(find: "Instagram") {
        return "Instagram"
    }
    
    if name.containsIgnoringCase(find: "Twitter") {
        return "Twitter"
    }
    
    if name.containsIgnoringCase(find: "Drive") {
        return "Google Drive"
    }
    if name.containsIgnoringCase(find: "Tumblr") {
        return "Tumblr"
    }
    if name.containsIgnoringCase(find: "watch") {
        return "Youtube Video"
    }
    if name.containsIgnoringCase(find: "Youtube") {
        return "Youtube"
    }
    if name.containsIgnoringCase(find: "Pinterest") {
        return "Pinterest"
    }
    if name.containsIgnoringCase(find: "icloud") {
        return "iCloud"
    }
    
    if name.containsIgnoringCase(find: "Linkedin") {
        return "Linkedin"
    }
    if name.containsIgnoringCase(find: "dropbox") {
        return "Dropbox"
    }
    if name.containsIgnoringCase(find: "whatsapp") {
        return "WhatsApp"
    }
    if name.containsIgnoringCase(find: "Flickr") {
        return "Flickr"
    }
    
    if name.containsIgnoringCase(find: "Box") {
        return "Box"
    }
    
    if name.containsIgnoringCase(find: "plus.google") {
        return "Google Plus"
    }
    
    if name.containsIgnoringCase(find: "duckduckgo") {
        return "DuckDuck Go"
    }
    
    if name.containsIgnoringCase(find: "Tiktok") {
        return "Tiktok"
    }
    
    if name.containsIgnoringCase(find: "snapchat") {
        return "Snapchat"
    }
    
    if name.containsIgnoringCase(find: "wechat") {
        return "Wechat"
    }
    
    
    
    
    
    return ""
}

func saveImage(name:String,image:UIImage) {
    
    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    // create a name for your image
    let fileURL = documentsDirectoryURL.appendingPathComponent(name)
    
    
    if FileManager.default.fileExists(atPath: fileURL.path) {
        // delete file
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        } catch {
            print("Could not delete file, probably read-only filesystem")
        }
    }
    
    
    
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try image.pngData()!.write(to: fileURL)
            print("Image Added Successfully")
        } catch {
            print(error)
        }
    } else {
        print("Image Not Added")
    }
}

func saveImageInDocumentDirectory(image: UIImage, fileName: String) -> URL? {
    
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    if let imageData = image.pngData() {
        try? imageData.write(to: fileURL, options: .atomic)
        return fileURL
    }
    return nil
}

func deleteImage(fileName: String) -> URL? {
    
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    if FileManager.default.fileExists(atPath: fileURL.path) {
        // delete file
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        } catch {
            print("Could not delete file, probably read-only filesystem")
        }
    }
    return nil
}

func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
    
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
    let fileURL = documentsUrl.appendingPathComponent(fileName)
    do {
        let imageData = try Data(contentsOf: fileURL)
        return UIImage(data: imageData)
    } catch {}
    return nil
}

func isdigit(value:String)->Bool
{
    if value == "+"{
        return true
    }
    if value >= "0" && value <= "9" {
        return true
    }
    return false
}


func generateBarCodeAztech(_ string: String) -> UIImage {
    
    if !string.isEmpty {
        
        let data = string.data(using: String.Encoding.ascii)
        
        let filter = CIFilter(name: "CIAztecCodeGenerator")
        // Check the KVC for the selected code generator
        filter!.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter?.outputImage?.transformed(by: transform)
        
        return UIImage(ciImage: output!)
    } else {
        return UIImage()
    }
}

func generateBar417Barcode(_ string: String) -> UIImage {
    
    if !string.isEmpty {
        
        let data = string.data(using: String.Encoding.ascii)
        
        let filter = CIFilter(name: "CIPDF417BarcodeGenerator")
        // Check the KVC for the selected code generator
        filter!.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let output = filter?.outputImage?.transformed(by: transform)
        
        return UIImage(ciImage: output!)
    } else {
        return UIImage()
    }
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

func getImage(image:UIImage) -> UIImage?
{
    let image = image
    
    UIGraphicsBeginImageContext(image.size)
    
    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    
    let convertibleImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return convertibleImage
}

func customAttributedString(first: String, second: String, firstColor: UIColor = .black, secondColor: UIColor = .red, firstSize: CGFloat = 20,secondSize: CGFloat = 15) -> NSAttributedString {
    
    let styleAttributes = NSMutableParagraphStyle()
    let stringAttributes:[NSAttributedString.Key: Any] = [.font : (UIFont.boldSystemFont(ofSize: firstSize)),
                                                          .foregroundColor: firstColor,
                                                          .paragraphStyle: styleAttributes]
    
    let stringSecondAttributes:[NSAttributedString.Key: Any] = [.font : (UIFont.systemFont(ofSize: secondSize)),
                                                                .foregroundColor: secondColor,
                                                                .paragraphStyle: styleAttributes]
    
    let string = "  \(first)  ".uppercased()
    let secondString = "\n  \(second)  ".uppercased()
    let mutable = NSMutableAttributedString(string: string, attributes: stringAttributes)
    let secondMutable = NSMutableAttributedString(string: secondString, attributes: stringSecondAttributes)
    mutable.append(secondMutable)
    var startIndex = mutable.string.startIndex
    while let range = mutable.string.range(of: "\\n", options: .regularExpression, range: startIndex..<mutable.string.endIndex) {
        mutable.addAttribute(.backgroundColor, value: UIColor.yellow, range: NSRange(Range(uncheckedBounds: (lower: startIndex, upper: range.lowerBound)), in:  mutable.string))
        startIndex = range.upperBound
    }
    mutable.addAttribute(.backgroundColor, value: UIColor.red, range: NSRange(Range(uncheckedBounds: (lower: startIndex, upper:  mutable.string.endIndex)), in:  mutable.string))
    return mutable
}

func decodeData(codeString:String) {
    
    var aStr = codeString.replacingOccurrences(of: "BEGIN:VEVENT", with: "")
    aStr = aStr.replacingOccurrences(of: "\n", with: "")
    aStr = aStr.replacingOccurrences(of: "SUMMARY:", with: "")
    aStr = aStr.replacingOccurrences(of: "LOCATION:", with: "_")
    aStr = aStr.replacingOccurrences(of: "DTSTART:", with: "_")
    aStr = aStr.replacingOccurrences(of: "DTEND:", with: "_")
    aStr = aStr.replacingOccurrences(of: "END:VEVENT", with: "")
}

func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.utf8)
    
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 7, y: 7)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
    }
    
    return nil
}



extension UIApplication {
    /// The top most view controller
    static var topMostViewController: UIViewController? {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.visibleViewController
    }
}

extension UIViewController {
    /// The visible view controller from a given view controller
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
}


extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
            .range(of: string, options: options) {
            indices.append(range.lowerBound)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
            .range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

struct EmailParameters {
    /// Guaranteed to be non-empty
    let toEmails: [String]
    let ccEmails: [String]
    let bccEmails: [String]
    let subject: String?
    let body: String?
    
    
    /// Defaults validation is just verifying that the email is not empty.
    static func defaultValidateEmail(_ email: String) -> Bool {
        return !email.isEmpty
    }
    
    /// Returns `nil` if `toEmails` contains at least one email address validated by `validateEmail`
    /// A "blank" email address is defined as an address that doesn't only contain whitespace and new lines characters, as defined by CharacterSet.whitespacesAndNewlines
    /// `validateEmail`'s default implementation is `defaultValidateEmail`.
    init?(
        toEmails: [String],
        ccEmails: [String],
        bccEmails: [String],
        subject: String?,
        body: String?,
        validateEmail: (String) -> Bool = defaultValidateEmail
    ) {
        func parseEmails(_ emails: [String]) -> [String] {
            return emails.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter(validateEmail)
        }
        let toEmails = parseEmails(toEmails)
        let ccEmails = parseEmails(ccEmails)
        let bccEmails = parseEmails(bccEmails)
        if toEmails.isEmpty {
            return nil
        }
        self.toEmails = toEmails
        self.ccEmails = ccEmails
        self.bccEmails = bccEmails
        self.subject = subject
        self.body = body
    }
    
    /// Returns `nil` if `scheme` is not `mailto`, or if it couldn't find any `to` email addresses
    /// `validateEmail`'s default implementation is `defaultValidateEmail`.
    /// Reference: https://tools.ietf.org/html/rfc2368
    init?(url: URL, validateEmail: (String) -> Bool = defaultValidateEmail) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        let queryItems = urlComponents.queryItems ?? []
        func splitEmail(_ email: String) -> [String] {
            return email.split(separator: ",").map(String.init)
        }
        let initialParameters = (toEmails: urlComponents.path.isEmpty ? [] : splitEmail(urlComponents.path), subject: String?(nil), body: String?(nil), ccEmails: [String](), bccEmails: [String]())
        let emailParameters = queryItems.reduce(into: initialParameters) { emailParameters, queryItem in
            guard let value = queryItem.value else {
                return
            }
            switch queryItem.name {
            case "to":
                emailParameters.toEmails += splitEmail(value)
            case "cc":
                emailParameters.ccEmails += splitEmail(value)
            case "bcc":
                emailParameters.bccEmails += splitEmail(value)
            case "subject" where emailParameters.subject == nil:
                emailParameters.subject = value
            case "body" where emailParameters.body == nil:
                emailParameters.body = value
            default:
                break
            }
        }
        self.init(
            toEmails: emailParameters.toEmails,
            ccEmails: emailParameters.ccEmails,
            bccEmails: emailParameters.bccEmails,
            subject: emailParameters.subject,
            body: emailParameters.body,
            validateEmail: validateEmail
        )
    }
}


extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


extension UILabel{
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}


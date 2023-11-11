//
//  CustomizeDesignViewController.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 6/7/23.
//

import UIKit
import QRCode


protocol sendImage {
    func sendScreenSort(image: UIImage ,position: String,shape:String,logo:UIImage?,color1:UIColor,color2:UIColor)
}

class CustomizeDesignViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var imv: UIImageView!
    var delegate: sendImage?
    @IBOutlet weak var logoImv: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let path1 = Bundle.main.path(forResource: "Category", ofType: "plist")
    var categoryPlist:NSArray! = nil
    var stringValue:String = ""
    
    var storedOffsets = [Int: CGFloat]()
    let positionMaker = ""
    
    let doc = QRCode.Document()
    
    @IBOutlet weak var screenSortView: UIView!
    
    var position = "square"
    var shape = "square"
    var logoImage:UIImage? = nil
    var foreGroundColor = UIColor.black
    var backgroundColor = UIColor.clear
    var isFromForGround  = true
    var currenttag = -1
    var currentIndex = -1
    
    
    @IBAction func gotoSave(_ sender: Any) {
        
        delegate?.sendScreenSort(image: imv.image!,position: position,shape:shape,logo: logoImage,color1: foreGroundColor,color2: backgroundColor)
        self.dismiss(animated: true)
        
        
        
    }
    
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        
        if isFromForGround {
            foreGroundColor = viewController.selectedColor
        }
        else {
            backgroundColor = viewController.selectedColor
        }
        self.updateAll()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("nosto")
        return .darkContent
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //DBmanager.shared.initDB()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.clear
        categoryPlist = NSArray(contentsOfFile: path1!)
        self.setColor()
        
        tableView.register(UINib(nibName: "HeaderViewTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderViewTableViewCell")
        
        
        doc.utf8String =  stringValue
        doc.errorCorrection = .high
        
        
        doc.design.backgroundColor(UIColor.clear.cgColor)
        
        
        for item in categoryPlist {
            print(item)
        }
        
        // Set the foreground color to blue
        self.updateAll()
        
        let image = doc.uiImage(CGSize(width: 1000, height: 1000), dpi: 216)
        imv.image = image
        
        self.setColor()
        // Do any additional setup after loading the view.
    }
    
    func updatePosition(name:String) {
        
        position  = name
        
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
        
        shape  = name
        
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
    
    
    func imageWithColor(color: UIColor, size: CGSize=CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    func setColor() {
        backgroundColorValue.removeAll()
        backgroundColorValue.append(UIColor.clear)
        backgroundColorValue.append(UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 97.0/255.0, green: 97.0/255.0, blue: 97.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 236.0/255.0, green: 64.0/255.0, blue: 122.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 66.0/255.0, green: 165.0/255.0, blue: 245.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 38.0/255.0, green: 198.0/255.0, blue: 218.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 102.0/255.0, green: 187.0/255.0, blue: 106.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 212.0/255.0, green: 225.0/255.0, blue: 87.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 255.0/255.0, green: 202.0/255.0, blue: 40.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 255.0/255.0, green: 112.0/255.0, blue: 67.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 120.0/255.0, green: 144.0/255.0, blue: 156.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 251.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 253.0/255.0, green: 216.0/255.0, blue: 53.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 124.0/255.0, green: 179.0/255.0, blue: 66.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 0.0/255.0, green: 137.0/255.0, blue: 123.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 3.0/255.0, green: 155.0/255.0, blue: 229.0/255.0, alpha: 1.0))
        backgroundColorValue.append(UIColor(red: 229/255.0, green: 57.0/255.0, blue: 53.0/255.0, alpha: 1.0))
        
    }
    
    func getImage(path:String)->UIImage? {
        
        if path.count < 1 {
            return nil
        }
        
        
        let index = Int(path)
        let value = "Logo"
        
        var tempArray: [String] = []
        var imGW:UIImage! = UIImage(named: "")
        if  let path2 =  Bundle.main.path(forResource: value, ofType: nil) {
            
            do {
                try  tempArray =  FileManager.default.contentsOfDirectory(atPath: path2) as [String]
            } catch {
            }
            
            tempArray = tempArray.sorted()
            
            
            
            if let filename  = tempArray[index ?? 0] as? String {
                let imagePath = "\(path2)/\(filename)"
                imGW = UIImage(named: imagePath)
                return imGW
            }
        }
        return nil
        
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
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func updateAll() {
        
        self.updatePosition(name: position)
        self.updateShape(name: shape)
        
        if let v = logoImage {
            self.updateImage(imGW: v)
        }
        else {
            doc.logoTemplate = nil
        }

        doc.design.backgroundColor(backgroundColor.cgColor)
        doc.design.foregroundColor(foreGroundColor.cgColor)
        let path = doc.path(CGSize(width: 1000, height: 1000))
        let image = doc.uiImage(CGSize(width: 1000, height: 1000), dpi: 216)
        imv.image = image
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension CustomizeDesignViewController: UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell else { return TableViewCell()}
        
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        return categoryPlist.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        var ma  = indexPath.section
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: ma )
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
        
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
        
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = self.tableView.dequeueReusableCell(withIdentifier: "HeaderViewTableViewCell")  as! HeaderViewTableViewCell
        
        view.label.text = categoryPlist[section] as? String
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: 70, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionView.tag == categoryPlist.count - 1 || collectionView.tag == categoryPlist.count - 2  {
            return backgroundColorValue.count + 1
        }
        
        
        let value  = categoryPlist[collectionView.tag] as? String
        
        var tempArray: [String] = []
        if  let path =  Bundle.main.path(forResource: value, ofType: nil) {
            
            do {
                try  tempArray =  FileManager.default.contentsOfDirectory(atPath: path) as [String]
            } catch {
            }
            
        }
        tempArray = tempArray.sorted()
        return tempArray.count
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageViewCell else { return UICollectionViewCell () }
        
        
        
        let value  = categoryPlist[collectionView.tag] as? String
        print("mamama \(collectionView.tag)")
        
        
        
        if collectionView.tag == categoryPlist.count - 1 || collectionView.tag == categoryPlist.count - 2 {
            
            if indexPath.row > 0 {
                cell.imv.image = self.imageWithColor(color: backgroundColorValue[indexPath.row - 1], size: CGSize(width: 170, height: 170))
            }
            else {
                cell.imv.image = UIImage(named: "RGB_Color")
            }
            
        }
        
        else {
            var tempArray: [String] = []
            if  let path =  Bundle.main.path(forResource: value, ofType: nil) {
                
                do {
                    try  tempArray =  FileManager.default.contentsOfDirectory(atPath: path) as [String]
                } catch {
                }
                tempArray = tempArray.sorted()
                
                let filename = tempArray[indexPath.row]
                
                if let value  = tempArray[indexPath.row] as? String {
                    let imagePath = "\(path)/\(filename)"
                    var image = UIImage(named: imagePath)
                    cell.imv.image = image
                    
                }
                
            }
        }
        
         
        
        if currenttag == collectionView.tag, indexPath.row == currentIndex {
            cell.dropShadowWithCornerRaduis(shouldShow: true)
        }
        else {
            cell.dropShadowWithCornerRaduis(shouldShow: false)
        }
        ///cell.backgroundColor = UIColor.red
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        var v:Int = Int((self.view.frame.size.width - 15)/70)
        v = v - 1
        print("dhur1= \(v)")
        var  v1 = Double(self.view.frame.width - 15)
        v1 = (v1 - Double(v*70)-35)
        
        v1 = v1 / Double((v))
        
        print("dhur= \(v1)")
        return v1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        currenttag = collectionView.tag
        currentIndex = indexPath.row
        if collectionView.tag == categoryPlist.count - 1  {
            isFromForGround = false
            if indexPath.row > 0 {
                backgroundColor = backgroundColorValue[indexPath.row - 1]
            }
            else {
                
                // Initializing Color Picker
                if #available(iOS 14.0, *) {
                    let picker = UIColorPickerViewController()
                    picker.selectedColor = self.view.backgroundColor!
                    picker.delegate = self
                    self.present(picker, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                }

                // Setting the Initial Color of the Picker
               
                
            }
            
        }
        else if collectionView.tag == categoryPlist.count - 2 {
            isFromForGround = true
            if indexPath.row > 0 {
                foreGroundColor = backgroundColorValue[indexPath.row - 1]
            } else {
                
                if #available(iOS 14.0, *) {
                    let picker = UIColorPickerViewController()
                    picker.selectedColor = self.view.backgroundColor!
                    picker.delegate = self
                
                    self.present(picker, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else {
            
            let value  = categoryPlist[collectionView.tag] as? String
            
            
            var tempArray: [String] = []
            if  let path =  Bundle.main.path(forResource: value, ofType: nil) {
                
                do {
                    try  tempArray =  FileManager.default.contentsOfDirectory(atPath: path) as [String]
                } catch {
                }
                
                tempArray = tempArray.sorted()
                let filename = tempArray[indexPath.row]
                
                if let m = categoryPlist[collectionView.tag] as? String {
                    
                    if m.contains(find: "Position") {
                        position = filename
                    }
                    else if m.contains(find: "Logo") {
                         let  logo1 = "\(indexPath.row)"
                        if indexPath.row == 0 {
                            logoImage = nil
                        } else {
                            logoImage = self.getImage(path: logo1)
                        }
                        
                        
                    }
                    else {
                        shape =  filename
                    }
                    
                    
                }
                
            }
            
        }
        self.updateAll()
        collectionView.reloadData()
    }
}


extension UIView{
    func dropShadowWithCornerRaduis(shouldShow:Bool = false) {
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        if shouldShow {
            layer.borderWidth = 3.0
            layer.borderColor = tabBarBackGroundColor.withAlphaComponent(0.5).cgColor
        }
        else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        }
    }
}



extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}



extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func set(_ value: UIColor?, forKey key: String) {
        
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
        
    }
    
}

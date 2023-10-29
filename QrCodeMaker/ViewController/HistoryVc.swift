//
//  HistoryVc.swift
//  QrCode&BarCode
//
//  Created by Macbook pro 2020 M1 on 24/2/23.
//

import UIKit

class HistoryVc: UIViewController {
    
    @IBOutlet weak var topView1: UIView!
    @IBOutlet weak var scanLabel: UILabel!
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var heightForFolderView: NSLayoutConstraint!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var leadingSpaceColorView: NSLayoutConstraint!
    
    
    @IBOutlet weak var scannedLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var currentIndexPath =  "1"
    let searchActive = false
    var shouldToggle = -20
    var editModeActive = false
    
    var databaseArray: [DataInformation] = []
    var folderArray: [DataInformation] = []
    var filterArray: [DataInformation] = []
    
    
    
    @IBOutlet weak var collectionViewForFolder: UICollectionView!
    
    
     
    @IBAction func gotoScanPage(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeTab"), object: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseArray = DBmanager.shared.getRecordInfo(indexPath: currentIndexPath)
        tableView.reloadData()
       topView.roundCorners([.bottomRight, .bottomLeft], radius: 10)
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData2(notification:)), name:NSNotification.Name(rawValue: "delete"), object: nil)
        
       
        searchbar.searchBarStyle = .minimal
        searchbar.backgroundColor =  UIColor.clear
        searchbar.searchTextField.backgroundColor =  UIColor(red: 245.0/255, green: 244.0/255, blue: 244.0/255, alpha: 1.0)
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        searchbar.searchTextField.inputAccessoryView = keyboardToolbar
    }
    
    
    @objc func dismissKeyboard() {
        searchbar.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        holderView.layer.cornerRadius = 15.0
        scanLabel.layer.cornerRadius = 10.0
        scanLabel.layer.masksToBounds = true

        
    }
    
    
    @objc func reloadData2(notification: NSNotification) {
        
        if notification.name == NSNotification.Name(rawValue: "delete"){
            
            databaseArray = DBmanager.shared.getRecordInfo(indexPath: currentIndexPath)
            tableView.reloadData()
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("tostos")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Store.sharedInstance.showPickerT = false
        
        
        
        if Store.sharedInstance.currentIndexPath == "1" {
            self.gotoScannedBtn(AnyObject.self)
        }
        else {
            self.gotoCreatedBtn(AnyObject.self)
        }
        databaseArray = DBmanager.shared.getRecordInfo(indexPath: currentIndexPath)
        folderArray = DBmanager.shared.getFolderInfo()
        
        
        if databaseArray.count < 1 {
            topView1.isHidden = false
        }
        
        if folderArray.count < 1 {
            heightForFolderView.constant = 0
        }
        else {
            heightForFolderView.constant = 70
        }
        tableView.reloadData()
        collectionViewForFolder.reloadData()
        Store.sharedInstance.shouldShowHistoryPage = false
        
    }
    
    @IBAction func gotoScannedBtn(_ sender: Any) {
        
        scannedLabel.textColor = UIColor.white
        currentIndexPath = "1"
        Store.sharedInstance.currentIndexPath = currentIndexPath
        databaseArray = DBmanager.shared.getRecordInfo(indexPath: currentIndexPath)
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingSpaceColorView.constant = 30
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.createdLabel.textColor  =   UIColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        })
        
    }
    
    func goResultVc(string: String,id:String,indexPath:String,codeType:String,position:String,shape:String,logo:String) {
        
        let value = QrParser.getBarCodeObj(text: string)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVc") as! ShowResultVc
        vc.stringValue = string
        vc.modalPresentationStyle = .fullScreen
        vc.showText = value
        vc.isfromUpdate = true
        vc.idF = id
        vc.position1 = position
        vc.shape1 =  shape
        vc.currenttypeOfQrBAR = logo
        
        if indexPath == "1" {
            vc.isFromScanned = true
        } else {
            vc.isFromScanned = false
        }
        
        if codeType == "1" {
            vc.isfromQr = true
        }
        else {
            vc.isfromQr = false
        }
        
        UIApplication.topMostViewController?.present(vc, animated: true, completion: {
        })
    }
    
    
    @IBAction func gotoEditBtn(_ sender: Any) {
        
        self.editState()
    }
    
    func editState() {
        selectedIndexList.removeAll()
        shouldToggle =  shouldToggle < 0 ? 15 : -20
        if shouldToggle > 0 {
            editModeActive = true
            editBtn.setTitle("Done", for: .normal)
        }
        else {
            editModeActive = false
            editBtn.setTitle("Edit", for: .normal)
        }
        
        let imageDataDict:[String: Int] = ["image": shouldToggle]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hide"), object: nil, userInfo: imageDataDict)
        tableView.reloadData()
    }
    
    
    
    @IBAction func gotoMakeFolder(_ sender: Any) {
        
        //DBmanager.shared.initDB()
        folderArray = DBmanager.shared.getFolderInfo()
        let alert = UIAlertController(title: "", message: "Enter Folder Name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if (textField?.text!.count)! < 1 {
                
                let refreshAlert = UIAlertController(title: "Alert", message: "Folder name is empty", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            } else {
                let  ar = DBmanager.shared.checkUniqueData(name: (textField?.text)!)
                
                
                if (textField?.text!.count)! < 1 {
                    
                    let refreshAlert = UIAlertController(title: "Alert", message: "Folder name is empty", preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    return
                    
                }
                
                if ar.count > 0 {
                    
                    let refreshAlert = UIAlertController(title: "Alert", message: "Folder name exists Already", preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    return
                    
                }
                
                
                
                currentIndexFolder = -1
                DBmanager.shared.insertIntoFolder(name: (textField?.text)!)
              //  DBmanager.shared.initDB()
                self.folderArray = DBmanager.shared.getFolderInfo()
                
                self.heightForFolderView.constant = 70.0
                self.collectionViewForFolder.reloadData()
            }
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func gotoCreatedBtn(_ sender: Any) {
        DBmanager.shared.initDB()
        currentIndexPath = "2"
        Store.sharedInstance.currentIndexPath = currentIndexPath
        databaseArray = DBmanager.shared.getRecordInfo(indexPath: currentIndexPath)
        tableView.reloadData()
        createdLabel.textColor = UIColor.white
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingSpaceColorView.constant = 30 + self.view.frame.width / 2.0
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.scannedLabel.textColor  =   UIColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        })
    }
    
    @objc func buttonTapped(sender : UIButton) {
        print(sender.tag)
        let value = sender.tag - 1000
        
        var obj:DataInformation!
        obj = databaseArray[value]
        if(searchActive) {
            obj = filterArray[value]
        }
        
        if selectedIndexList.contains(obj.id) {
            
            if let index = selectedIndexList.index(where: {$0 == obj.id}) {
                selectedIndexList.remove(at: index)
            }
        }
        else {
            selectedIndexList.append(obj.id)
        }
        tableView.reloadData()
        //Write button action here
    }
    
}

extension HistoryVc: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!searchActive) {
            return databaseArray.count
        } else {
            return filterArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as!TempTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as!ExpandableCellTableViewCell
        var obj:DataInformation!
        obj = databaseArray[indexPath.row]
        if(searchActive) {
            obj = filterArray[indexPath.row]
        }
        
        var firstString = ""
        var secondString = ""
        
        
        let value = QrParser.getBarCodeObj(text: obj.Text)
        let outputResult1 = value.components(separatedBy: "\n\n") as NSArray
        
        secondString = outputResult1[0] as! String
        
        let temp = secondString
        
        if obj.codeType == "1",outputResult1.count >= 1 {
            let outputResult = value.components(separatedBy: "^") as NSArray
            let topText = (outputResult[1] as? String)!
            firstString = topText
            
            if ((temp.contains(find: "^")) != nil) {
                secondString = (outputResult[0] as? String)!
            }
            
            let newString  = secondString.components(separatedBy: ":") as NSArray
            let trimmedString = (newString[0] as? String)?.trimmingCharacters(in: .whitespaces)
            
            var final = trimmedString! + ":"
            for (index, element) in newString.enumerated() {
                if index > 0 {
                    final = final + ((element as? String)!)
                }
            }
            
            
            
            cell.lbl.text = firstString
            cell.lbl1.text = final
            
            if firstString == "Website" {
                let m = checkWhichUrl(name: secondString)
                if m.count > 0 {
                    cell.lbl.text = m
                }
                
            }else {
                let m = checkWhichUrl(name: secondString)
                if m.containsIgnoringCase(find: "Google Search") {
                    cell.lbl.text = m
                }
            }
        }
        
        else {
            firstString =  "BarCode"
            cell.lbl.text = firstString
            cell.lbl1.text = obj.Text
        }
        
        
        
        
        let a = cell.lbl.bounds.size.height
        let b = cell.lbl1.bounds.size.height
        
        let totalHeight = a+b + 5
        
        cell.topSpaceLabel1.constant = (80 - totalHeight) / 2.0
        let trimmedString = (cell.lbl.text)?.trimmingCharacters(in: .whitespaces)
        let image = trimmedString! + "1"
        cell.imv.image = UIImage(named: image)
        cell.imv.layer.cornerRadius = 10.0
        cell.selectedBtn.tag =  1000 + indexPath.row
        cell.selectedBtn.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        // cell.roundedImv.layer.cornerRadius = cell.roundedImv.frame.width / 2.0
        // cell.roundedImv.layer.borderWidth = 1.0
        // cell.roundedImv.layer.borderColor = UIColor.lightGray.cgColor
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.leadingSpaceConstrain.constant = CGFloat(self.shouldToggle)
            self.view.layoutIfNeeded()
        }, completion: {_ in
            
        })
        
        if editModeActive {
            if selectedIndexList.contains(obj.id) {
                cell.roundedImv.image = UIImage(named: "Green Redio Button")
            }
            else {
                cell.roundedImv.image = UIImage(named: "White Redio Button")
            }
        }
        else {
            cell.roundedImv.image = UIImage(named: "White Redio Button")
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
                   indexPath: IndexPath){
        
        var obj:DataInformation!
        obj = databaseArray[indexPath.row]
        if searchActive {
            obj = filterArray[indexPath.row]
        }
        
        self.goResultVc(string: obj.Text, id: obj.id, indexPath: obj.indexPath, codeType: obj.codeType,position: obj.position,shape: obj.shape,logo: obj.logo)
    }
    
}

extension HistoryVc:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:0, height:0)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CategoryCell
        
        let obj = folderArray[indexPath.row]
        cell?.lblV.text = obj.folderName
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 60)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if editModeActive {
            self.editState() 
        }
        let obj = folderArray[indexPath.row]
        
        let ar = DBmanager.shared.getFolderElements(folderid: obj.folderid)
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FolderDetailVc") as! FolderDetailVc
        vc.databaseArray = ar
        vc.modalPresentationStyle = .fullScreen
        vc.folderName = obj.folderName
        vc.folderId = obj.folderid
        UIApplication.topMostViewController?.present(vc, animated: true, completion: {
        })
        
    }
}


extension UISearchBar {
    var textField: UITextField? {
        return subviews.first?.subviews.first(where: { $0.isKind(of: UITextField.self) }) as? UITextField
    }
}

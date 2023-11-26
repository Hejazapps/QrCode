//
//  HistoryVc.swift
//  QrCode&BarCode
//
//  Created by Macbook pro 2020 M1 on 24/2/23.
//

import UIKit

class HistoryVc: UIViewController {
    
    @IBOutlet weak var topSpaceEmptyView: NSLayoutConstraint!
    @IBOutlet weak var bottomSpacetableView: NSLayoutConstraint!
    @IBOutlet weak var noScanLabel: UILabel!
    @IBOutlet weak var lbl2: UILabel!
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
    var searchActive = false
    var shouldToggle = -20
    var editModeActive = false
    
    var databaseArray: [DataInformation] = []
    var folderArray: [DataInformation] = []
    var filterArray: [DataInformation] = []
    
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
    
    @IBOutlet weak var collectionViewForFolder: UICollectionView!
    
    
    
    @IBAction func gotoScanPage(_ sender: Any) {
        
        
        if Store.sharedInstance.currentIndexPath == "1" {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeTab"), object: nil)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createdTab"), object: nil)
        }
        
        
    }
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("nosto")
        return .darkContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        searchbar.searchBarStyle = .default
        
        searchbar.searchTextField.backgroundColor =  UIColor(red: 243/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        searchbar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "Search", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        searchbar.searchTextField.textColor = UIColor.black
        
        
        searchbar.isTranslucent = true
        searchbar.alpha = 1
        searchbar.backgroundImage = UIImage()
        searchbar.barTintColor = UIColor.clear
        
        
      
        
        DBmanager.shared.getRecordInfo(indexPath: currentIndexPath) { [weak self] value in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            databaseArray = value
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                print("hi3")
                tableView.reloadData()
            }
        }
        
        
        topView.roundCorners([.bottomRight, .bottomLeft], radius: 10)
        
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        searchbar.searchTextField.inputAccessoryView = keyboardToolbar
    }
    
    
    func updateAll () {
        
        searchbar.showsCancelButton = false
        if #available(iOS 13.0, *) {
            searchbar.searchTextField.resignFirstResponder()
        } else {
            searchbar.textField?.resignFirstResponder()
        }
        searchbar.text = ""
        bottomSpacetableView.constant = 0
    }
    
    
    @objc func dismissKeyboard() {
        editBtn.isHidden = false
        self.updateAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        holderView.layer.cornerRadius = 15.0
        scanLabel.layer.cornerRadius = 10.0
        scanLabel.layer.masksToBounds = true
    }
    
    
    @objc func reloadData2(notification: NSNotification) {
        
        if notification.name == NSNotification.Name(rawValue: "delete"){
            DBmanager.shared.getRecordInfo(indexPath: currentIndexPath) { [weak self] value in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                
                databaseArray = value
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else {
                        print("Can't make self strong!")
                        return
                    }
                    
                    print("Hi")
                    tableView.reloadData()
                }
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        print("tostos")
    }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchActive  = false
        Store.sharedInstance.showPickerT = false
        Store.sharedInstance.isFromHistory = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData2(notification:)), name:NSNotification.Name(rawValue: "delete"), object: nil)
        
        
        setNeedsStatusBarAppearanceUpdate()
        
        if Store.sharedInstance.currentIndexPath == "1" {
            scanLabel.text = "Scan"
            lbl2.text = "Scan Your Code"
            noScanLabel.text = "No Scans Yet"
            self.gotoScannedBtn(AnyObject.self)
        }
        else {
            scanLabel.text = "Create"
            lbl2.text = "Create Your Code"
            noScanLabel.text = "No created code Yet"
            self.gotoCreatedBtn(AnyObject.self)
        }
        
        DBmanager.shared.getRecordInfo(indexPath: currentIndexPath) { [weak self] value in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            databaseArray = value
            filterArray = databaseArray
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                
                if databaseArray.count < 1 {
                    topView1.isHidden = false
                } else {
                    topView1.isHidden = true
                }
                print("hi1")
                tableView.reloadData()
                collectionViewForFolder.reloadData()
            }
        }
        
        DBmanager.shared.getFolderInfo() { [weak self] value in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            folderArray = value
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                
                if folderArray.count < 1 {
                    heightForFolderView.constant = 0
                }
                else {
                    heightForFolderView.constant = 70
                }
                
                print("hi6")
                tableView.reloadData()
                collectionViewForFolder.reloadData()
            }
        }
//        databaseArray = DBmanager.shared.getRecordInfo(indexPath: currentIndexPath)
//        folderArray = DBmanager.shared.getFolderInfo()
        
        Store.sharedInstance.shouldShowHistoryPage = false
        
        editBtn.isHidden = false
        print("asche")
        
    }
    
    @IBAction func gotoScannedBtn(_ sender: Any) {
        self.updateAll()
        scannedLabel.textColor = UIColor.white
        currentIndexPath = "1"
        Store.sharedInstance.currentIndexPath = currentIndexPath
        
        DBmanager.shared.getRecordInfo(indexPath: currentIndexPath) { [weak self] value in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            databaseArray.removeAll()
            
            for item in value {
                databaseArray.append(item)
            }
            
            print("createBtn22  \(value.count)")
            print("createBtn2  \(databaseArray.count)")
            databaseArray = value
            filterArray = databaseArray
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                
                if databaseArray.count < 1 {
                    topView1.isHidden = false
                }
                else {
                    topView1.isHidden = true
                }
                print("hi7")
                tableView.reloadData()
            }
        }
        
        scanLabel.text = "Scan"
        lbl2.text = "Scan Your Code"
        noScanLabel.text = "No Scans Yet"
        
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
        print("dhuksec")
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
        print("hi4")
        tableView.reloadData()
    }
    
    
    
    @IBAction func gotoMakeFolder(_ sender: Any) {
        
        
        if !Store.sharedInstance.isActiveSubscription() {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionVc") as! SubscriptionVc
            initialViewController.modalPresentationStyle = .fullScreen
            self.present(initialViewController, animated: true, completion: nil)
            return
            
        }
        
        DBmanager.shared.getFolderInfo() { [weak self] value in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            folderArray = value
        }
        
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
                    self.editBtn.isHidden = false
                    self.bottomSpacetableView.constant = 0
                }))
                self.present(refreshAlert, animated: true, completion: nil)
            } else {
                DBmanager.shared.checkUniqueData(name: (textField?.text)!) { [weak self] ar in
                    guard let self else {
                        print("Can't make self strong!")
                        return
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self else {
                            print("Can't make self strong!")
                            return
                        }
                        
                        if (textField?.text!.count)! < 1 {
                            
                            let refreshAlert = UIAlertController(title: "Alert", message: "Folder name is empty", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action: UIAlertAction!) in
                                guard let self else {
                                    print("Can't make self strong!")
                                    return
                                }
                                
                                bottomSpacetableView.constant = 0
                                editBtn.isHidden = false
                            }))
                            present(refreshAlert, animated: true, completion: nil)
                            
                            return
                            
                        }
                        
                        if ar.count > 0 {
                            
                            let refreshAlert = UIAlertController(title: "Alert", message: "Folder name exists Already", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                print("Handle Ok logic here")
                                self.bottomSpacetableView.constant = 0
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                            return
                            
                        }
                    }
                    
                    currentIndexFolder = -1
                    
                    DBmanager.shared.insertIntoFolder(name: (textField?.text)!)
                    DBmanager.shared.getFolderInfo() { [weak self] value in
                        guard let self else {
                            print("Can't make self strong!")
                            return
                        }
                        
                        folderArray = value
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self else {
                                print("Can't make self strong!")
                                return
                            }
                            
                            heightForFolderView.constant = 70.0
                            collectionViewForFolder.reloadData()
                            bottomSpacetableView.constant = 0
                            editBtn.isHidden = false
                        }
                    }
                }
            }
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            self.bottomSpacetableView.constant = 0
            self.editBtn.isHidden = false
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func gotoCreatedBtn(_ sender: Any) {
        self.updateAll()
       
        
        currentIndexPath = "2"
        Store.sharedInstance.currentIndexPath = currentIndexPath
        DBmanager.shared.getRecordInfo(indexPath: currentIndexPath) { [weak self] value in
            guard let self else {
                print("Can't make self strong!")
                return
            }
            
            
            databaseArray.removeAll()
            
            for item in value {
                databaseArray.append(item)
            }
            
            
            print("createBtn1  \(value.count)")
            
            
            filterArray = databaseArray
            
            print("createBtn11  \(databaseArray.count)")
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                
                print("hi2")
                tableView.reloadData()
                
                if databaseArray.count < 1 {
                    topView1.isHidden = false
                }
                else {
                    topView1.isHidden = true
                }
            }
        }
        
        
        scanLabel.text = "Create"
        lbl2.text = "Create Your Code"
        noScanLabel.text = "No created code"
        
        createdLabel.textColor = UIColor.white
        UIView.animate(withDuration: 0.2, animations: {
            self.leadingSpaceColorView.constant = 30 + self.view.frame.width / 2.0
            self.view.layoutIfNeeded()
        }, completion: {_ in
            self.scannedLabel.textColor  =   UIColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        })
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        editBtn.isHidden = true
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomSpacetableView.constant = keyboardHeight - 70
            searchActive = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            if editModeActive {
                self.editState()
            }
        }
        
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
        print("hi5")
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
        
        self.updateAll()
        var obj:DataInformation!
        obj = databaseArray[indexPath.row]
        if searchActive {
            print("dhukse search")
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
        cell?.lblV.textColor = UIColor.black
        
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
        
        DBmanager.shared.getFolderElements(folderid: obj.folderid) { ar in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FolderDetailVc") as! FolderDetailVc
                vc.databaseArray = ar
                vc.modalPresentationStyle = .fullScreen
                vc.folderName = obj.folderName
                vc.folderId = obj.folderid
                UIApplication.topMostViewController?.present(vc, animated: true, completion: {
                })
            }
        }
    }
}


extension UISearchBar {
    var textField: UITextField? {
        return subviews.first?.subviews.first(where: { $0.isKind(of: UITextField.self) }) as? UITextField
    }
}


extension HistoryVc: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        editBtn.isHidden  = false
        searchActive = false
        self.updateAll()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchActive  = true
        filterArray.removeAll()
        
        for obj in databaseArray {
            
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
                
                secondString = final
                
                if firstString == "Website" {
                    let m = checkWhichUrl(name: secondString)
                    if m.count > 0 {
                        firstString = m
                    }
                    
                }else {
                    let m = checkWhichUrl(name: secondString)
                    if m.containsIgnoringCase(find: "Google Search") {
                        secondString = m
                    }
                }
            }
            
            else {
                firstString =  "BarCode"
                secondString = obj.Text
            }
            
            
            if firstString.containsIgnoringCase(find: searchText) || secondString.containsIgnoringCase(find: searchText)
            {
                filterArray.append(obj)
            }
            
        }
        
        if(searchText.count == 0)
        {
            DBmanager.shared.getRecordInfo(indexPath: currentIndexPath) { [weak self] value in
                guard let self else {
                    print("Can't make self strong!")
                    return
                }
                
                databaseArray = value
                filterArray = databaseArray
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else {
                        print("Can't make self strong!")
                        return
                    }
                    
                    self.historyTableView.reloadData()
                }
            }
        }
        
        self.historyTableView.reloadData()
    }
}

//
//  FolderDetailVc.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 22/7/23.
//

import UIKit

class FolderDetailVc: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var bottomSpaceTableView: NSLayoutConstraint!
    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var bottomSpaceOfBottomView: NSLayoutConstraint!
    
    @IBOutlet weak var folderDetailTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    var searchActive = false
    var folderName = ""
    var folderId = ""
    var shouldToggle = -20
    var editModeActive = false
    
    var databaseArray: [DataInformation] = []
    var filterArray: [DataInformation] = []
    let allViewsInXibArray = Bundle.main.loadNibNamed("ButtonView", owner: self, options: nil)
    var myView1:ButtonView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("nosto")
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = folderName
        
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData2(notification:)), name:NSNotification.Name(rawValue: "delete"), object: nil)
        myView1 = allViewsInXibArray?.first as! ButtonView
        
        bottomView.addSubview(myView1)
        
        let imageDataDict:[String: String] = ["": ""]
        NotificationCenter.default.addObserver(self, selector:#selector(updateName(notification:)), name:NSNotification.Name(rawValue: "updateFolder"), object: nil)
        
        
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        searchBar.searchTextField.inputAccessoryView = keyboardToolbar
        searchBar.delegate  = self
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if editModeActive {
            self.editState()
        }
        self.reloadData1()
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomSpaceTableView.constant = keyboardHeight
            searchActive = true
        }
        
       
        
    }
    
    
    func updateAll () {
        searchActive =  false
        databaseArray = DBmanager.shared.getFolderElements(folderid: folderId)
        searchBar.showsCancelButton = false
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.resignFirstResponder()
        } else {
            searchBar.textField?.resignFirstResponder()
        }
        searchBar.text = ""
        self.folderDetailTableView.reloadData()
        bottomSpaceTableView.constant = 0
    }
    
    
    @objc func dismissKeyboard() {
        
        self.updateAll()
    }
    
    @objc func reloadData2(notification: NSNotification) {
        
        if notification.name == NSNotification.Name(rawValue: "delete"){
            
            self.reloadData1()
            
        }
        
    }
    
    
    @objc func updateName(notification: NSNotification) {
        print("testful")
        
        if let info = notification.userInfo as? Dictionary<String,String> {
            
            
            if let v  = notification.userInfo?["string"] as? String {
                 
                let array = v.components(separatedBy: ",")
                
                if let v = array[1] as? String {
                    folderName = v
                    titleLabel.text = folderName
                }
                
                
                if let v1 = array[0] as? String {
                    
                    folderId = v1
                    selectedIndexList.removeAll()
                    self.reloadData1()
                }
                
            }
             
            
        }
        
    }
    
    
    func editState() {
        selectedIndexList.removeAll()
        shouldToggle =  shouldToggle < 0 ? 15 : -20
        if shouldToggle > 0 {
            editModeActive = true
            editbtn.setTitle("Done", for: .normal)
            bottomSpaceOfBottomView.constant = 0
            bottomSpaceTableView.constant = 90
        }
        else {
            editModeActive = false
            editbtn.setTitle("Edit", for: .normal)
            bottomSpaceOfBottomView.constant = -1000
            bottomSpaceTableView.constant = 0
        }
        
        let imageDataDict:[String: Int] = ["image": shouldToggle]
        
        folderDetailTableView.reloadData()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myView1.frame = bottomView.bounds
    }
    
    
    @IBAction func gotoEditBtn(_ sender: Any) {
        
        self.editState()
    }
    
    func reloadData1() {
        
        databaseArray = DBmanager.shared.getFolderElements(folderid: folderId)
        filterArray = databaseArray
        folderDetailTableView.reloadData()
        
    }
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //DBmanager.shared.initDB()
        setNeedsStatusBarAppearanceUpdate()
        Store.sharedInstance.isFromHistory = false
        
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
        folderDetailTableView.reloadData()
        //Write button action here
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
        self.present(vc, animated: true)
    }
    
}



extension FolderDetailVc: UITableViewDelegate,UITableViewDataSource  {
    
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
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
            let alert = UIAlertController(
                title: "Warning",
                message: "Do you want to delete the file",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) -> Void in
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [self] (alert) -> Void in
                
                
                var obj:DataInformation!
                obj = self.databaseArray[indexPath.row]
                if(self.searchActive) {
                    obj = self.filterArray[indexPath.row]
                }
               
                DBmanager.shared.deleteFile(id: obj.id)
            
                //DBmanager.shared.initDB()
                reloadData1()
                
            }))
            
            self.present(alert, animated: true)
            
        } else if editingStyle == .insert {
            // Not used in our example, but if you were adding a new row, this is where you would do it.
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
            obj = filterArray[indexPath.row]
        }
        
        self.goResultVc(string: obj.Text, id: obj.id, indexPath: obj.indexPath, codeType: obj.codeType,position: obj.position,shape: obj.shape,logo: obj.logo)
    }
    
}


extension FolderDetailVc: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.updateAll()
        
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("asche")
        
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
            databaseArray = DBmanager.shared.getFolderElements(folderid: folderId)
            filterArray = databaseArray
            
        }
        self.folderDetailTableView.reloadData()
        
        
        
        
    }
}

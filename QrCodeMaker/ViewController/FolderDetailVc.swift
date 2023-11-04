//
//  FolderDetailVc.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 22/7/23.
//

import UIKit

class FolderDetailVc: UIViewController {
    
    
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var bottomSpaceOfBottomView: NSLayoutConstraint!
    
    @IBOutlet weak var folderDetailTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    let searchActive = false
    var folderName = ""
    var folderId = ""
    
    var databaseArray: [DataInformation] = []
    var filterArray: [DataInformation] = []
    let allViewsInXibArray = Bundle.main.loadNibNamed("ButtonView", owner: self, options: nil)
    var myView1:ButtonView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = folderName
        
        
        myView1 = allViewsInXibArray?.first as! ButtonView
        
        bottomView.addSubview(myView1)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myView1.frame = bottomView.bounds
    }
    
    
    @IBAction func gotoEditBtn(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4) {
            self.bottomSpaceOfBottomView.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func reloadData() {
        
        databaseArray = DBmanager.shared.getFolderElements(folderid: folderId)
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
                reloadData()
                
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
        
        if obj.codeType == "1" {
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
        cell.selectionStyle = .none
        
        
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

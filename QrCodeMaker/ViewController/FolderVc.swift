//
//  FolderVcViewController.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 22/7/23.
//

import UIKit

class FolderVc: UIViewController {
    
    
    var folderArray: [DataInformation] = []
    
    
    @IBOutlet weak var folderTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        folderArray = DBmanager.shared.getFolderInfo()
        folderTableView.reloadData()
        //DBmanager.shared.initDB()
        
    }
    
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    func sendData() {
        let ar = DBmanager.shared.getFolderElements(folderid: "\(currentIndexFolder)")
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FolderDetailVc") as! FolderDetailVc
        vc.databaseArray = ar
        vc.modalPresentationStyle = .fullScreen
        vc.folderName = currentFolderName
        vc.folderId = "\(currentIndexFolder)"
        UIApplication.topMostViewController?.present(vc, animated: true, completion: {
        })
    }
    
    
    @IBAction func gotoSave(_ sender: Any) {
        
        
        
        if selectedIndexList.count < 1 {
            
            let alert = UIAlertController(
                title: "Warning",
                message: "No file has been selected",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) -> Void in
                
            }))
            
            self.present(alert, animated: true)
            
            return
            
        }
        
        if currentIndexFolder  < 0 {
            
            let alert = UIAlertController(
                title: "Warning",
                message: "No folder has been selected",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) -> Void in
                
            }))
            
            self.present(alert, animated: true, completion: {
                
            })
            return
            
        }
        
        let alert = UIAlertController(title: "", message: "Do you want to move the selected files to folder", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            
            
            
            for item in selectedIndexList {
                DBmanager.shared.updateFolderInfo(id: "\(item)", folderid: "\(currentIndexFolder)")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "delete"), object: nil)
            
            
            self.dismiss(animated: true) {
                self.sendData()
            }
            
            
            
            
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
            
            
        })
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
        
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

extension FolderVc: UITableViewDelegate,UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as!TempTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as!ExpandableCellTableViewCell
        cell.lbl.text = folderArray[indexPath.row].folderName
        let obj = folderArray[indexPath.row]
        
        if Int(obj.folderid) ?? 0 == currentIndexFolder {
            cell.roundedImv.image = UIImage(named: "Green Redio Button")
        }
        else {
            cell.roundedImv.image = UIImage(named: "White Redio Button")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
                   indexPath: IndexPath){
        
        let obj = folderArray[indexPath.row]
        
        currentIndexFolder = Int(obj.folderid) ?? 0
        currentFolderName = obj.folderName
        folderTableView.reloadData()
        
    }
    
}


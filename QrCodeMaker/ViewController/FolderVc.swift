//
//  FolderVcViewController.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 22/7/23.
//

import UIKit

class FolderVc: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var folderArray: [DataInformation] = []
    var filterArray: [DataInformation] = []
    var searchactive = false
    
    
    @IBOutlet weak var folderTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.searchBarStyle = .default
        
        searchBar.searchTextField.backgroundColor =  UIColor(red: 243/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "Search", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        searchBar.searchTextField.textColor = UIColor.black
        
        
        searchBar.isTranslucent = true
        searchBar.alpha = 1
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
        searchBar.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        folderArray = DBmanager.shared.getFolderInfo()
        filterArray = folderArray
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
                
                if Store.sharedInstance.isFromHistory {
                    self.sendData()
                }
                var a = "\(currentIndexFolder)" + "," + currentFolderName
                
                
                let imageDataDict:[String: String] = ["string": a]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateFolder"), object: nil, userInfo: imageDataDict)
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
        
        if searchactive {
            return  filterArray.count
        }
        
        return folderArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as!TempTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as!ExpandableCellTableViewCell
      
        var obj = folderArray[indexPath.row]
        
        if searchactive {
            obj = filterArray[indexPath.row]
        }
        
        cell.lbl.text = obj.folderName
        
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
        
        var obj = folderArray[indexPath.row]
        if searchactive {
            obj = filterArray[indexPath.row]
        }
        
        currentIndexFolder = Int(obj.folderid) ?? 0
        currentFolderName = obj.folderName
        folderTableView.reloadData()
        
    }
    
}


extension FolderVc: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         
        searchactive = false
        folderTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        searchactive =  true
        
        filterArray.removeAll()
        
        for item in folderArray {
            
            if item.folderName.containsIgnoringCase(find: searchText) {
                
                filterArray.append(item)
            }
        }
        
        print(searchText)
        print(filterArray)
        
        for item in filterArray {
            print("yes = \(item.folderName)")
        }
        if(searchText.count == 0)
        {
            folderArray = DBmanager.shared.getFolderInfo()
            filterArray = folderArray
            
        }
        folderTableView.reloadData()
        
    }
}

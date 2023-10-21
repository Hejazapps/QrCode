//
//  ButtonView.swift
//  QrCode&BarCode
//
//  Created by Sadiq on 6/7/23.
//

import UIKit

class ButtonView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    
    
    
    @IBAction func gotoMove(_ sender: Any) {
        
        
        let  vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FolderVc") as! FolderVc
        vc.modalPresentationStyle = .fullScreen
        
        UIApplication.topMostViewController?.present(vc, animated: true, completion: {
            
        })
        
    }
    
    func createCsvFile() {
        
        var index  = 1
        var employeeArray:[Dictionary<String, String>] =  Array()
        for item in selectedIndexList {
            
            if let value = DBmanager.shared.getFileData(id: "\(item)") {
                print("mama = \(value)")
                
                var dct = Dictionary<String, String>()
                dct.updateValue("\(index)", forKey: "CONTENTSERIAl")
                dct.updateValue("\(value)", forKey: "CODECONTENT")
                employeeArray.append(dct)
                index = index + 1
                
            }
        }
        
        self.createCSV(from: employeeArray)
        
    }
    
    func shareImage() {
        
        var images = [UIImage]()
        for item in selectedIndexList {
            let fileName = "Image\(item)"
            
            let image = loadImageFromDocumentDirectory(fileName: fileName)
            images.append(image!)
        }
        
        let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)
        
        UIApplication.topMostViewController?.present(activityViewController, animated: true, completion: {
            
        })
        
        
        
    }
    
    func createTextFile() {
        
        var index  = 1
        var text = ""
        var employeeArray:[Dictionary<String, String>] =  Array()
        for item in selectedIndexList {
            
            if let value = DBmanager.shared.getFileData(id: "\(item)") {
                text = text + value
                text = text + "\n\n"
                
            }
        }
        
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            print("PATH: \(path)")
            let fileURL = path.appendingPathComponent("doc.txt")
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            let objectsToShare = [fileURL]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            UIApplication.topMostViewController?.present(activityViewController, animated: true, completion: {
                
            })
            
        } catch {
            print("error creating file")
        }
        
    }
    
    
    
    func createCSV(from recArray:[Dictionary<String, String>]) {
        var csvString = "\("Content Serial"),\("CODE Content")\n\n"
        for dct in recArray {
            csvString = csvString.appending("\(String(describing: dct["CONTENTSERIAl"]!)) ,\(String(describing: dct["CODECONTENT"]!))\n")
        }
        
        
        
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            print("PATH: \(path)")
            let fileURL = path.appendingPathComponent("CSVData.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            let objectsToShare = [fileURL]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            UIApplication.topMostViewController?.present(activityViewController, animated: true, completion: {
                
            })
            
        } catch {
            print("error creating file")
        }
    }
    
    
    
    @IBAction func gotoExport(_ sender: Any) {
        
        if selectedIndexList.count < 1 {
            
            let alert = UIAlertController(
                title: "Warning",
                message: "No file has been selected",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) -> Void in
                
            }))
            
            UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                
            })
            
            return
            
        }
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "CSV", style: .default) { action -> Void in
            
            
            self.createCsvFile()
            print("First Action pressed")
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "TXT", style: .default) { action -> Void in
            
            self.createTextFile()
            print("Second Action pressed")
        }
        
        let thirdAction: UIAlertAction = UIAlertAction(title: "Codes", style: .default) { action -> Void in
            self.shareImage()
            print("Second Action pressed")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(cancelAction)
        
        
        UIApplication.topMostViewController?.present(actionSheetController, animated: true, completion: {
            
        })
        
        
        
    }
    
    @IBAction func gotoDelete(_ sender: Any) {
        
        
        
        if selectedIndexList.count < 1 {
            
            let alert = UIAlertController(
                title: "Warning",
                message: "No file has been selected",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert) -> Void in
                
            }))
            
            UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                
            })
            
            return
            
        }
        
        let alert = UIAlertController(
            title: "Warning",
            message: "Do you want to delete the file",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) -> Void in
            
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) -> Void in
            for item in selectedIndexList {
                DBmanager.shared.deleteFile(id: "\(item)")
                let fileName = "Image\(item)"
                deleteImage(fileName: fileName)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "delete"), object: nil)
        }))
        
        
        UIApplication.topMostViewController?.present(alert, animated: true, completion: {
            
        })
    }
    
}

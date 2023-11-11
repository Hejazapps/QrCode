//
//  EditVc.swift
//  QrCodeMaker
//
//  Created by Sadiqul Amin on 26/7/23.
//

import UIKit
import Contacts
import MapKit


protocol sendUpdatedArray {
    func processYelpData(ar: [ResultDataModel],sh:String,st:String)
}

class EditVc: UIViewController, UITextViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var widthF = 320
    var heightF = 320
    
    var delegate: sendUpdatedArray?
    var isFromQr = false
    
    @IBOutlet weak var bottomSpacetableView: NSLayoutConstraint!
    var createDataModelArray = [ResultDataModel]()
    var currentTextview:UITextView?
    var isFinished  = false
    var currenttypeOfQrBAR = ""
    var showText = ""
    let locationManager = CLLocationManager()
    var currentLocationString = ""
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "InputTextTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTextTableViewCell")
        tableView.separatorColor = UIColor.clear
        widthF  = Int((self.view.frame.size.width)*0.85)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        print(createDataModelArray)
        
        
        if  currenttypeOfQrBAR  == "Location" {
            self.checkLocationServices()
            tableView.isHidden = true
            mapView.isHidden = false
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //DBmanager.shared.initDB()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("nosto")
        return .darkContent
    }
    
    func setUpLocation () {
        locationManager.delegate = self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.distanceFilter=kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func checkLocationServices() {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.checkLocationAuthorization()
                self.setUpLocation()
            }
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        print("sadiq")
        let currentLocation = locations.first?.coordinate
        
        if let a = currentLocation?.longitude,let b = currentLocation?.latitude {
            currentLocationString = "GEO:\(a),\(b)"
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            mapView.showsUserLocation = true
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default: break
            
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        print(currentLocationString)
        
        if let v = currentTextview {
            v.resignFirstResponder()
        }
        
        if currenttypeOfQrBAR.containsIgnoringCase(find: "location") {
            
            if currentLocationString.count < 1 {
                self.dismiss(animated: true)
            }
            return
        }
        
        if !isFinished && (self.currentTextview != nil) {
            if (self.currentTextview?.text.count)! > 0 {
                self.dismissKeyboard()
            }
        }
        
        
        if !isFromQr {
            
            
            let value1  = createDataModelArray[0].description
            
            let image = BarCodeGenerator.getBarCodeImage(type: currenttypeOfQrBAR, value: value1)
            
            
            if let value = image {

                delegate?.processYelpData(ar: createDataModelArray, sh: showText, st: value1)
                self.dismiss(animated: true, completion: {
                    
                })
                
            }
            else {
                
                let alert = UIAlertController(title: "Note", message: "Invalid Code", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                    ////self.dismissView()
                }))
                
                self.present(alert, animated: true)
                
            }
            
            return 
            
        }
        
        Constant.createQrCode_BarCodeByType(type: currenttypeOfQrBAR, modelArray: self.createDataModelArray, complation: { [self] contact, string in
            
            var mal = string
            
            var flag  = 0
            if currenttypeOfQrBAR.containsIgnoringCase(find: "snapchat") {
                
                if let v = string {
                    
                    if v.containsIgnoringCase(find: "http"), v.containsIgnoringCase(find: "snapchat") {
                        
                    }
                    else {
                        
                        let alert = UIAlertController(title: "Note", message: "Enter  fields properly", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                            ////self.dismissView()
                        }))
                        
                        UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                            
                        })
                        
                        return
                        
                    }
                }
                
            }
            
            
            if currenttypeOfQrBAR.containsIgnoringCase(find: "wechat") {
                
                if let v = string {
                    
                    if v.containsIgnoringCase(find: "http"), v.containsIgnoringCase(find: "wechat") {
                        
                    }
                    else {
                        
                        let alert = UIAlertController(title: "Note", message: "Enter  fields properly", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                            ////self.dismissView()
                        }))
                        
                        UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                            
                        })
                        
                        return
                        
                    }
                }
                
            }
            
            
            
            if currenttypeOfQrBAR.containsIgnoringCase(find: "vcard") || currenttypeOfQrBAR.containsIgnoringCase(find: "mecard"){
                
                for item in createDataModelArray {
                    
                    if item.description.count > 0 {
                        flag = 1
                    }
                }
                if flag == 0 {
                    let alert = UIAlertController(title: "Note", message: "Enter  fields properly", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                        ////self.dismissView()
                    }))
                    
                    UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                        
                    })
                    
                    return
                }
            }
            
            
            if createDataModelArray.count == 1 ||  currenttypeOfQrBAR.containsIgnoringCase(find: "sms") || currenttypeOfQrBAR.containsIgnoringCase(find: "mms") || currenttypeOfQrBAR.containsIgnoringCase(find: "email"){
                
                if createDataModelArray[0].description.count < 1 {
                    
                    let alert = UIAlertController(title: "Note", message: "Enter  fields properly", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                        ////self.dismissView()
                    }))
                    
                    UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                        
                    })
                    
                    return
                    
                }
            }
            
            
            if string == nil, !currenttypeOfQrBAR.containsIgnoringCase(find: "vcard") {
                
                let alert = UIAlertController(title: "Note", message: "Enter  fields properly", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                    ////self.dismissView()
                }))
                
                UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                    
                })
                
                return
            }
            
            if self.currenttypeOfQrBAR  == "Vcard"{
                var vcard = NSData()
                // let usersContact = CNMutableContact()
                do {
                    try vcard = CNContactVCardSerialization.data(with: [contact!] )  as NSData
                    mal = String(data: vcard as Data, encoding: .utf8)
                    // print("string  ", vcString)
                   
                    
                } catch {
                    print("Error \(error)")
                }
            }else{
                
            }
            
            
            
            showText = QrParser.getBarCodeObj(text: mal ?? "")
            delegate?.processYelpData(ar: createDataModelArray, sh: showText, st: mal!)
            
            
            self.dismiss(animated: true, completion: {
                
            })
            
            
        })
        
        
        
        
        
        
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isFinished  = false
        self.currentTextview = textView
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let index = textView.tag
        isFinished = true
        print("kuttatat")
        if textView.text.count > 0 {
            self.createDataModelArray[index].description = textView.text
        }
        
    }
    
    
    
    @objc func dismissKeyboard() {
        UIView.animate(withDuration: 0.3) {
            self.bottomSpacetableView.constant = 0
            self.view.layoutIfNeeded()
        }
        
        view.endEditing(true)
    }
    
    
    fileprivate func isOnlyDecimal(type: String) -> Bool {
        print("ayat : ", type)
        if type.containsIgnoringCase(find: "number") || type == "Mobile:" || type == "Phone:" || type == "Fax:" || type == "Zip:" || type.containsIgnoringCase(find: "ean-13") || type.containsIgnoringCase(find: "ean-8") || type == "Ean-E:" || type == "ITF:" || type.containsIgnoringCase(find: "upc-a") || type.containsIgnoringCase(find: "upc-e") || type.containsIgnoringCase(find: "itf"){
            return true
        }else{
            return false
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        currentTextview?.resignFirstResponder()
       
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let indexPath = IndexPath(row: 2, section: 0)
            self.tableView.scrollToRow(at: indexPath , at: .bottom, animated: true)
            
        }
        
        if let gender = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) {
          
            self.createDataModelArray[2].description = gender
            
            
        }
    }
    
}




extension EditVc: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value = createDataModelArray[indexPath.row].title
        
        if value.containsIgnoringCase(find: "text") {
            return 400
        }
        
        if value.containsIgnoringCase(find: "message") {
            return 300
        }
        
        if value.containsIgnoringCase(find: "body") {
            return 300
        }
        
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.createDataModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InputTextTableViewCell", for: indexPath) as! InputTextTableViewCell
        cell.selectionStyle = .none
        cell.textView.textContainerInset = .zero
        cell.textView.font = UIFont.boldSystemFont(ofSize: 14.0)
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        cell.textView.inputAccessoryView = keyboardToolbar
        cell.textView.text = createDataModelArray[indexPath.row].description
        
        if  isFromQr {
            if self.isOnlyDecimal(type: self.createDataModelArray[indexPath.item].title) {
                cell.textView.keyboardType = .asciiCapableNumberPad
            }else{
                cell.textView.keyboardType = .default
            }
        }
        else {
            
            if self.isOnlyDecimal(type: currenttypeOfQrBAR) {
                cell.textView.keyboardType = .asciiCapableNumberPad
            }
            else {
                cell.textView.keyboardType = .default
            }
        }
        
        
        if indexPath.row == 0 {
            
        }
        
        
        
        
        cell.textView.tag = indexPath.item
        cell.textView.delegate = self
        
        // cell.textView.layer.shadowColor = UIColor.black.cgColor
        // cell.textView.layer.shadowOpacity = 1
        // cell.textView.layer.shadowOffset = .zero
        
        
        cell.backgroundColor = tableView.backgroundColor
        
        
        
        // cell.textView.text =  self.inputParemeterArray[indexPath.item].description
        
        
        
        
        cell.label.text =  self.createDataModelArray[indexPath.item].title
        cell.label.textColor = UIColor.white
        cell.textView.textColor = UIColor.black
        cell.configCell()
        cell.textView.centerVertically()
        cell.textView.sizeToFit()
        
        let textF = self.createDataModelArray[indexPath.item].title
        
        cell.networkName.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
      //  cell.networkName.addTarget(self, action: #selector(segmentAction(_:)), for: .touchUpInside)
        
        
        if textF.containsIgnoringCase(find: "Encription") {
            print("mamamamamammamamamamammama")
            cell.networkName.isHidden = false
            
        } else {
            cell.networkName.isHidden = true
            cell.textView.isHidden = false
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        heightF = (164*widthF)/976
        let titleLabel = UIImageView(frame: CGRect(x:(Int(self.view.frame.width) - widthF)/Int(2.0),y: 40 ,width:widthF,height:heightF))
        titleLabel.image =  UIImage(named: "App Ad.png")
        vw.addSubview(titleLabel)
        return vw
    }
}

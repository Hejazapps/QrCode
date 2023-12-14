//
//  CreateVc.swift
//  QrCode&BarCode
//
//  Created by Macbook pro 2020 M1 on 24/2/23.
//

import UIKit
import Contacts
import EventKit
import EventKitUI
import MapKit

import EANBarcodeGenerator



struct CreateDataModel {
    var title = ""
    var text = ""
    var height = 0
}

struct ResultDataModel {
    var title = ""
    var description = ""
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    init(dictionary : [String:String]) {
        self.title = dictionary["title"]!
        self.description = dictionary["description"]!
    }
    
    var dictionaryRepresentation : [String:String] {
        return ["title" : title, "description" : description]
    }
    
    
}

struct DetectedInfo: Hashable {
    var id: Int?
    var date: String?
}



class CreateVc: UIViewController, sendIndex, UITextViewDelegate, EKEventEditViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var widthForBtn1: NSLayoutConstraint!
    @IBOutlet weak var heightForbtn1: NSLayoutConstraint!
    @IBOutlet weak var heightForImv: NSLayoutConstraint!
    
    @IBOutlet weak var imvHolder: UIView!
    @IBOutlet weak var imv1Holder: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var heightForView: NSLayoutConstraint!
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var dotV1: UIView!
    @IBOutlet weak var dotv2: UIView!
    @IBOutlet weak var dotv3: UIView!
    @IBOutlet weak var dotv4: UIView!
    @IBOutlet weak var dotv5: UIView!
    @IBOutlet weak var dot6: UIView!
    @IBOutlet weak var dot7: UIView!
    
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var bottomSpaceOftableView: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceForView: NSLayoutConstraint!
    @IBOutlet weak var topSpaceView: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var collectionViewHolder: UIView!
    @IBOutlet weak var collectionViewForIcon: UICollectionView!
    
    @IBOutlet weak var widthForbtn1: NSLayoutConstraint!
    @IBOutlet weak var widthForView: NSLayoutConstraint!
    
    @IBOutlet weak var hidev3: UIView!
    @IBOutlet weak var hideV4: UIView!
    @IBOutlet weak var hideV5: UIView!
    @IBOutlet weak var hideV6: UIView!
    
    @IBOutlet weak var hide7: UIView!
    
    var currentSelectedName = ""
    var currentTextView:UITextView! = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
    var currentIndex = IndexPath(row: 0, section: 0)
    var selectedIndex = 0
    let eventStore = EKEventStore()
    let currentV = "Website"
    var inputParemeterArray = [CreateDataModel]()
    var createDataModelArray = [ResultDataModel]()
    let locationManager = CLLocationManager()
    var currentLocationString  = ""
    var temp = ""
    var fromQrCode =  true
    let currentSegmentindex = 0
    var currentTextViewF:UITextView?
    var currentBrCode  = 0
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        self.dismissKeyboard()
        currentSelectedName = "Text"
        inputParemeterArray = Constant.getInputParemeterByType(type: "Text")
        for v in self.inputParemeterArray {
            if v.text.count > 0 {
                self.createDataModelArray.append(ResultDataModel(title: v.title, description: v.text))
                
            }
            else {
                self.createDataModelArray.append(ResultDataModel(title: v.title, description: ""))
            }
            
        }
        tableView.reloadData()
        collectionViewForIcon.reloadData()
        collectionViewForIcon.reloadData()
        
        
        self.dismissKeyboard()
        if action.rawValue == 0 {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        var event = Event()
        
        if let eventV = controller.event?.title {
            event.summary = eventV
            
            self.createDataModelArray.append(ResultDataModel(title: "Title", description: event.summary!))
        }
        
        if let startDate = controller.event?.startDate {
            // Store.sharedInstance.setstartDate(date: startDate)
            event.dtstart = startDate
            let a = startDate.toString()
            self.createDataModelArray.append(ResultDataModel(title: "Start", description:(event.dtstart?.asString(style: .full))!))
        }
        
        if let endDate = controller.event?.endDate {
            // Store.sharedInstance.setstartDate(date: endDate)
            event.dtend = endDate
            let a = endDate.toString()
            self.createDataModelArray.append(ResultDataModel(title: "End", description:(event.dtend?.asString(style: .full))!))
        }
        
        if let location = controller.event?.location {
            event.location = location
            self.createDataModelArray.append(ResultDataModel(title: "Location", description: event.location!))
        }
        
        if let note = controller.event?.notes {
            event.descr = note
            self.createDataModelArray.append(ResultDataModel(title: "Notes", description: event.descr!))
        }
        
        let calendar = Calendar1(withComponents: [event])
        let iCalString = calendar.toCal()
        var value = iCal.parse([iCalString])
        let cals = try! iCal.load(string: iCalString)
        // or loadFile() or loadString(), all of which return [Calendar] as an ics file can contain multiple calendars
        
        for cal in cals {
            for event in cal.otherAttrs {
                print(event)
            }
        }
        print("Data ", iCalString)
        controller.dismiss(animated: true, completion: {
            self.goResultVc(string: iCalString,event: controller.event!)
        })
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("nosto")
        return .darkContent
    }
    
    
    
    @IBAction func gotoOption2(_ sender: Any) {
        fromQrCode = false
        mapView.isHidden = true
        self.createDataModelArray.removeAll()
        self.inputParemeterArray.removeAll()
        updateDotView(index: 0)
        
        currentIndex = IndexPath(row: 0, section: 0)
        currentSelectedName = "EAN-13"
        
        hidev3.isHidden = true
        hideV4.isHidden = true
        hideV5.isHidden = true
        hideV6.isHidden = true
        // hide7.isHidden = true
        
        topLabel.text = ""
        
        widthForView.constant = 30.0
        imv1Holder.layer.borderWidth = 2.0
        imv1Holder.layer.borderColor = tabBarBackGroundColor.withAlphaComponent(0.5).cgColor
        imvHolder.layer.borderWidth = 0
        imvHolder.layer.borderColor = UIColor.clear.cgColor
        
        heightForView.constant = 150.0
        heightForImv.constant = imvHolder.frame.height - 50
        widthForBtn1.constant  = imvHolder.frame.width
        heightForbtn1.constant = imvHolder.frame.height
        bottomSpaceOftableView.constant = 0
        bottomSpaceForView.constant = 0
        self.collectionViewForIcon.reloadData()
        
        inputParemeterArray = Constant.getInputParemeterByType(type: "BarCode")
        for _ in self.inputParemeterArray {
            self.createDataModelArray.append(ResultDataModel(title: "Enter Code", description: ""))
        }
        self.tableView.reloadData()
        
        
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
    
    func createEvent() {
        
        
        let event = EKEvent(eventStore: self.eventStore)
        // event.title = "My Event"
        event.startDate = Date(timeIntervalSinceNow: TimeInterval())
        event.endDate = Date(timeIntervalSinceNow: TimeInterval())
        //event.notes = "Yeah!!!"
        let eventController = EKEventEditViewController()
        eventController.event = event
        eventController.editViewDelegate = self
        eventController.eventStore = self.eventStore
        eventController.modalPresentationStyle = .fullScreen
        UIApplication.topMostViewController?.present(eventController, animated: true, completion: {
        })
    }
    
    func addEventToCalendar(){
        let completion: EKEventStoreRequestAccessCompletionHandler = { granted, error in
            DispatchQueue.main.async { [weak self] in
                if granted {
                    self?.createEvent()
                } else {
                    self?.showAlert()
                }
            }
        }
        
        switch EKEventStore.authorizationStatus(for: .event) {
            
        case .authorized:
            createEvent()
            
        case .denied:
            self.showAlert()
            
        case .notDetermined:
            if #available(iOS 17.0, *) {
                print("iOS 17.0 and higher")
                eventStore.requestFullAccessToEvents(completion: completion)
            } else {
                print("less than iOS 17.0")
                eventStore.requestAccess(to: .event, completion: completion)
            }
            
            print("Not Determined")
        default:
            print("Case Default")
        }
        
        
        
        
    }
    
    func showAlert(){
        
        let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        UIApplication.topMostViewController?.present(alertController, animated: true, completion: {
            
        })
        //present(alertController, animated: true, completion: nil)
    }
    
    func btnTag(index: Int) {
        dismissKeyboard()
        inputParemeterArray.removeAll()
        createDataModelArray.removeAll()
        mapView.isHidden = true
        
        self.currentTextView.text = ""
        
        if heightForView.constant < 300 {
            
            currentBrCode = index
            print("muntasir = \(currentIndex.row)")
            print("muntasir1 = \(currentIndex.section)")
            
           
            
            currentSelectedName = barCategoryArray[currentIndex.row * 6 + index] as! String
            inputParemeterArray = Constant.getInputParemeterByType(type: "BarCode")
            for _ in self.inputParemeterArray {
                self.createDataModelArray.append(ResultDataModel(title: "Enter Code", description: ""))
            }
            collectionViewForIcon.reloadData()
            tableView.reloadData()
            return
        }
        
        
        
        print(currentIndex.row)
        print(currentIndex.section)
        
        print("muntasir = \(currentIndex.row)")
        print("muntasir1 = \(currentIndex.section)")
        
       
        
        let dic = qrCategoryArray[currentIndex.section] as? Dictionary<String, Any>
        if let  itemName  = dic!["items"] as? NSArray {
            
            
            if (itemName[index] as! String)  == "Event" {
                self.createDataModelArray.removeAll()
                self.inputParemeterArray.removeAll()
                self.addEventToCalendar()
                return
            }
            
            let index =   currentIndex.row*6 + index
            print(itemName[index])
            selectedIndex = index
            currentSelectedName = itemName[index]  as! String
            createDataModelArray.removeAll()
            
            tableView.isHidden = false
            mapView.isHidden = true
            
            
            if (itemName[index] as! String)  == "Location" {
                self.checkLocationServices()
                tableView.isHidden = true
                mapView.isHidden = false
                tableView.reloadData()
                collectionViewForIcon.reloadData()
                return
            }
            
            inputParemeterArray = Constant.getInputParemeterByType(type: itemName[index] as! String)
            for v in self.inputParemeterArray {
                if v.text.count > 0 {
                    self.createDataModelArray.append(ResultDataModel(title: v.title, description: v.text))
                    
                }
                else {
                    self.createDataModelArray.append(ResultDataModel(title: v.title, description: ""))
                }
                
            }
            tableView.reloadData()
            collectionViewForIcon.reloadData()
        }
        self.dismissKeyboard()
        //self.currentTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance().keyboardAppearance = .light
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        CIEANBarcodeGenerator.register()
        
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        heightForView.constant = 300.0
        
        
        self.perform(#selector(self.targetMethod), with: self, afterDelay: 0.1)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        
        tableView.isHidden = false
        mapView.isHidden = true
        
        holderView.clipsToBounds = true
        holderView.layer.cornerRadius = 20
        holderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
        // holderView.roundCorners([.topLeft, .topRight], radius: 20)
        
        tableView.register(UINib(nibName: "InputTextTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTextTableViewCell")
        
        tableView.separatorColor = UIColor.clear
        
        collectionViewForIcon.isPagingEnabled = true
        collectionViewForIcon.showsVerticalScrollIndicator = false
        collectionViewForIcon.showsHorizontalScrollIndicator = false
        let emptyAutomationsCell = IconViewColl.nib
        collectionViewForIcon?.register(emptyAutomationsCell, forCellWithReuseIdentifier: IconViewColl.reusableID)
        
        let path1 = Bundle.main.path(forResource: "QrCategory", ofType: "plist")
        qrCategoryArray = NSArray(contentsOfFile: path1!)
        
        let path2 = Bundle.main.path(forResource: "BarCategory", ofType: "plist")
        barCategoryArray = NSArray(contentsOfFile: path2!)
        
        
        let dic = qrCategoryArray[0] as? Dictionary<String, Any>
        
        if let  itemName  = dic!["Category"] as? String {
            topLabel.text = itemName
            topLabel.textColor = tabBarBackGroundColor
            
        }
        
        self.makeRoundedView(view: dotV1)
        self.makeRoundedView(view: dotv2)
        self.makeRoundedView(view: dotv3)
        self.makeRoundedView(view: dotv4)
        self.makeRoundedView(view: dotv5)
        self.makeRoundedView(view: dot6)
        // self.makeRoundedView(view: dot7)
        
        dotV1.backgroundColor = tabBarBackGroundColor
        inputParemeterArray = Constant.getInputParemeterByType(type: "Website")
        for _ in self.inputParemeterArray {
            self.createDataModelArray.append(ResultDataModel(title: "", description: ""))
        }
        currentSelectedName = "Website"
        tableView.reloadData()
        
    }
    
    @IBAction func gotoOption1(_ sender: Any) {
        fromQrCode = true
        currentIndex =  IndexPath(row: 0, section: 0)
        self.createDataModelArray.removeAll()
        self.inputParemeterArray.removeAll()
        updateDotView(index: 0)
        currentSelectedName = "Website"
        inputParemeterArray = Constant.getInputParemeterByType(type: "Website")
        for _ in self.inputParemeterArray {
            self.createDataModelArray.append(ResultDataModel(title: "Website", description: ""))
        }
        
        hidev3.isHidden = false
        hideV4.isHidden = false
        hideV5.isHidden = false
        hideV6.isHidden = false
        widthForView.constant = 80.0
        
        imvHolder.layer.borderWidth = 2.0
        imvHolder.layer.borderColor = tabBarBackGroundColor.withAlphaComponent(0.5).cgColor
        imv1Holder.layer.borderWidth = 0
        imv1Holder.layer.borderColor = UIColor.clear.cgColor
        heightForView.constant = 300.0
        heightForImv.constant = imvHolder.frame.height - 50
        widthForBtn1.constant  = imvHolder.frame.width
        heightForbtn1.constant = imvHolder.frame.height
        
        topLabel.text = "Personal"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionViewForIcon.reloadData()
            self.tableView.reloadData()
        }
    }
    
    @objc fileprivate func targetMethod(){
        imvHolder.layer.borderWidth = 2.0
        imvHolder.layer.borderColor = tabBarBackGroundColor.withAlphaComponent(0.5).cgColor
        heightForView.constant = 300.0
        heightForImv.constant = imvHolder.frame.height - 50
        widthForBtn1.constant  = imvHolder.frame.width
        heightForbtn1.constant = imvHolder.frame.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionViewForIcon.reloadData()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        heightForImv.constant = imvHolder.frame.height - 50
        widthForBtn1.constant  = imvHolder.frame.width
        heightForbtn1.constant = imvHolder.frame.height
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.3) {
                self.topSpaceView.constant = (-1) * keyboardHeight
                self.bottomSpaceOftableView.constant = keyboardHeight - 70
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.dismissKeyboard()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dismissKeyboard()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    func showLocationAlert()
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Location Access required",
                message: "To create qr code from Location you need to give location permission",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (alert) -> Void in
                // Store.sharedInstance.setshouldShowHomeScreen(value: true)
                
                
                
                
            }))
            alert.addAction(UIAlertAction(title: "Allow Access", style: .default, handler: { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        self.dismissKeyboard()
        print(createDataModelArray)
        
        
        if self.heightForView.constant < 300  {
            
            if currentBrCode > 0 {
                if !Store.sharedInstance.isActiveSubscription() {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionVc") as! SubscriptionVc
                    initialViewController.modalPresentationStyle = .fullScreen
                    self.present(initialViewController, animated: true, completion: nil)
                    return
                    
                }
            }
            
        }
        
        if  self.heightForView.constant >= 300  {
            
            
            if currentIndex.section > 1 {
                
                
                if !Store.sharedInstance.isActiveSubscription() {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionVc") as! SubscriptionVc
                    initialViewController.modalPresentationStyle = .fullScreen
                    self.present(initialViewController, animated: true, completion: nil)
                    return
                    
                }

            }
            
            
        }
        
        if self.currentSelectedName == "Location" {
            
            
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                
            case .denied:
                showLocationAlert()
                return
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
            
            
            self.goResultVc(string: self.currentLocationString)
            
            temp = "Location"
            
            return
            
        }
        
        temp = currentSelectedName
        
        if self.heightForView.constant < 300 {
            
            temp = currentSelectedName
            
        }
        
        print(currentSelectedName)
        Constant.createQrCode_BarCodeByType(type: temp, modelArray: self.createDataModelArray, complation: { [self] contact, string in
            print("mamam")
            
            var flag = 0
            
            
            if currentSelectedName.containsIgnoringCase(find: "snapchat") {
                
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
            
            
            if currentSelectedName.containsIgnoringCase(find: "wechat") {
                
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
            
            
            
            if currentSelectedName.containsIgnoringCase(find: "vcard") || currentSelectedName.containsIgnoringCase(find: "mecard"){
                
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
            
            
            if createDataModelArray.count == 1 ||  currentSelectedName.containsIgnoringCase(find: "sms") || currentSelectedName.containsIgnoringCase(find: "mms") || currentSelectedName.containsIgnoringCase(find: "email"){
                
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
            
            
            if string == nil, !currentSelectedName.containsIgnoringCase(find: "vcard") {
                
                let alert = UIAlertController(title: "Note", message: "Enter  fields properly", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                    ////self.dismissView()
                }))
                
                UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                    
                })
                
                return
            }
            
            
            if self.heightForView.constant < 300 {
                
                let image = BarCodeGenerator.getBarCodeImage(type: self.currentSelectedName, value: string!)
                
                if let value = image {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVc") as! ShowResultVc
                    vc.stringValue = string!
                    vc.modalPresentationStyle = .fullScreen
                    vc.image = image
                    vc.isfromQr = false
                    vc.currenttypeOfQrBAR = currentSelectedName
                    
                    UIApplication.topMostViewController?.present(vc, animated: true, completion: {
                    })
                    
                    return
                    
                }
                else {
                    let alert = UIAlertController(title: "Note", message: "Invalid Code", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: {_ in
                        ////self.dismissView()
                    }))
                    
                    UIApplication.topMostViewController?.present(alert, animated: true, completion: {
                        
                    })
                    
                    return
                    
                }
                
            }
            
            
            
            if self.currentSelectedName  == "Vcard"{
                var vcard = NSData()
                // let usersContact = CNMutableContact()
                do {
                    try vcard = CNContactVCardSerialization.data(with: [contact!] )  as NSData
                    let vcString = String(data: vcard as Data, encoding: .utf8)
                    // print("string  ", vcString)
                    self.goResultVc(string: vcString!)
                    
                } catch {
                    print("Error \(error)")
                }
            }else{
                self.goResultVc(string: string!)
                // print("String11  ", string)
            }
        })
    }
    
    fileprivate func isOnlyDecimal(type: String) -> Bool {
        print("ayat : ", type)
        if type.containsIgnoringCase(find: "number") || type == "Mobile:" || type == "Phone:" || type == "Fax:" || type == "Zip:" || type.containsIgnoringCase(find: "ean-13") || type.containsIgnoringCase(find: "ean-8") || type == "Ean-E:" || type == "ITF:" || type.containsIgnoringCase(find: "upc-a") || type.containsIgnoringCase(find: "upc-e") || type.containsIgnoringCase(find: "itf"){
            return true
        }else{
            return false
        }
    }
    
    func goResultVc(string: String, event:EKEvent){
        
        ////////////////////////////////////////////////-        print(string)
        ///
        ///
        //
        
        print(string)
        
        
        
        let value = QrParser.getBarCodeObj(text: string)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVc") as! ShowResultVc
        vc.stringValue = string
        vc.modalPresentationStyle = .fullScreen
        vc.createDataModelArray = createDataModelArray
        vc.showText = value
        vc.currenttypeOfQrBAR = "event"
        vc.eventF = event
        
        UIApplication.topMostViewController?.present(vc, animated: true, completion: {
        })
    }
    
    func goResultVc(string: String){
        
        ////////////////////////////////////////////////-        print(string)
        
        let value = QrParser.getBarCodeObj(text: string)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVc") as! ShowResultVc
        vc.stringValue = string
        vc.modalPresentationStyle = .fullScreen
        vc.createDataModelArray = createDataModelArray
        vc.showText = value
        vc.currenttypeOfQrBAR = temp
        vc.isfromQr = true
        
        UIApplication.topMostViewController?.present(vc, animated: true, completion: {
        })
    }
    
    @objc func dismissKeyboard() {
        
        tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.topSpaceView.constant = 0
            self.bottomSpaceOftableView.constant = 0
            self.view.layoutIfNeeded()
        }
        
        view.endEditing(true)
    }
    
    func makeRoundedView(view:UIView) {
        
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.currentTextView = textView
        collectionViewForIcon.reloadData()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let index = textView.tag
        let type = self.inputParemeterArray[index].title
        // self.createDataModelArray[index].title = type
        self.createDataModelArray[index].description = textView.text
        
        var height = 110
        
        if type.containsIgnoringCase(find: "text") || type.containsIgnoringCase(find: "Message") || type.containsIgnoringCase(find: "body") {
            height = 400
            
        }
        
        var frame = textView.frame
        frame.size.height = textView.contentSize.height
        
        self.inputParemeterArray[index].height = max(height, Int(frame.size.height) + 20 + 35 + 30)
        
        // tableView.reloadData()
        
        
        
        ///print("mammamamma")
        
    }
    
    
    
    
    func calculatedHeight(for text: String, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width,
                                          height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionViewForIcon.contentOffset
        visibleRect.size = collectionViewForIcon.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionViewForIcon.indexPathForItem(at: visiblePoint) else { return }
        let dic = qrCategoryArray[indexPath.section] as? Dictionary<String, Any>
        if let  itemName  = dic!["Category"] as? String {
            topLabel.text = itemName
            topLabel.textColor = tabBarBackGroundColor
            
        }
        
        if heightForView.constant == 150 {
            topLabel.text = ""
        }
        topLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        currentIndex = indexPath
        self.updateDotView(index: Int(self.collectionViewForIcon.contentOffset.x / self.collectionViewForIcon.frame.size.width))
        
        collectionViewForIcon.reloadData()
    }
    
    func updateDotView(index:Int) {
        dotV1.backgroundColor = dotViewColor
        dotv2.backgroundColor = dotViewColor
        dotv3.backgroundColor = dotViewColor
        dotv4.backgroundColor = dotViewColor
        dotv5.backgroundColor = dotViewColor
        dot6.backgroundColor = dotViewColor
        //dot7.backgroundColor = dotViewColor
        
        if index == 0 {
            dotV1.backgroundColor = tabBarBackGroundColor
        }
        if index == 1 {
            dotv2.backgroundColor = tabBarBackGroundColor
        }
        if index == 2 {
            dotv3.backgroundColor = tabBarBackGroundColor
        }
        if index == 3 {
            dotv4.backgroundColor = tabBarBackGroundColor
        }
        if index == 4 {
            dotv5.backgroundColor = tabBarBackGroundColor
        }
        if index == 5 {
            dot6.backgroundColor = tabBarBackGroundColor
        }
        if index == 6 {
            dot7.backgroundColor = tabBarBackGroundColor
        }
        
    }
    
}
extension CreateVc:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IconViewColl.reusableID,
            for: indexPath) as? IconViewColl else {
            return IconViewColl()
        }
        
        cell.view1.dropShadow(shouldShow: false)
        cell.view2.dropShadow( shouldShow: false)
        cell.view3.dropShadow(shouldShow: false)
        cell.view4.dropShadow( shouldShow: false)
        cell.view5.dropShadow( shouldShow: false)
        cell.view6.dropShadow( shouldShow: false)
        
        cell.widthForBtn.constant = cell.view1.frame.width
        cell.heightForBtn.constant = cell.view1.frame.height
        
        
        let dic = qrCategoryArray[indexPath.section] as? Dictionary<String, Any>
        
        if heightForView.constant == 300 {
            
            if let  itemName  = dic!["items"] as? NSArray {
                
                let index =   indexPath.row*6
                cell.lbl1.text = itemName[index] as? String
                cell.lbl2.text = itemName[index + 1] as? String
                cell.lbl3.text = itemName[index + 2] as? String
                cell.lbl4.text = itemName[index + 3] as? String
                cell.lbl5.text = itemName[index + 4] as? String
                cell.lbl6.text = itemName[index + 5] as? String
                cell.imv1.image = UIImage(named: (itemName[index] as? String)!)
                cell.imv2.image = UIImage(named: (itemName[index + 1] as? String)!)
                cell.imv3.image = UIImage(named: (itemName[index + 2] as? String)!)
                cell.imv4.image = UIImage(named: (itemName[index + 3] as? String)!)
                cell.imv5.image = UIImage(named: (itemName[index + 4] as? String)!)
                cell.imv6.image = UIImage(named: (itemName[index + 5] as? String)!)
                print(cell.lbl5.text)
            }
        }
        else {
            let index =   indexPath.row*6
            cell.lbl1.text = barCategoryArray[index] as? String
            cell.lbl2.text = barCategoryArray[index + 1] as? String
            cell.lbl3.text = barCategoryArray[index + 2] as? String
            cell.lbl4.text = barCategoryArray[index + 3] as? String
            cell.lbl5.text = barCategoryArray[index + 4] as? String
            cell.lbl6.text = barCategoryArray[index + 5] as? String
        }
        
        print("your cat is \(currentSelectedName)  \(cell.lbl1.text)  cat years old")
        
        if cell.lbl1.text == currentSelectedName {
            cell.view1.dropShadow(shouldShow: true)
            
        }
        if cell.lbl2.text == currentSelectedName {
            cell.view2.dropShadow(shouldShow: true)
            
        }
        if cell.lbl3.text == currentSelectedName {
            cell.view3.dropShadow(shouldShow: true)
            
        }
        if cell.lbl4.text == currentSelectedName {
            cell.view4.dropShadow(shouldShow: true)
            
        }
        if cell.lbl5.text == currentSelectedName {
            cell.view5.dropShadow(shouldShow: true)
            
        }
        if cell.lbl6.text == currentSelectedName {
            cell.view6.dropShadow(shouldShow: true)
            
        }
        
        if heightForView.constant == 300 {
            cell.heightForImv.constant = cell.holderView.frame.height - 2*10
        }
        else{
            cell.heightForImv.constant = 0
        }
        
        if cell.lbl6.text!.count < 1 {
            cell.view6.isHidden = true
        }
        else {
            cell.view6.isHidden = false
        }
        
        if cell.lbl5.text!.count < 1 {
            cell.view5.isHidden = true
        }
        else {
            cell.view5.isHidden = false
        }
        
        cell.widthForLbl1.constant = cell.view1.frame.width
        cell.widthForLbl2.constant = cell.view2.frame.width
        cell.widthForlbl3.constant = cell.view3.frame.width
        cell.widthForlbl4.constant = cell.view4.frame.width
        cell.widthForLbl5.constant = cell.view5.frame.width
        cell.widthForLbl6.constant = cell.view6.frame.width
        cell.delegateForbtnTag = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: heightForView.constant)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell horizonatally
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell vertically
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if heightForView.constant == 150.0 {
            return 1
        }
        return qrCategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if heightForView.constant < 300 {
            return 2
        }
        
        let dic = qrCategoryArray[section] as? Dictionary<String, Any>
        
        if let  itemName  = dic!["items"] as? NSArray {
            return itemName.count / 6
            
        }
        return 1
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        
        currentTextView.resignFirstResponder()
        self.topSpaceView.constant = 0
        self.bottomSpaceOftableView.constant = 0
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let indexPath = IndexPath(row: 2, section: 0)
            self.tableView.scrollToRow(at: indexPath , at: .bottom, animated: true)
            
        }
        
        if let gender = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) {
          
            self.createDataModelArray[2].description = gender
            
            
        }
        
        // print()
        print("your cat is \(segmentedControl.selectedSegmentIndex) cat years old")
        // tableView.reloadData()
        // dismissKeyboard()
    }
    
}

extension CreateVc: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = CGFloat(self.inputParemeterArray[indexPath.item].height) + 10
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.inputParemeterArray.count
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
        cell.textView.text = ""
        
        
        if  fromQrCode {
            if self.isOnlyDecimal(type: self.createDataModelArray[indexPath.item].title) {
                cell.textView.keyboardType = .asciiCapableNumberPad
            }else{
                cell.textView.keyboardType = .default
            }
        }
        else {
            
            if self.isOnlyDecimal(type: currentSelectedName) {
                cell.textView.keyboardType = .asciiCapableNumberPad
            }
            else {
                cell.textView.keyboardType = .default
            }
        }
        
        
        
        if indexPath.row == 0 {
            
        }
        
        
        //cell.switchF.isHidden =  true
        
        cell.textView.tag = indexPath.item
        cell.textView.delegate = self
        
        // cell.textView.layer.shadowColor = UIColor.black.cgColor
        // cell.textView.layer.shadowOpacity = 1
        // cell.textView.layer.shadowOffset = .zero
        
        
        cell.backgroundColor = tableView.backgroundColor
        
        print("mamam = \(inputParemeterArray[indexPath.item].text)")
        
        cell.textView.text =  self.createDataModelArray[indexPath.item].description
        
        
        cell.textViewContainer.backgroundColor = UIColor.white
        
        cell.label.text =  self.createDataModelArray[indexPath.item].title
        cell.label.textColor = UIColor.white
        cell.textView.textColor = UIColor.black
        cell.configCell()
        cell.textView.centerVertically()
        cell.textView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        /// cell.textView.adjustUITextViewHeight()
        
        print(self.inputParemeterArray[indexPath.item].title)
        let textF = self.createDataModelArray[indexPath.item].title
        
        cell.networkName.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        
        if  self.createDataModelArray[indexPath.item].title.containsIgnoringCase(find: "hidden") {
            
            print("dada")
            
            cell.networkName.isHidden = true
            cell.textView.isHidden = true
            // cell.switchF.isHidden = false
            cell.textViewContainer.backgroundColor = UIColor.clear
            
            let genderIndex = cell.networkName.selectedSegmentIndex
            
            if genderIndex == 0 {
                self.createDataModelArray[indexPath.item].description = "Hidden"
            }
            else {
                self.createDataModelArray[indexPath.item].description = "Not"
            }
        }
        
        
        else if textF.contains(find: "Encription") {
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
}

extension UIView {
    func dropShadow(scale: Bool = true ,shouldShow:Bool = false) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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

extension UITextView {
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}



extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}


extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

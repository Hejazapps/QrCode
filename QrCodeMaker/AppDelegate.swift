//
//  AppDelegate.swift
//  NewQrCode
//
//  Created by Mostofa Mahmud on 10/4/21.
//

import Firebase
import FirebaseMessaging
import UserNotifications
import UIKit
import SVProgressHUD
import IHProgressHUD
import SwiftyStoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, error in
            guard let token else {
                print("[murad] error token: \(String(describing: error?.localizedDescription))")
                return
            }
            
            print("[murad] token: \(token)")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("[murad] success Push authorization")
            } else {
                print("[murad] error Push authorization: \(String(describing: error?.localizedDescription))")
            }
        }
        application.registerForRemoteNotifications()
        
        DBmanager.shared.initDB()
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.white
        UISegmentedControl.appearance().backgroundColor =  UIColor.white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        
        
        
        UITextField.appearance().keyboardAppearance = .light
        // UITextView.appearance().keyboardAppearance = .light
        // Override point for customization after application launch.
        UITabBar.appearance().backgroundColor =  tabBarBackGroundColor
        UITabBar.appearance().unselectedItemTintColor = tabBarUnSelectedColor
        UITabBar.appearance().tintColor = UIColor.white
      
        
        IHProgressHUD.setOffsetFromCenter(UIOffset(horizontal:screenWidth/2.0 , vertical: screenHeight/2.0))
        
        
        let a = UserDefaults.standard.integer(forKey: "sound")
        
        
        if a == 0 {
            UserDefaults.standard.set(2, forKey: "sound")
            UserDefaults.standard.set(2, forKey: "vibrate")
            UserDefaults.standard.set(2, forKey: "Beep")
            UserDefaults.standard.set(2, forKey: "Link")
            UserDefaults.standard.set(2, forKey: "history")
        }
        
        
        
        return true
    }
    
}


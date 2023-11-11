//
//  AppDelegate.swift
//  NewQrCode
//
//  Created by Mostofa Mahmud on 10/4/21.
//

import UIKit
import SVProgressHUD
import IHProgressHUD


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
      
        UITextField.appearance().keyboardAppearance = .light
        // Override point for customization after application launch.
        UITabBar.appearance().backgroundColor =  tabBarBackGroundColor
        UITabBar.appearance().unselectedItemTintColor = tabBarUnSelectedColor
        UITabBar.appearance().tintColor = UIColor.white
        DBmanager.shared.initDB()
        
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


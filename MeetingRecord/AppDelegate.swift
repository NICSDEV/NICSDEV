//
//  AppDelegate.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/01/10.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var blockRotation: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let main = MainViewController()
        main.isFirst = false
        self.window?.rootViewController = CusViewController.init(rootViewController: main)
        self.window?.makeKeyAndVisible()

//        let VC = self.window?.rootViewController as! CusViewController
//
//        let b = VC.childViewControllers[0] as! MainViewController
//
//        b.showAlert()

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UserDefaults.standard.set("", forKey: "custCoRStr")

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        let VC = self.window?.rootViewController as! CusViewController
//
//        let b = VC.childViewControllers[0] as! MainViewController
//
//        b.showAlert()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let string = url.absoluteString
        print("myurl",string)
        var tokenRange = string.range(of: "accessToken=")!
        var custCodeRange = string.range(of: "customerCode=")!
        var custNameRange = string.range(of: "customerName=")!
        
        var TokenRange = Range<String.Index>.init(uncheckedBounds: (lower: tokenRange.upperBound, upper: custCodeRange.lowerBound))

        var TokenStr = string.substring(with: TokenRange)
        
        var custCoRange = Range<String.Index>.init(uncheckedBounds: (lower: custCodeRange.upperBound, upper: custNameRange.lowerBound))
        
        var custCoRStr = string.substring(with: custCoRange)
        
//        var custNRange = Range<String.Index>.init(uncheckedBounds: (lower: tokenRange.upperBound, upper: custCodeRange.lowerBound))
        
        var custNStr = string.substring(from: custNameRange.upperBound)
        let myC = custCoRStr.substring(to: custCoRStr.index(custCoRStr.startIndex, offsetBy: custCoRStr.count - 1))
        let myT = TokenStr.substring(to: TokenStr.index(TokenStr.startIndex, offsetBy: TokenStr.count - 1))
//        if let string = String(data: custNStr, encoding: .utf8) {
//            print(string)
//        } else {
//            print("not a valid UTF-8 sequence")
//        }
          if let string :String = UserDefaults.standard.string(forKey: "custCoRStr"){
            if string != myC{
                self.window = UIWindow.init(frame: UIScreen.main.bounds)
                let main = MainViewController()
                main.isFirst = true
                self.window?.rootViewController = CusViewController.init(rootViewController: main)
                self.window?.makeKeyAndVisible()
            }
          }else{
            self.window = UIWindow.init(frame: UIScreen.main.bounds)
            let main = MainViewController()
            main.isFirst = true
            self.window?.rootViewController = CusViewController.init(rootViewController: main)
            self.window?.makeKeyAndVisible()
        }
        let b = custNStr.removingPercentEncoding! + " 様"
        UserDefaults.standard.set(myT, forKey: "TokenStr")
        UserDefaults.standard.set(myC, forKey: "custCoRStr")
        UserDefaults.standard.set(b, forKey: "custNStr")
        
//        MainViewController().refresh()
//        if let startIndex = text.index(of: "K"), let endIndex = text.index(of: "P") {
//            print(text[tokenRange?.upperBound...tokenRange?.lowerBound])
//            // -> "KLMNOP"
//        }

        
        return true
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.blockRotation{
            return UIInterfaceOrientationMask.all
        } else {
            return UIInterfaceOrientationMask.landscape
        }
        
    }

}


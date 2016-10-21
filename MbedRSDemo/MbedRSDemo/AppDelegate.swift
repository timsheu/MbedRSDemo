//
//  AppDelegate.swift
//  MbedRSDemo
//
//  Created by CCHSU20 on 9/12/16.
//  Copyright © 2016 CCHSU20. All rights reserved.
//

import UIKit
import CocoaLumberjack
import KSCrash
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        let emailAddress = "cchsu20@nuvoton.com"
        
        let installation = KSCrashInstallationEmail.sharedInstance()
        installation?.recipients = [emailAddress]
        installation?.subject = "Crash Report"
        installation?.message = "This is a crash report"
        installation?.filenameFmt = "crash-report-%d.json.gz"
        //        installation.reportStyle = KSCrashEmailReportStyleJSON
        
        installation?.addConditionalAlert(withTitle: "Crash Detected",
                                                  message: "The app crashed last time it was launched. Send a crash report?",
                                                  yesAnswer: "Sure!",
                                                  noAnswer: "No thanks")
        
        installation?.install()
        
        installation?.sendAllReports { (reports, completed, error) -> Void in
            if(completed) {
                print("Sent \(reports?.count) reports")
            } else {
                print("Failed to send reports: \(error)")
            }
        }
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


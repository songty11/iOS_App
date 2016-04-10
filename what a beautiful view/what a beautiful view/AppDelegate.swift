//
//  AppDelegate.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/30.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = NSUserDefaults.standardUserDefaults()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        /// - Attributions: http://nshipster.com/uiappearance/
        //modifie the color of NavigationBar and TabBar, Make it Gorgeous
        UINavigationBar.appearance().backgroundColor = UIColor.grayColor()
        UINavigationBar.appearance().tintColor = UIColor(red:251.0/255.0,green:145.0/255.0,blue:0.0/255.0,alpha:1.0)        
        UITabBar.appearance().tintColor = UIColor(red:251.0/255.0,green:145.0/255.0,blue:0.0/255.0,alpha:1.0)
        /// - Attributions: https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-nsuserdefaults
        //Remember the First Launch with Defaults
        if(defaults.objectForKey("firstLaunch") != nil)
        {
            print ("Not First Launch: ✌️")
        }
        else
        {
            defaults.setObject(NSDate(), forKey: "firstLaunch")
            print ("First Launch: 👆")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


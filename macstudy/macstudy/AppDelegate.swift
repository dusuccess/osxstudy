//
//  AppDelegate.swift
//  macstudy
//
//  Created by sierra on 2018/5/25.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Cocoa
import Quartz

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var openmenu: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSApp.activate(ignoringOtherApps: false)//取消其他程序的响应
        NSApplication.shared.windows[0].makeKeyAndOrderFront(self)//主窗口显示自己的方法
        return true
    }
}


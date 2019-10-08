//
//  AppDelegate.swift
//  Ninja
//
//  Created by mark on 11/06/2019.
//  Copyright © 2019 mark. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var aboutWindow: NSWindow!
    @IBOutlet weak var QuitMenu: NSMenuItem!
    
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    @IBOutlet weak var statusMenu: NSMenu!
    
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    var inDarkMode: Bool {
        let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
        return mode == "Dark"
    }
    
    func checkForMode(sender: AnyObject) {
        
        if inDarkMode {
            
            if let button = statusItem.button {
                button.image = NSImage(named: "Light@x2")
            }
        } else {
            
            if let button = statusItem.button {
                button.image = NSImage(named: "Dark@x2")
            }
            
        }
    }
    
    
    func changeMode(){
        let source = """
tell app "System Events" to tell appearance preferences to set dark mode to not dark mode
"""

        
        let script = NSAppleScript(source: source)!
        var errorDict : NSDictionary?
        script.executeAndReturnError(&errorDict)
        if errorDict != nil { print(errorDict!) }
        
        checkForMode(sender: AnyObject.self as AnyObject)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.action = #selector(self.checkClick(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        checkForMode(sender: AnyObject.self as AnyObject)
        
    }
    
    @IBAction func aboutClicked(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        aboutWindow.makeKeyAndOrderFront(sender)
    }
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
        }
    
    @objc func checkClick(sender: NSStatusItem) {
        
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            // Right button click
            statusItem.menu = nil
            changeMode()
            
        } else {
            // Left button click
            statusItem.menu = statusMenu
            statusItem.popUpMenu(statusMenu)//set the menu
            statusItem.menu = nil
            
        }
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}


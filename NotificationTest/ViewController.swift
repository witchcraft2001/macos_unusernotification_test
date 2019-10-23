//
//  ViewController.swift
//  NotificationTest
//
//  Created by Dmitry Mikhaltchenkov on 10/10/2019.
//  Copyright © 2019 Dmitry MIkhaltchenkov. All rights reserved.
//

import Cocoa
import UserNotifications

class ViewController: NSViewController {
    
    @IBAction func showNotify(_ sender: Any) {
        scheduleNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let url = createImage(NSColor(red: 1, green: 0, blue: 0, alpha: 0.5), NSSize(width: 50, height: 50))
        
//        let url = URL(fileURLWithPath: "file:///Users/dima/Downloads/IMG_4591.JPG", isDirectory: false)
//        let fm = FileManager.default
//        if fm.fileExists(atPath: url.absoluteString) {
//            do {
//                let attachment = try UNNotificationAttachment(identifier: "image", url: url, options: nil)
//                content.attachments = [attachment]
//            } catch let error {
//                print(error)
//            }
//        }
        if let attachment = try? UNNotificationAttachment(identifier: "image", url: url, options: nil) {
            content.attachments = [attachment]
        }
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func createImage(_ color: NSColor, _ size: NSSize) -> URL {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSMakeRect(0, 0, size.width, size.height))
        image.unlockFocus()
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("test.png", isDirectory: false)
        let _ = image.writeToFile(file: url, usingType: .png)
        return url;
    }
}


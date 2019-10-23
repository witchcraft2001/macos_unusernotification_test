//
//  ViewController.swift
//  NotificationTest
//
//  Created by Dmitry Mikhaltchenkov on 10/10/2019.
//  Copyright © 2019 Dmitry MIkhaltchenkov. All rights reserved.
//

import Foundation
import Cocoa
import UserNotifications

class ViewController: NSViewController {
    
    private var center: UNUserNotificationCenter?
    private let handler = NotificationHandler()
    private let notifyCategoryIdentifier = "test"
    
    @IBAction func showNotify(_ sender: Any) {
        scheduleNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.center = UNUserNotificationCenter.current()
        self.center?.delegate = self.handler
        self.initNotifications()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Test notification"
        content.body = "Message of test notification"
        content.categoryIdentifier = self.notifyCategoryIdentifier
        content.userInfo = ["customData": "test"]
        content.sound = UNNotificationSound.default
        
        //Create image with solid color
        let url = createImage(NSColor(red: 1, green: 0, blue: 0, alpha: 0.5), NSSize(width: 50, height: 50))
        
        //Add this image to attachment of notification for show in alert
        if let attachment = try? UNNotificationAttachment(identifier: "image", url: url, options: nil) {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        let alert = NSAlert()
        alert.informativeText = "Notification created, after 5 seconds it will be shown. Please wait..."
        alert.messageText = "Successful"
        alert.runModal()
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
    
    private func initNotifications() {
        guard let center = self.center else { return }
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Successful authorized!")
                // Define the custom actions.
                let byeAction = UNNotificationAction(identifier: NotificationActionsEnum.bye.rawValue, title: NSLocalizedString("Bye", comment: ""), options: UNNotificationActionOptions(rawValue: 0))
                
                let sayHelloAction = UNNotificationAction(identifier: NotificationActionsEnum.sayHello.rawValue, title: NSLocalizedString("Hello", comment: ""), options: UNNotificationActionOptions(rawValue: 0))
                
                // Define the notification type
                let testCategory = UNNotificationCategory(identifier: self.notifyCategoryIdentifier, actions: [byeAction, sayHelloAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
                
                center.setNotificationCategories([testCategory])
            } else {
                print("Authorization denied!")
                return
            }
        }
    }
}

//
//  NotificationService.swift
//  NotificationTextExtention
//
//  Created by Dmitry Mikhaltchenkov on 10/10/2019.
//  Copyright © 2019 Dmitry MIkhaltchenkov. All rights reserved.
//

import UserNotifications
import Cocoa

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            let url = createImage(NSColor(red: 1, green: 0, blue: 0, alpha: 0.5), NSSize(width: 50, height: 50))
            
            if let attachment = try? UNNotificationAttachment(identifier: "image", url: url, options: nil) {
                bestAttemptContent.attachments = [attachment]
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
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

//
//  NSImage.swift
//  NotificationTest
//
//  Created by Dmitry Mikhaltchenkov on 10/10/2019.
//  Copyright © 2019 Dmitry MIkhaltchenkov. All rights reserved.
//

import Foundation
import Cocoa

extension  NSImage {
    func writeToFile(file: URL, usingType type: NSBitmapImageRep.FileType) -> Bool {
        let properties = [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]
        guard
            let imageData = tiffRepresentation,
            let imageRep = NSBitmapImageRep(data: imageData),
            let fileData = imageRep.representation(using: type, properties: properties)
            else { return false }
        
        do {
            try fileData.write(to: file)
        } catch {
            return false
        }
        return true
    }
}

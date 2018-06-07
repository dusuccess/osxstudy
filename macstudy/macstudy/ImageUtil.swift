//
//  ImageUtil.swift
//  macstudy
//
//  Created by sierra on 2018/6/6.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Cocoa
import Quartz

class ImageUtil:NSObject{
    static func imageClip(_ image:NSImage,_ crect:NSRect)->CGImage{
        let source = CGImageSourceCreateWithData(image.tiffRepresentation! as CFData, nil)
        let imageRef = CGImageSourceCreateImageAtIndex(source!, 0, nil)
        
        let x:CGFloat = crect.origin.x
        let y:CGFloat = crect.origin.y
        let width:CGFloat = crect.width
        let height:CGFloat = crect.height
        
        let myImageArea = CGRect(x: x, y: y, width: width, height: height)
        let mySubImage = imageRef?.cropping(to: myImageArea)
//        var newImage = NSImage.init(cgImage: mySubImage, size: myImageArea.size)
        return mySubImage!
    }
    
    static func resizeImage(_ image:NSImage,_ rsize:NSSize)->NSImage{
        let targetFrame = NSRect(x: 0, y: 0, width: rsize.width, height: rsize.height)
        
        let imageRep = image.bestRepresentation(for: targetFrame, context: nil, hints: nil)
        let targetImage = NSImage.init(size: rsize)
        targetImage.lockFocus()
        imageRep?.draw(in: targetFrame)
        targetImage.unlockFocus()
        
        return targetImage
    }
    
    static func saveImage(_ image:NSImage){
        let panel = NSSavePanel.init()
        panel.title = "保存图片"
        panel.message = "选择图片保存地址"
        panel.nameFieldStringValue = "icon"
        panel.allowsOtherFileTypes = true
        panel.allowedFileTypes = ["png"]
        panel.isExtensionHidden = false
        panel.begin(completionHandler: { (result) in
            if(result == NSApplication.ModalResponse.OK){
                let path = panel.url?.path
                print(path)
                let data = image.tiffRepresentation as! NSData
                data.write(toFile: path!, atomically: true)
            }
        })
    }
}


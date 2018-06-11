//
//  MWNSImageView.swift
//  ImageClip
//
//  Created by sierra on 2018/6/8.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Cocoa

class MWNSImageView:NSImageView{
    var width:CGFloat!
    var height:CGFloat!
    var Img_X:CGFloat!
    var Img_Y:CGFloat!
    var Img_Width:CGFloat!
    var Img_Height:CGFloat!
    var startPoint:NSPoint!
    var scaleX:CGFloat!
    var scaleY:CGFloat!
    var scaleFactor:CGFloat!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        width = frameRect.width
        height = frameRect.height
        Img_Width = 0
        Img_Height = 0
        Img_X = 0
        Img_Y = 0
        scaleFactor = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didResize(_ size:CGSize){
        self.frame.size = size
        
        width = size.width
        height = size.height
        
        Img_Width = width
        Img_Height = height
        
        scaleFactor = 1
        
        Img_X = 0
        Img_Y = 0
    }
    
    func setImage(_ image: CGImage!, imageProperties metaData: [AnyHashable : Any]!) {
        self.image = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
        if(CGFloat(image.width) < width && CGFloat(image.height) < height){
            scaleX = CGFloat(image.width)/width
            scaleY = CGFloat(image.height)/height
        }else if(CGFloat(image.width)/width > CGFloat(image.height)/height){
            scaleX = 1
            scaleY = width*CGFloat(image.height)/CGFloat(image.width)/height
        }else{
            scaleY = 1
            scaleX = height*CGFloat(image.width)/CGFloat(image.height)/width
        }
        
        Img_Width = width
        Img_Height = height
        Img_X = 0
        Img_Y = 0
    }
    
    func setImageWith(_ url: URL!) {
        let image = NSImage(contentsOf: url)
        let reps = NSBitmapImageRep.imageReps(with: (image?.tiffRepresentation)!)
        let size = NSSize.init(width: (reps.first?.pixelsWide)!, height: (reps.first?.pixelsHigh)!)
        image?.size = size
        self.image = image
        if(CGFloat(size.width) < width && CGFloat(size.height) < height){
            scaleX = CGFloat(size.width)/width
            scaleY = CGFloat(size.height)/height
        }else if(CGFloat(size.width)/width > CGFloat(size.height)/height){
            scaleX = 1
            scaleY = width*CGFloat(size.height)/CGFloat(size.width)/height
        }else{
            scaleY = 1
            scaleX = height*CGFloat(size.width)/CGFloat(size.height)/width
        }
        
        Img_Width = width
        Img_Height = height
        Img_X = 0
        Img_Y = 0
    }
    
    override func mouseDown(with event: NSEvent) {
        self.startPoint = event.locationInWindow
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = event.locationInWindow
        let movX = point.x - self.startPoint.x
        let movY = point.y - self.startPoint.y
        self.startPoint = point
        Img_X = Img_X + movX
        Img_Y = Img_Y + movY
        
        self.translateOrigin(to: NSPoint(x: movX/scaleFactor, y: movY/scaleFactor))
        
        print("x:\(Img_X) y:\(Img_Y)")
    }
    
    override func scrollWheel(with event: NSEvent) {
        let scale = (event.deltaY+10)/10
        
        scaleFactor = scaleFactor*scale
        
        Img_Width = Img_Width*scale
        Img_Height = Img_Height*scale

        let endX = (width-Img_Width)/2
        let endY = (height-Img_Height)/2

        let movX = endX - Img_X
        let movY = endY - Img_Y

        Img_X = endX
        Img_Y = endY
        
        self.scaleUnitSquare(to: NSSize(width: scale, height: scale))
        self.translateOrigin(to: NSPoint(x: movX/scaleFactor, y: movY/scaleFactor))
    }
    
    func getImageRect()->NSRect{
        let rect = NSRect(x: Img_X+(1-scaleX)*Img_Width/2, y: Img_Y+(1-scaleY)*Img_Height/2, width: Img_Width*scaleX, height: Img_Height*scaleY)
        return rect
    }
}

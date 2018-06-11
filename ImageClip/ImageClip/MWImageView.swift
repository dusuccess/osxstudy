//
//  MWImageView.swift
//
//  Created by sierra on 2018/6/4.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Quartz

class MWImageView:IKImageView{
    var width:CGFloat!
    var height:CGFloat!
    var Img_X:CGFloat!
    var Img_Y:CGFloat!
    var Img_Width:CGFloat!
    var Img_Height:CGFloat!
    var startPoint:NSPoint!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        width = frameRect.width
        height = frameRect.height
        Img_Width = 0
        Img_Height = 0
        Img_X = 0
        Img_Y = 0
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didResize(_ size:CGSize){
        width = size.width
        height = size.height
        Img_X = (width-Img_Width)/2 < 0 ? 0 : (width-Img_Width)/2
        Img_Y = (height-Img_Height)/2 < 0 ? 0 : (height-Img_Height)/2
    }
    
    override func setImage(_ image: CGImage!, imageProperties metaData: [AnyHashable : Any]!) {
        super.setImage(image, imageProperties: metaData)
        Img_Width = CGFloat(image.width)
        Img_Height = CGFloat(image.height)
        Img_X = (width-Img_Width)/2 < 0 ? 0 : (width-Img_Width)/2
        Img_Y = (height-Img_Height)/2 < 0 ? 0 : (height-Img_Height)/2
        print("x:\(Img_X) y:\(Img_Y)")
    }
    
    override func setImageWith(_ url: URL!) {
        super.setImageWith(url)
        let size = super.imageSize()
        Img_Width = size.width
        Img_Height = size.height
        Img_X = (width-Img_Width)/2 < 0 ? 0 : (width-Img_Width)/2
        Img_Y = (height-Img_Height)/2 < 0 ? 0 : (height-Img_Height)/2
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.startPoint = event.locationInWindow
    }
    
    override func mouseMoved(with event: NSEvent) {
        print("move")
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        let point = event.locationInWindow
        if(self.startPoint.x>Img_X && self.startPoint.x<(Img_X+Img_Width) && self.startPoint.y>Img_Y && self.startPoint.y < (Img_Y+Img_Height)){
            let movX = point.x - self.startPoint.x
            let movY = point.y - self.startPoint.y
            self.startPoint = point
            Img_X = Img_X + movX
            Img_Y = Img_Y + movY
            
            if(Img_X >= width/2){
                Img_X = width/2
            }else if(Img_X <= (width/2 - Img_Width)){
                Img_X = width/2 - Img_Width
            }
            
            if(Img_Y >= height/2){
                Img_Y = height/2
            }else if(Img_Y <= (height/2 - Img_Height)){
                Img_Y = width/2 - Img_Height
            }
        }
        print("x:\(Img_X) y:\(Img_Y)")
    }
    
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        let scale = (event.deltaY+10)/10
        self.zoomFactor = self.zoomFactor*scale
        Img_Width = Img_Width*scale
        Img_Height = Img_Height*scale
        Img_X = (width-Img_Width)/2 < 0 ? 0 : (width-Img_Width)/2
        Img_Y = (height-Img_Height)/2 < 0 ? 0 : (height-Img_Height)/2
    }
    
    func getImageRect()->NSRect{
        let rect = NSRect(x: Img_X, y: Img_Y, width: Img_Width, height: Img_Height)
        return rect
    }
}

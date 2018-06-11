//
//  ViewController.swift
//  ImageClip
//
//  Created by sierra on 2018/6/7.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController,windowDelegate {

    var image:NSImage?
    
    @IBAction func selectFile(_ sender: NSButton) {
        let panel = NSOpenPanel()
        panel.directoryURL = URL.init(string:NSHomeDirectory())
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedFileTypes = ["png","jpg","jpeg"]
        panel.allowsOtherFileTypes = false
        if(panel.runModal().rawValue == NSOKButton){
            self.image = NSImage(contentsOf: panel.urls.first!)
            let reps = NSBitmapImageRep.imageReps(with: (image?.tiffRepresentation)!)
            let size = NSSize.init(width: (reps.first?.pixelsWide)!, height: (reps.first?.pixelsHigh)!)
            self.image?.size = size
            var imgRect = NSRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
//            let newImage = self.clipImage(image!)
            self.clipImageView.setImage(image?.cgImage(forProposedRect: &imgRect, context: nil, hints: nil), imageProperties: nil)
            self.clipImageView.isHidden = false
        }
    }
    
    @IBAction func saveImage(_ sender: NSButton){
        let rect = self.clipImageView.getImageRect()
        let newImage = self.clipImage(self.image!, rect: NSRect(x: rect.origin.x-(self.view.frame.width-400)/2, y: rect.origin.y-(self.view.frame.height-400)/2, width: rect.width, height: rect.height))
        
        if(newImage != nil){
            var panel = NSOpenPanel.init()
            panel.directoryURL = URL.init(string: NSHomeDirectory())
            panel.allowsMultipleSelection = false
            panel.canChooseFiles = false
            panel.canCreateDirectories = true
            panel.canChooseDirectories = true
            panel.allowedFileTypes = []
            panel.allowsOtherFileTypes = false
            if(panel.runModal().rawValue == NSOKButton){
                let fileManager = FileManager.default
                let path = panel.urls.first?.path
                let iospath = path?.appending("/ios")
                do{
                    try fileManager.createDirectory(atPath: iospath!, withIntermediateDirectories: true, attributes: nil)
                    let data = newImage.tiffRepresentation
                    let imgRep = NSBitmapImageRep.init(data: data!)
                    imgRep?.size = newImage.size
                    let data1 = imgRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) as! NSData
                    let ipath = iospath?.appending("/clip.png")
                    data1.write(toFile: ipath!, atomically: true)
                }catch{
                    print(error)
                }
            }
        }
    }
    
    var clipImageView:MWNSImageView!
    var circleView:CircleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer?.backgroundColor = CGColor.black
        CustomWindowManager.delegate = self
        
        self.clipImageView = MWNSImageView(frame: NSRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.clipImageView.layer?.backgroundColor = CGColor.black
        self.view.addSubview(self.clipImageView)
        self.clipImageView.isHidden = true
        
        self.circleView = CircleView(frame: NSRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(circleView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func windowDidResize() {
//        self.clipImageView.frame = self.view.frame
//        self.clipImageView.didResize(self.view.frame.size)
        self.clipImageView.removeFromSuperview()
        self.clipImageView = MWNSImageView(frame: NSRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.clipImageView.layer?.backgroundColor = CGColor.black
        self.view.addSubview(self.clipImageView)
        self.clipImageView.isHidden = true
        if(self.image != nil){
            var imgRect = NSRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
            self.clipImageView.setImage(self.image?.cgImage(forProposedRect: &imgRect, context: nil, hints: nil), imageProperties: nil)
            self.clipImageView.isHidden = false
        }
        
        self.circleView.removeFromSuperview()
        
        self.circleView = CircleView(frame: NSRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(self.circleView)
    }
    
    func windowWillResize(size: NSSize) {
        
    }

    func clipImage(_ image:NSImage,rect:NSRect)->NSImage{
        let newImg = NSImage.init(size: CGSize(width: 400, height: 400))
        newImg.lockFocus()
        let imgContext = NSGraphicsContext.current?.cgContext
//        var rect = CGRect(x: -80, y: -80, width: image.size.width, height: image.size.height)
        var iRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let crect:CGRect = CGRect(x: 0, y: 0, width: 400, height: 400)//截切框
        imgContext?.addEllipse(in: crect)//根据剪切框剪切一个椭圆
        imgContext?.clip()
        imgContext?.draw(image.cgImage(forProposedRect: &iRect, context: nil, hints: nil)!, in: rect)
        newImg.unlockFocus()
        
        return newImg
    }
}


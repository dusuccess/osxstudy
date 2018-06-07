//
//  ViewController.swift
//  macstudy
//
//  Created by sierra on 2018/5/25.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController,windowDelegate {

    @IBOutlet weak var fileBtn: NSButton!
    @IBAction func fileSelect(_ sender: NSButton) {
//        IKPictureTaker().beginSheet(for: self.view.window,withDelegate: self,didEnd: #selector(self.pictureTakerDidEnd(picker:returnCode:contextInfo:)),contextInfo: nil)
        var panel = NSOpenPanel.init()
        panel.directoryURL = URL.init(string: NSHomeDirectory())
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedFileTypes = ["jpeg","jpg","png"]
        panel.allowsOtherFileTypes = false
        if(panel.runModal().rawValue == NSOKButton){
//            let path = panel.urls.first?.path
            self.image = NSImage(contentsOf: panel.urls.first!)
            var reps = NSBitmapImageRep.imageReps(with: (image?.tiffRepresentation)!)
            let size = NSSize.init(width: (reps.first?.pixelsWide)!, height: (reps.first?.pixelsHigh)!)
            image?.size = size
//            let cgimage = ImageUtil.imageClip(image!)
//            let rimg = ImageUtil.resizeImage(image!, NSSize(width: 200, height: 200))
            var imgRect = NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
//            print(imgRect)
            
            self.imageView.setImage(image.cgImage(forProposedRect: &imgRect, context: nil, hints: nil), imageProperties: nil)
//            self.imageView.setImageWith(panel.urls.first!)
            self.imageView.isHidden = false
            self.view.addSubview(self.imageView)
            print(self.imageView.frame)
            self.fileBtn.isHidden = true
        }
    }
    
    var image:NSImage!
    let iosSize = [40,58,60,80,87,120,180,1024]
    let androidSize = [40,60,120]
    @IBAction func saveFile(_ sender: NSButton) {
        if(image != nil){
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
                let androidpath = path?.appending("/android")
                do{
                    try fileManager.createDirectory(atPath: iospath!, withIntermediateDirectories: true, attributes: nil)
                    try fileManager.createDirectory(atPath: androidpath!, withIntermediateDirectories: true, attributes: nil)
                    for size in iosSize{
                        let img = ImageUtil.resizeImage(self.image, NSSize(width: size, height: size))
                        let data = img.tiffRepresentation
                        let imgRep = NSBitmapImageRep.init(data: data!)
                        imgRep?.size = self.image.size
                        let data1 = imgRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) as! NSData
                        let ipath = iospath?.appending("/\(size).png")
                        data1.write(toFile: ipath!, atomically: true)
                    }
                    
//                    for size in androidSize{
//                        let img = ImageUtil.resizeImage(self.image, NSSize(width: size, height: size))
//                        let data = img.tiffRepresentation
//                        let imgRep = NSBitmapImageRep.init(data: data!)
//                        imgRep?.size = self.image.size
//                        let data1 = imgRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:]) as! NSData
//                        let ipath = androidpath?.appending("/\(size).png")
//                        data1.write(toFile: ipath!, atomically: true)
//                    }
                }catch{
                    print(error)
                }
            }
        }
        
    }
    
    var imageView: MWImageView!
//    var imageView: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomWindowManager.delegate = self
        
        self.imageView = MWImageView(frame: NSRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.imageView.backgroundColor = NSColor.white
        self.imageView.currentToolMode = "IKToolModeMove"
        self.view.addSubview(self.imageView)
        self.imageView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func windowDidResize() {
        self.imageView.frame.size = self.view.frame.size
        self.imageView.didResize(self.view.frame.size)
        print(self.imageView.getImageRect())
    }
    
    func windowWillResize(size: NSSize) {
//        self.imageView.frame.size = self.view.frame.size
//        print(self.imageView.frame)
    }
    
    var startPoint:NSPoint!
    override func mouseDown(with event: NSEvent) {
        print("down")
        startPoint = event.locationInWindow
//        print(startPoint)
    }
    
//    override func rightMouseDown(with event: NSEvent) {
//        print("rightdown")
//        let point = event.locationInWindow
//        print(point)
//    }
//
//    override func mouseUp(with event: NSEvent) {
//        print("up")
//        let point = event.locationInWindow
//        print(point)
//    }
    
    override func mouseDragged(with event: NSEvent) {
//        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        print("drag")
        let point = event.locationInWindow
        let movX = point.x - self.startPoint.x
        let movY = point.y - self.startPoint.y
        self.startPoint = point
        self.imageView.translateOrigin(to: NSPoint(x: movX, y: movY))
        print(self.imageView.bounds)
    }
    
//    override func mouseEntered(with event: NSEvent) {
//        print("enter")
//        let point = event.locationInWindow
//        print(point)
//    }
//
//    override func mouseMoved(with event: NSEvent) {
//        let point = event.locationInWindow
//        print("move")
//        print(point)
//    }
    
    override func scrollWheel(with event: NSEvent) {
        print("scroll")
//        let scale = (event.deltaY+10)/10
//        self.imageView.zoomFactor = self.imageView.zoomFactor*scale
//        self.imageView.translatesAutoresizingMaskIntoConstraints = true
//        self.imageView.scaleUnitSquare(to: NSSize(width: scale, height: scale))
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func windowDidResize(_ notification: Notification) {
        print("didresize")
    }
}


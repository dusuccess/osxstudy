//
//  CustomWindowManager.swift
//  ImageClip
//
//  Created by sierra on 2018/6/7.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Cocoa

protocol windowDelegate {
    func windowDidResize()
    func windowWillResize(size:NSSize)
}

class CustomWindowManager:NSWindowController,NSWindowDelegate{
    
    public static var delegate:windowDelegate?
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowDidResize(_ notification: Notification) {
        //        print("didResize")
        CustomWindowManager.delegate?.windowDidResize()
    }
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        CustomWindowManager.delegate?.windowWillResize(size: frameSize)
        return frameSize
    }
}

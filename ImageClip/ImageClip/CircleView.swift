//
//  CircleView.swift
//  ImageClip
//
//  Created by sierra on 2018/6/8.
//  Copyright © 2018年 sierra. All rights reserved.
//

import Cocoa

class CircleView:NSView{
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.wantsLayer = true
        self.layer?.backgroundColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        let crect = NSRect(x: (dirtyRect.width-400)/2, y: (dirtyRect.height-400)/2, width: 400, height: 400)
        let path = NSBezierPath(ovalIn: crect)
        let gradient = NSGradient(colors: [NSColor.init(red: 1, green: 1, blue: 1, alpha: 0.1)])
        gradient?.draw(in: path, angle: 360)
        let circle = CAShapeLayer.init()
        let path1 = NSBezierPath.init()
        path1.appendArc(withCenter: NSPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: 200.75, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        path1.appendArc(withCenter: NSPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), radius: 200.75, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: false)
        circle.path = path1.cgPath
        circle.fillColor = CGColor.clear
        circle.strokeColor = CGColor.white
        circle.lineWidth = 1.5
        self.layer?.addSublayer(circle)
    }
}

extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePathBezierPathElement:
                path.closeSubpath()
            }
        }
        
        return path
    }
}

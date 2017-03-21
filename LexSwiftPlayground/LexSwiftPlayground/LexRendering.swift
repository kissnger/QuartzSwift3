//
//  LexRendering.swift
//  LexSwiftPlayground
//
//  Created by Massimo on 2017/3/18.
//  Copyright © 2017年 Massimo. All rights reserved.
//

import UIKit




class LexPattern: UIView {
    //		isColored = true
    lazy var coloredPatternColor:CGColor = {
        
        var coloredPatternCallBacks = CGPatternCallbacks(version: 0, drawPattern: { (p, context) in
            context.setFillColor(red: 0.0/255.0, green: 0.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            context.fill(CGRect(x: 0.0, y: 0.0, width: 8.0, height: 8.0))
            context.fill(CGRect(x: 8.0, y: 8.0, width: 8.0, height: 8.0))
            
            context.setFillColor(red: 0.0/255.0, green: 224.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            context.fill(CGRect(x: 8.0, y: 0.0, width: 8.0, height: 8.0))
            context.fill(CGRect(x: 0.0, y: 8.0, width: 8.0, height: 8.0))
        }, releaseInfo: nil)
        
        let coloredPattern = CGPattern(info: nil, bounds: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 16.0), matrix: CGAffineTransform.identity, xStep: 16.0, yStep: 16.0, tiling: .noDistortion, isColored: true, callbacks: &coloredPatternCallBacks)
        let coloredPatternColorSpace = CGColorSpace(patternBaseSpace: nil)
        
        var alpha:CGFloat = 1.0
        
        return CGColor(patternSpace: coloredPatternColorSpace!, pattern: coloredPattern!, components: &alpha)!
    }()
    
    //		isColored = false
    lazy var uncoloredPatten:CGPattern = {
        
        var uncoloredPatternCallbacks = CGPatternCallbacks(version: 0, drawPattern: { (p, context) in
            
            //            context.move(to: CGPoint(x: 0, y: 0))
            //            context.addLine(to: CGPoint(x: 16.0, y: 8.0))
            //            context.addLine(to: CGPoint(x: 0.0, y: 16.0));
            //            context.setLineWidth(1.0)
            //            context.closePath()
            //            context.fillPath()
            
            context.fill(CGRect(x: 0.0, y: 0.0, width: 8.0, height: 8.0))
            context.fill(CGRect(x: 8.0, y: 8.0, width: 8.0, height: 8.0))
        }, releaseInfo: nil)
        
        return CGPattern(info: nil, bounds: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 16.0), matrix: CGAffineTransform.identity, xStep: 16.0, yStep: 16.0, tiling: .noDistortion, isColored: false, callbacks: &uncoloredPatternCallbacks)!
    }()
    
    
    lazy var uncolorePatternColorSpace:CGColorSpace = {
        let deviceRGB = CGColorSpaceCreateDeviceRGB();
        return  CGColorSpace(patternBaseSpace: deviceRGB)!
    }()
    
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(coloredPatternColor)
        ctx?.fill(CGRect(x: 20.0, y: 20.0, width: 90.0, height: 90.0))
        
        
        ctx?.setStrokeColor(coloredPatternColor)
        ctx?.stroke(CGRect(x: 120.0, y: 20.0, width: 90.0, height: 90.0), width: 8.0)
        
        ctx?.setFillColorSpace(uncolorePatternColorSpace)
        var red = [CGFloat(1.0),CGFloat(0.0),CGFloat(0.0),CGFloat(1.0)]
        ctx?.setFillPattern(self.uncoloredPatten, colorComponents:&red)
        ctx?.fill(CGRect(x: 20.0, y: 120.0, width: 90.0, height: 90.0))
        
        var green = [CGFloat(0.0),CGFloat(1.0),CGFloat(0.0),CGFloat(1.0)]
        ctx?.setFillPattern(uncoloredPatten, colorComponents: &green)
        ctx?.fill(CGRect(x: 20, y: 220.0, width: 90.0, height: 90.0))
        
        
        ctx?.setStrokeColorSpace(uncolorePatternColorSpace)
        ctx?.setStrokePattern(uncoloredPatten, colorComponents: &red)
        ctx?.stroke(CGRect(x: 120.0, y: 118.0, width: 90.0, height: 90.0), width: 8.0)
        
        ctx?.setStrokePattern(uncoloredPatten, colorComponents: &green)
        ctx?.stroke(CGRect(x: 120, y: 216.0, width: 90.0, height: 90.0), width: 8.0)
        
        
    }
}

enum GradientType:NSInteger {
    case kLinearGradient = 0;
    case kRadialGradient = 1;
}


class LexGradint: UIView {
    
    var type : GradientType?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var extendsPastStart:Bool?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var extentsPastEnd:Bool?{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    lazy var gradient:CGGradient = {
        let rgb = CGColorSpaceCreateDeviceRGB();
        var colors:[CGFloat] =
            [
                204.0 / 255.0 , 224.0 / 255.0 , 244.0 / 255.0, 1.00,
                29.0  / 255.0 , 156.0 / 255.0 , 215.0 / 255.0, 1.00,
                0.0   / 255.0 , 50.0  / 255.0 , 126.0 / 255.0, 1.00
        ];
//        这里跟官方给的OC版本 有些出入 locations  在swift里不能设置成nil  否则会出问题
        let locations:[CGFloat] = [0,0.4,1]
        return  CGGradient(colorSpace: rgb, colorComponents: &colors, locations: locations, count: locations.count)!
        
    }()
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            let clip =  rect.insetBy(dx: 3, dy: 3)
            
            var start : CGPoint?, end : CGPoint?;
            var startRadius : CGFloat?, endRadius : CGFloat?;
            
            context.saveGState()
            context.clip(to: clip)
            
            
            let options = drawingOptions()
            
            switch type! {
            case .kLinearGradient:
                
                start = demoLGStart(bounds: clip)
                end = demoLGEnd(bounds: clip)
               
                context.drawLinearGradient(self.gradient, start: start!, end: end!, options: options)
                context.restoreGState()
                
                break;
            case .kRadialGradient:
                
                start = demoRGCenter(bounds:clip);
                end = demoRGCenter(bounds:clip);
                startRadius = demoRGInnerRadius(bounds:clip);
                endRadius = demoRGOuterRadius(bounds: clip);
                
                context.drawRadialGradient(gradient, startCenter: start!, startRadius: startRadius!, endCenter: end!, endRadius: endRadius!, options: options)
                context.restoreGState()
                
                break;
                
            }
             
            context.setStrokeColor(UIColor.red.cgColor)
            context.stroke(clip, width: 2.0)
            
        }
    }
    
    func drawingOptions() -> CGGradientDrawingOptions {
        var options  = 0;
        
        
        // 这里真的想吐槽啊  有没有朋友 有更好的写法
        if self.extendsPastStart! {
            options |= Int(CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue)
        }
        if self.extentsPastEnd!{
            options |= Int(CGGradientDrawingOptions.drawsAfterEndLocation.rawValue)
        }
        return CGGradientDrawingOptions(rawValue: UInt32(options))
    }
    
    func demoLGStart(bounds:CGRect)->CGPoint{
        return CGPoint(x:bounds.origin.x, y:bounds.origin.y + bounds.size.height * 0.25);
    }
    
    func demoLGEnd(bounds:CGRect)->CGPoint{
        return CGPoint(x:bounds.origin.x, y:bounds.origin.y + bounds.size.height * 0.75);
    }
    
    func demoRGCenter(bounds:CGRect)->CGPoint{
        return CGPoint(x:bounds.midX, y:bounds.midY);
    }
    
    func demoRGInnerRadius(bounds:CGRect)->CGFloat {
        let r : CGFloat = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
        return r * 0.125;
    }
    
    func demoRGOuterRadius(bounds:CGRect)->CGFloat{
        let r : CGFloat =  bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
        return r * 0.5;
    }
    
}

//MARK: - viewcontroller

class LexGradintViewController: UIViewController {
    @IBOutlet var gradientView:LexGradint?;
    @IBOutlet var typeControl:UISegmentedControl?;
    @IBOutlet var startSwitch:UISwitch?;
    @IBOutlet var endSwitch:UISwitch?;
    
    @IBAction func takeType(sender:UISegmentedControl){
        gradientView?.type = GradientType(rawValue: sender.selectedSegmentIndex)!;
    }
    
    @IBAction func takeStart(sender:UISwitch){
        gradientView?.extendsPastStart = sender.isOn;
    }
    @IBAction func takeEnd(sender:UISwitch){
        gradientView?.extentsPastEnd = sender.isOn;
    }
    
    override func viewDidLoad() {
        gradientView?.type = GradientType(rawValue: typeControl!.selectedSegmentIndex)!;
        gradientView?.extendsPastStart = startSwitch!.isOn;
        gradientView?.extentsPastEnd = endSwitch!.isOn;
        
        
    }
    
}








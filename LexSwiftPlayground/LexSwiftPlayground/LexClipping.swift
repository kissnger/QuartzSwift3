//
//  LexClipping.swift
//  LexSwiftPlayground
//
//  Created by Massimo on 2017/3/21.
//  Copyright © 2017年 Massimo. All rights reserved.
//

import UIKit

class LexClip: UIView {

    lazy var  image : CGImage = {
        let imagePath = Bundle.main.path(forResource: "icon", ofType: "png")
       return UIImage(contentsOfFile: imagePath!)!.cgImage!
    }()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
//        Core Graphics(Quartz)是基于2D的图形绘制引擎，它的坐标系则是y轴向上的；
//        当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，
//        因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
        
//      -----  1. <UIKit> 使用UIImage的drawInRect函数，该函数内部能自动处理图片的正确方向
//        UIGraphicsPushContext(context)
//        UIImage(cgImage: image).draw(in: CGRect(x: 110, y: 10, width: 90, height: 90))
//        UIGraphicsPopContext()
        
//      -----  2.<Core Graphics> 在绘制到context前通过矩阵垂直翻转坐标系
        let height = rect.height
        context.translateBy(x: 0.0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setFillColor(UIColor.red.cgColor)
        context.draw(image, in: CGRect(x: 10.0, y: height-100, width: 90.0, height: 90.0))
        
        context.saveGState()
//        剪辑部分
        let clips = [CGRect(x: 110.0, y: height - 100.0, width: 35.0, height: 90.0),
                     CGRect(x: 185.0, y: height - 100.0, width: 15.0, height: 90.0)]
        
        context.clip(to: clips)
        context.draw(image, in: CGRect(x: 110, y: height-100, width: 90, height: 90))
        context.restoreGState()
        
//        shape
        addStar(toContext: context, at: CGPoint(x: 55.0, y: height - 150), radius: 45.0, angle: 0.0)
        context.saveGState()
        context.clip()
        context.fill(CGRect(x: 10.0, y: height - 190, width: 90, height: 90))
        context.draw(image, in: CGRect(x: 55.0, y: height - 190, width: 90, height: 90))
        context.restoreGState()
//        even-odd 
        addStar(toContext: context, at: CGPoint(x: 155.0, y: height - 150), radius: 45.0, angle: 0.0)
        context.saveGState()
        context.clip(using: .evenOdd)
        context.fill(CGRect(x: 110.0, y: height - 190, width: 90, height: 90))
        context.draw(image, in: CGRect(x: 155.0, y: height - 190, width: 90, height: 90))
        context.restoreGState()
        
        addStar(toContext: context, at: CGPoint(x: 255.0, y: height - 150), radius: 45.0, angle: 0.0)
        context.addRect(CGRect(x: 210, y: height-190, width: 90, height: 90))
        context.saveGState()
        context.clip(using: .evenOdd)
        context.fill(CGRect(x: 210.0, y: height - 190, width: 90, height: 90))
        context.draw(image, in: CGRect(x: 255.0, y: height - 190, width: 90, height: 90))
        context.restoreGState()
        
    }
 
    
    func addStar(toContext context:CGContext, at center:CGPoint, radius:CGFloat, angle:CGFloat) {
        
        let el = CGFloat(M_PI / 5.0) * angle
        let x = radius * CGFloat(sinf(Float(el))) + center.x;
        let y = radius * CGFloat(cosf(Float(el))) + center.y;
        
        context.move(to: CGPoint(x: x, y: y))
        
        for i in 0...5 {
            let el = Float((Double(i) * 4.0  * M_PI + Double(angle))/5.0)
            let x = radius * CGFloat(sinf(Float(el))) + center.x;
            let y = radius * CGFloat(cosf(Float(el))) + center.y;
            
            context.addLine(to: CGPoint(x: x, y: y))
        }
        context.closePath()
    }

}


class LexMask: UIView {
    
    
    
    lazy var  alphaImage : CGImage? = {
        guard let imagePath = Bundle.main.path(forResource: "Ship", ofType: "png") else{
            print("alphaImage -- imagePath is nil")
            return nil
        }
        guard let img = UIImage(contentsOfFile: imagePath) else{
            print("alphaImage -- img is nil")
            return nil
        }
        return img.cgImage
    }()
    
    func maskingImage(context:CGContext) -> CGImage?{
        
        let width = self.alphaImage!.width
        let bitsPerComponent = self.alphaImage!.bitsPerComponent
        let bitsPerPixel = self.alphaImage!.bitsPerPixel
        let bytesPerRow = self.alphaImage!.bytesPerRow
        let colorSpace = self.alphaImage!.colorSpace!
        var data = NSMutableData(length: 90*90*4)!
//        官方的demo 实在下面创建一个 只有alpha通道的 上下文  并且写到 data中去
//        由于用swift实现 出现各种错误现在还没有办法去解决
//        图片的 colorSpace是 sRGB   也就是 每个单位包含4个字节 所以每行需要 4 * 90 个字节
        
        guard let context = CGContext(data:&data, width: 90, height: 90, bitsPerComponent: 8, bytesPerRow: 360, space: colorSpace, bitmapInfo:CGImageAlphaInfo.noneSkipFirst.rawValue ) else {
            print("maskingImage -- context is nil")
            return nil
        }
        context.setBlendMode(CGBlendMode.copy)
        guard let alphaImage = self.alphaImage else{
            print("maskingImage -- alphaImage is nil")
            return nil
        }
        
        // 这里 无法将上面的图片 画在上下文中 否则会导致crash
//        context.draw(alphaImage, in: CGRect(x: 0, y: 0, width: width, height: width))
        guard let dataProvider = alphaImage.dataProvider else{
            print("maskingImage -- dataProvider is nil")
            return nil
        }
        return CGImage(maskWidth: width, height: width, bitsPerComponent:bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, provider: dataProvider, decode: nil, shouldInterpolate: true)
        
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            print("context is nil")
            return;
        }
        let height = rect.height;
        context.translateBy(x: 0.0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setFillColor(UIColor.green.cgColor)
        
        context.saveGState()
        guard let alphaImage = self.alphaImage else {
            print("alphaImage is nil")
            return;
        }
        context.clip(to: CGRect(x: 10, y: height - 100.0, width: 90, height: 90), mask: alphaImage)
        context.fill(rect)
        context.restoreGState()
        
        context.saveGState()
        context.clip(to: CGRect(x: 110, y: height-190, width: 180, height: 180), mask: alphaImage)
        context.fill(rect)
        context.restoreGState()
        
        guard let maskImage = self.maskingImage(context: context) else {
            print("maskImage is nil")
            return;
        }
        
        context.saveGState()
        context.clip(to: CGRect(x: 10, y: height - 300 , width: 90, height: 90), mask: maskImage)
        context.fill(rect)
        context.restoreGState()
        
        context.saveGState()
        context.clip(to: CGRect(x: 110, y: height-390, width: 180, height: 180), mask: maskImage)
        context.fill(rect)
        context.restoreGState()
    }
}













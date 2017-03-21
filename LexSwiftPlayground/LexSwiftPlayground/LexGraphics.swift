//
//  LexGraphics.swift
//  LexSwiftPlayground
//
//  Created by Massimo on 2017/3/17.
//  Copyright © 2017年 Massimo. All rights reserved.
//

import UIKit

class LexGraphics: UIView {
  var context:CGContext!;
  
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
      
      print("view draw");
        // Drawing code
      context = UIGraphicsGetCurrentContext()
      drawText(text: "画字", point: CGPoint(x: 20, y: 20), fontSize: 15);
      
      
      drawLine(context: context , from: CGPoint(x:20,y:40), to: CGPoint(x:300,y:40))
      
      drawText(text: "画多边形和阴影和填充颜色", point: CGPoint(x: 20, y: 50), fontSize: 15);
      let bez = UIBezierPath(roundedRect: CGRect(x: 20, y: 80, width: 280, height: 50), cornerRadius: 4.0);
      
      saveGState {

        drawLine(context: context , from: CGPoint(x:20,y:75), to: CGPoint(x:300,y:75))
        
      }
      
      context.setShadow(offset: CGSize(width:2,height:2), blur: 5 );
      let isFill = true;
      if isFill {
//        填充
        context .setFillColor(UIColor.yellow.cgColor)
        UIColor.black.setStroke()
        bez.fill()
      }else{
//        描边
        UIColor.blue.setStroke()
        bez.stroke();
      }
      //      去掉阴影
      context.setShadow(offset: CGSize(width:0,height:0), blur: 0);
      drawText(text: "渐变填充颜色", point: CGPoint(x:20,y:140), fontSize: 15)

      saveGState {
        
        let newRect = CGRect(x: 40, y: 160, width: 240, height: 50);
        let newPath = UIBezierPath(ovalIn: newRect);
        newPath.addClip();
        let spaceColor = CGColorSpaceCreateDeviceRGB();
        
        let colors = [UIColor.gray.cgColor,UIColor.blue.cgColor];
        
        let locations:[CGFloat] = [0.0,1.0];
        
        let gradient = CGGradient(colorsSpace: spaceColor, colors: colors as CFArray, locations: locations);
        context.drawLinearGradient(gradient!, start:  CGPoint(x:40,y:160), end:  CGPoint(x:280,y:200), options: .drawsBeforeStartLocation);
   
      }
      
      
      drawText(text: "当前形变矩阵", point: CGPoint(x: 20, y: 230), fontSize: 15)
      context.translateBy(x: 20, y: 230);
      print("上下文位移");
      for _ in 0...2 {
        print("上下文旋转")
        context.rotate(by: 30 * CGFloat(M_PI)/180.0)
        
        drawText(text: "当前形变矩阵", point: CGPoint(x: 0, y: 0), fontSize: 15)
        
      }
      
//      把上下文位置移回原位
      context.rotate(by: -90 * CGFloat(M_PI)/180.0)
      context.translateBy(x: -20, y: -230);
      
      drawText(text: "当前形变矩阵 结束", point: CGPoint(x: 20, y: 330), fontSize: 15)
      
      
      
      
      
    }
  private func saveGState(drawStuff: () -> ()) -> () {
//    并不知道应用场景
    context.saveGState ()
    drawStuff()
    context.restoreGState ()
  }
  func drawText(text:NSString,point:CGPoint,fontSize:CGFloat) {
    UIColor.green.setStroke()
    let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize)]
    text.draw(at: point, withAttributes: attributes);
    print("Draw Text");
  }
  
  func drawLine(context:CGContext,from:CGPoint,to:CGPoint) {
    UIColor.green.setStroke()
    context.setLineWidth(1.2);
    context.move(to: from);
    context.addLine(to: to);
    context.setLineDash(phase: 7, lengths: [10,2]) //虚线设置
    context.strokePath();
    
  }

}


class LexGrid: UIView {
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    //绘制网格
    var y: CGFloat = 50
    while y < self.bounds.size.height {
      //2. 开始，设置绘制起点
      context?.move(to: CGPoint(x:0,y:y));
      //3. 往上下文上添加图形
      context?.addLine(to: CGPoint(x:self.bounds.size.width,y:y))
      y += 50
    }
    
    var x: CGFloat = 50
    while x < self.bounds.size.width {
      //2. 开始，设置绘制起点
      context?.move(to: CGPoint(x:x,y:0));
      //3. 往上下文上添加图形
      context?.addLine(to: CGPoint(x:x,y:self.bounds.size.height))
      
      x += 50
    }
    context?.saveGState()//保存绘图状态
    
    UIColor.cyan.setStroke()
    context?.setLineDash(phase: 0, lengths: [2,2])
    context?.strokePath()
    context?.restoreGState()//恢复保存时候的绘图状态
  }
}



class LexArc: UIView {
  override func draw(_ rect: CGRect) {
    // 画圆弧
//    1. 第一种
    // 获取上下文
    let ctx = UIGraphicsGetCurrentContext();
    // 画圆弧
    // center 圆心
    // radius 半径
    // startAngle 开始的弧度
    // endAngle 结束的弧度
    // clockwise 画圆弧的方向 (0 顺时针, 1 逆时针)

    let center = CGPoint(x: 100, y: 100)
    ctx?.addArc(center: center, radius: 50, startAngle: -CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: false)
    UIColor.blue.setStroke()
    // 渲染
         ctx?.strokePath(); 
    //    ctx?.closePath()
    //    ctx?.fillPath()
    
    
//   2.第二种
    ctx?.setStrokeColor(UIColor.red.cgColor)
    let p = [CGPoint(x:50,y:170),
             CGPoint(x:50,y:220),
             CGPoint(x:100,y:220)]
    ctx?.move(to: p[0])
    
    ctx?.addArc(tangent1End: p[1], tangent2End: p[2], radius: 50);
    ctx?.strokePath()
    
    ctx?.setStrokeColor(UIColor.blue.cgColor)
    ctx?.addLines(between: p)
    ctx?.strokePath()
    
//    3.画一个圆角矩形
    ctx?.setStrokeColor(UIColor.gray.cgColor)
    ctx?.setFillColor(UIColor.yellow.cgColor)
    let rectt = CGRect(x: 50, y: 240, width: 100, height: 50)
    let radius:CGFloat = 5.0;
    
    let leftx = rectt.minX , midx = rectt.midX , rightx = rectt.maxX ;
    let topy = rectt.minY , midy = rectt.midY , bottomy = rectt.maxY ;
    
    ctx?.move(to: CGPoint(x: leftx, y: midy))
    ctx?.addArc(tangent1End: CGPoint(x: leftx, y: topy), tangent2End: CGPoint(x: midx, y: topy), radius: radius)
    ctx?.addArc(tangent1End: CGPoint(x: rightx, y: topy), tangent2End: CGPoint(x: rightx, y: midy), radius: radius)
    ctx?.addArc(tangent1End: CGPoint(x: rightx, y: bottomy), tangent2End: CGPoint(x: midx, y: bottomy), radius: radius)
    ctx?.addArc(tangent1End: CGPoint(x: leftx, y: bottomy), tangent2End: CGPoint(x: leftx, y: midy), radius: radius)
    ctx?.closePath()
    ctx?.drawPath(using: .fillStroke)
    
  }
}


















//
//  LexDraw.swift
//  LexSwiftPlayground
//
//  Created by Massimo on 2017/3/17.
//  Copyright © 2017年 Massimo. All rights reserved.
//

import UIKit

enum LexShape : NSInteger{
  case arc = 0;
  case triangular = 1;
  case rectangle = 2;
}

class LexDraw: UIView {
  var shape:LexShape = LexShape(rawValue: 0)!
  func changeShape() {
    var value = shape.rawValue  + 1
    value = value > 2 ? 0 : value;
    shape = LexShape(rawValue:value)!;
    
  }
  
  override func draw(_ rect: CGRect) {
    switch shape {
    case .arc:
      drawArc(rect:rect)
    break
    case .triangular:
      drawTriangular(rect: rect)
    break
    case .rectangle:
      drawRect(rect: rect)
    break
    }
  }
  
  func drawTriangular(rect:CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    let width = rect.width;
    let p = CGPoint(x: width/2, y: 20);
    
    ctx?.move(to: p)
    ctx?.addLine(to: CGPoint(x: width-20, y: width-20))
    ctx?.addLine(to: CGPoint(x: 20, y: width-20))
    ctx?.closePath()
    UIColor.red.setFill()
    ctx?.fillPath()
  }
  
  
  func drawArc(rect:CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    let width = rect.width;
    let c = CGPoint(x: width/2, y: width/2);
    let radius = rect.size.width > rect.size.height ? rect.size.height/2 : rect.size.width/2
    ctx?.addArc(center: c, radius: radius - 20, startAngle: 0, endAngle:2 * CGFloat(M_PI), clockwise: true)
    UIColor.green.setFill()
    ctx?.fillPath()
    
  }
  
  func drawRect(rect:CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    let rec = CGRect(x: 20, y: 20, width: rect.width-40, height: rect.width-40)
    ctx?.addRect(rec);
    UIColor.blue.setFill()
    ctx?.fillPath()
    
  }
  
  
  
}

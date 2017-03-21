//
//  ViewController.swift
//  LexSwiftPlayground
//
//  Created by Massimo on 2017/3/17.
//  Copyright © 2017年 Massimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet weak var drawView: LexDraw!
   
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    drawView.backgroundColor = UIColor.white;
    self.view.addSubview(drawView);
    
    time(view: drawView)
    
 
  }
  
  func time(view:LexDraw ) {
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
     
      view.center = CGPoint(x: view.center.x, y: view.center.y-20);
      view.changeShape()
      view.setNeedsDisplay()
    }) { (t) in
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
        view.center = CGPoint(x: view.center.x, y: view.center.y+20)
      })
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
      self.time(view: view);
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}


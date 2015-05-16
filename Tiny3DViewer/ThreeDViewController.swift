//
//  ViewController.swift
//  Test3DViewer
//
//  Created by セラフ on 2015/03/06.
//  Copyright (c) 2015年 セラフ. All rights reserved.
//

import UIKit

class ThreeDViewController: UIViewController {
    
    var sliderX:UISlider?
    var sliderY:UISlider?
    var modelUrl = ""
    var modelFile = ""
    var modelType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let _view = UIWebView(frame: view.frame)
        
        for _subView in _view.subviews {
            if let _scrollView = _subView as? UIScrollView {
                _scrollView.scrollEnabled = false
                _scrollView.bounces = false
            }
        }
        
        _view.backgroundColor = UIColor.blackColor()
        
        let _frame = view.frame
        //        let _btn = CommonUtil.createButton("EXIT", point:CGPointMake(80,40))
        let _btn = CommonUtil.createButton("EXIT", point:CGPointMake(CGRectGetMaxX(_frame)-20,40))
        _btn.addTarget(self, action: Selector("touchButton:"), forControlEvents: .TouchUpInside)
        view.addSubview(_btn)
        
        if modelUrl.isEmpty {
            modelUrl = modelFile
        } else {
            modelFile = ""
            modelType = "obj"
            if modelUrl.rangeOfString("\\.(?i)dae$", options: .RegularExpressionSearch, range: nil, locale: nil) != nil {
                modelType = "dae"
            }
        }

        if modelUrl.isEmpty {
            return
        }
        
        
        let _path = NSBundle.mainBundle().pathForResource(modelType, ofType: "html")!
        let _url = NSURL(fileURLWithPath: _path)!
        let _data = NSData(contentsOfURL: _url)!
        var _string = NSString(data: _data, encoding: NSUTF8StringEncoding)!
        
        let _w = "\(Int(_view.frame.size.width))"
        let _h = "\(Int(_view.frame.size.height))"
//        let _modelPath = "male02.obj"
        
        _string =
            _string.stringByReplacingOccurrencesOfString("{{width}}", withString: _w)
        _string =
            _string.stringByReplacingOccurrencesOfString("{{height}}", withString: _h)
        _string =
            _string.stringByReplacingOccurrencesOfString("{{modelUrl}}", withString: modelUrl)
        
        _view.loadHTMLString(_string as String, baseURL: NSURL(fileURLWithPath: NSBundle.mainBundle().resourcePath!)!)
        
        
        _view.tag = 1
        
        view.addSubview(_view)
                
        sliderY = UISlider(frame: CGRectMake(0, 0, CGRectGetMaxX(_frame) * 0.8, 20))
        sliderY?.layer.position = CGPointMake(CGRectGetMaxX(_frame) * 0.5, CGRectGetMaxY(_frame) * 0.95)
        sliderY?.minimumValue = -1
        sliderY?.maximumValue = 1
        sliderY?.addTarget(self, action: Selector("changeSlider:"), forControlEvents: .ValueChanged)
        view.addSubview(sliderY!)
        
        sliderX = UISlider(frame: CGRectMake(0, 0, CGRectGetMaxY(_frame) * 0.8, 20))
        sliderX?.layer.position = CGPointMake(CGRectGetMaxX(_frame) * 0.9, CGRectGetMaxY(_frame) * 0.5)
        sliderX?.minimumValue = -1
        sliderX?.maximumValue = 1
        sliderX?.addTarget(self, action: Selector("changeSlider:"), forControlEvents: .ValueChanged)
        sliderX?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 1.5))
        view.addSubview(sliderX!)
        

        // EXITボタンを最前面に移動しておく
        view.bringSubviewToFront(_btn)
        
        let _panGestuer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGestuer:"))
        view.addGestureRecognizer(_panGestuer)
        
        let _pinchGestuer = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchGestuer:"))
        view.addGestureRecognizer(_pinchGestuer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:ユーザイベント
    func touchButton(sender: UIButton){
        if sender.titleLabel?.text == "EXIT" {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func changeSlider(sender: UISlider) {
        if let _view = view.viewWithTag(1) as? UIWebView {
            let _x = sliderX?.value ?? 0
            let _y = sliderY?.value ?? 0
            _view.stringByEvaluatingJavaScriptFromString("setRotation(\(_x),\(_y))")
        }
    }
    
    var lastPoint:CGPoint = CGPointZero
    func handlePanGestuer(sender:UIPanGestureRecognizer) {
        let _point = sender.translationInView(self.view)
        if sender.numberOfTouches() == 1 {
            if sender.state == .Changed {
                if let _view = view.viewWithTag(1) as? UIWebView {
                    let _x = (_point.x + lastPoint.x) * -0.2
                    let _y = (_point.y + lastPoint.y) * -0.2
                    _view.stringByEvaluatingJavaScriptFromString("setXY(\(_x),\(_y))")
                }
            }
        }
        if sender.state == .Ended || sender.state == .Cancelled {
            lastPoint = CGPointMake(_point.x+lastPoint.x, _point.y+lastPoint.y)
        }
        
        //        lastPoint = _point
    }
    
    var finalScale:CGFloat = 1
    func handlePinchGestuer(sender:UIPinchGestureRecognizer) {
        var _scale = sender.scale
        if _scale == 0 {
            return
        }
        if sender.state == .Changed {
            
            _scale *= finalScale
            
            if let _view = view.viewWithTag(1) as? UIWebView {
                _view.stringByEvaluatingJavaScriptFromString("setZoom(\(_scale))")
            }
        }
        if sender.state == .Ended || sender.state == .Cancelled {
            finalScale *= _scale
        }
    }
}


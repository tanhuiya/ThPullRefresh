//
//  ThHeadBounceRefreshView.swift
//  PullRefresh
//
//  Created by tanhui on 16/1/7.
//  Copyright © 2016年 tanhui. All rights reserved.
//

import UIKit

class ThHeadBounceRefreshView: ThHeadRefreshView {
    let l1 = UIView()
    let l2 = UIView()
    let r1 = UIView()
    let r2 = UIView()
    let c = UIView()
    var progress = 0.0
    let KeyPathX = "pathx"
    let KeyPathY = "pathy"
    var focusX : CGFloat?
    var focusY : CGFloat?
    var shapeLayer = CAShapeLayer()
    var circleView = UIView()
    var circleLayer = CAShapeLayer()
    var loadingColor : UIColor? {
        willSet{
            circleLayer.strokeColor = newValue!.CGColor
        }
    }
    var bgColor : UIColor? {
        willSet{
            shapeLayer.fillColor = newValue!.CGColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configeShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK:private Methods
    private func configeCircleLayer(){
        self.circleView.size = CGSizeMake(ThHeadRefreshingCircleRadius * 2.0, ThHeadRefreshingCircleRadius*2.0)
        circleView.center = self.center
        circleView.backgroundColor=UIColor.clearColor()
        
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = self.loadingColor?.CGColor
        circleLayer.lineWidth = 3;
        circleLayer.frame = circleView.bounds
        
        self.circleView.layer.addSublayer(circleLayer)
        self.addSubview(circleView)
    }
    private func configeShapeLayer(){
        shapeLayer.frame = self.bounds
        self.layer.addSublayer(shapeLayer)
    }
    private func updateShapeLayerPath (){
        let bezierPath = UIBezierPath()
        if(self.height<=self.oringalheight){
            let lControlPoint1 = CGPoint(x:0,y:self.oringalheight!)
            let lControlPoint2 = CGPoint(x:0,y:self.oringalheight!)
            
            let rControlPoint1 = CGPoint(x:self.width,y:self.oringalheight!)
            let rControlPoint2 = CGPoint(x:self.width,y:self.oringalheight!)
            
            l1.center = lControlPoint1
            l2.center = lControlPoint2
            r1.center = rControlPoint1
            r2.center = rControlPoint2
            c.center = CGPoint(x:self.width*0.5 , y:self.oringalheight!)
            
            bezierPath .moveToPoint(CGPoint(x: 0, y: 0))
            bezierPath .addLineToPoint(CGPoint(x:self.width, y: 0))
            bezierPath .addLineToPoint(rControlPoint1)
            bezierPath.addLineToPoint(lControlPoint1)
            bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
            bezierPath.closePath()
        }else{
            self.focusY = self.height
            let rate :CGFloat = 0.75
            let marginHeight = ( self.height - self.oringalheight! ) * 0.3 + self.oringalheight!
            let controlHeight = ( self.height - self.oringalheight! ) * 1 + self.oringalheight!
            let leftWidth = self.focusX!
            let rightWidth = self.width - self.focusX!
            
            let lControlPoint1 = CGPoint(x:leftWidth*rate ,y:marginHeight)
            let lControlPoint2 = CGPoint(x:leftWidth * rate,y:controlHeight)
            
            let rControlPoint1 = CGPoint(x:rightWidth*(1-rate)+leftWidth,y:marginHeight)
            let rControlPoint2 = CGPoint(x:rightWidth*(1-rate)+leftWidth,y:controlHeight)
            
            l1.center = lControlPoint1
            l2.center = lControlPoint2
            r1.center = rControlPoint1
            r2.center = rControlPoint2
            c.center = CGPoint(x:leftWidth , y:self.focusY!)
            bezierPath .moveToPoint(CGPoint(x: 0, y: 0))
            bezierPath .addLineToPoint(CGPoint(x:self.width, y: 0))
            bezierPath .addLineToPoint(CGPoint(x: self.width,y: marginHeight))
            
            bezierPath.addCurveToPoint(CGPoint(x: leftWidth+1,y: self.focusY!), controlPoint1: rControlPoint1, controlPoint2: rControlPoint2)
            bezierPath.addLineToPoint(CGPoint(x:leftWidth-1 , y:self.focusY!))
            bezierPath.addCurveToPoint(CGPoint(x: 0,y: marginHeight), controlPoint1: lControlPoint2, controlPoint2: lControlPoint1)
            
            bezierPath.closePath()
        }
        
        shapeLayer.path = bezierPath.CGPath
    }
    func updateCirclePath(){
        circleView.centerY = self.height*0.5
        circleView.centerX = self.centerX
        if self.state == .Pulling||self.state == .Idle{
            let loadingBezier = UIBezierPath()
            let center = CGPointMake(circleView.width*0.5, circleView.height*0.5)
            loadingBezier.addArcWithCenter(center, radius: ThHeadRefreshingCircleRadius , startAngle: CGFloat(-M_PI_2), endAngle:CGFloat((M_PI * 2) * progress - M_PI_2) , clockwise: true)
            circleLayer.path = loadingBezier.CGPath
        }else if(self.state == .Refreshing){
            //刷新的动画
            if(circleLayer.animationForKey("refreshing") != nil){
                return
            }
            let loadingBezier = UIBezierPath()
            let center = CGPointMake(circleView.width*0.5, circleView.height*0.5)
            loadingBezier.addArcWithCenter(center, radius: ThHeadRefreshingCircleRadius , startAngle: CGFloat(-M_PI_2), endAngle:CGFloat((M_PI * 2) * 0.9 - M_PI_2) , clockwise: true)
            circleLayer.path = loadingBezier.CGPath
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.byValue = M_PI_2*3
            animate.repeatCount=999
            animate.duration = 0.5
            animate.fillMode = kCAFillModeForwards
            circleLayer.addAnimation(animate, forKey: "refreshing")
        }
    }
    
    private func removePath(){
        if circleLayer.path != nil{
            circleLayer.removeAnimationForKey("refreshing")
            circleLayer.path = nil
        }
    }
    private func startAnimating(){
        if(self.displayLink == nil){
            displayLink = CADisplayLink(target: self, selector: "updateCirclePath")
            displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
    }
    private func stopAnimating(){
        displayLink?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink?.paused = true
        displayLink = nil
        if circleLayer.path != nil{
            circleLayer.removeAnimationForKey("refreshing")
            circleLayer.path = nil
        }
    }
//MARK:Overrides
    override func setStates(state: ThHeadRefreshState,oldState : ThHeadRefreshState) {
        super.setStates(state, oldState: oldState)
        if state==oldState{
            return
        }
        switch(state){
        case .Refreshing:
            self.startAnimating()
                break;
        case .Idle:
            if oldState == .Refreshing{
                self.stopAnimating()
                self.removePath()
            }
            break
        default:
            break
        }
        
    }
    override func adjustStateWithContentOffset(){
        if self.state == .Refreshing&&self.scrollView?.dragging==true{
            if( self.scrollView?.th_offsetY < 0-(self.scrollView?.th_insetT)! ){
                self.scrollView?.th_offsetY = -(self.scrollView?.th_insetT)!
            }
        }
        progress = Double( (self.height-self.oringalheight!)/self.oringalheight!)
        if(self.scrollView?.dragging == true){
            self.startAnimating()
            if(self.state == .Idle && progress>0.9){
                self.state = .Pulling
            }else if (self.state == .Pulling && progress<=0.9){
                self.state = .Idle
            }
        }else if (self.state == .Pulling){
            self.state = .Refreshing
//            self.stopAnimating()
//            self.startAnimating()
        }else if(self.state == .Idle){
            self.stopAnimating()
            self.removePath()
        }
        
        let offY = 0 - Double((self.scrollView?.th_offsetY)!)
        let culheight = (self.scrollView?.th_insetT)!+self.oringalheight!
        if (offY > Double( culheight )){
            if(self.scrollView?.dragging==true||self.state == .Idle){
                self.height = CGFloat( offY - Double((self.scrollView?.th_insetT)!) )
                let pan = self.scrollView?.panGestureRecognizer
                let point = pan?.locationInView(self)
                self.focusX = point?.x
                if(self.scrollView?.dragging==true){
                    self.startAnimating()
                }
            }
        }else if(self.state == .Refreshing||self.state == .Idle){
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.height = self.oringalheight!;
            })
        }
        
        self.layoutSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShapeLayerPath()
    }
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)

        if (newSuperview != nil){
            //initial circleView after self
            self.configeCircleLayer()
            
            self.focusX = self.width * 0.5
            self.focusY = self.oringalheight
            shapeLayer.frame = self.bounds
            self.addObserver(self, forKeyPath: KeyPathX, options: .New, context: nil)
            self.addObserver(self, forKeyPath: KeyPathY, options: .New, context: nil)
            
            self.l1.size = CGSizeMake(3, 3)
            self.l2.size = CGSizeMake(3, 3)
            self.r1.size = CGSizeMake(3, 3)
            self.r2.size = CGSizeMake(3, 3)
            c.size = CGSizeMake(3, 3)
            
            l1.backgroundColor = UIColor.clearColor()
            l2.backgroundColor = UIColor.clearColor()
            r1.backgroundColor = UIColor.clearColor()
            r2.backgroundColor = UIColor.clearColor()
            c.backgroundColor = UIColor.clearColor()

            self.addSubview(l1)
            self.addSubview(l2)
            self.addSubview(r1)
            self.addSubview(r2)
            self.addSubview(c)

        }
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if (keyPath == KeyPathX || keyPath == KeyPathY){
        }else if keyPath == ThHeadRefreshContentOffset {
            self.adjustStateWithContentOffset()
        }
    }

    deinit{
        self.removeObserver(self, forKeyPath: KeyPathX, context: nil)
        self.removeObserver(self, forKeyPath: KeyPathY, context: nil)
    }
    var displayLink : CADisplayLink?
}

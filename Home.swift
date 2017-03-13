//
//  Home.swift
//  UserLogin
//
//  Created by Mitosis on 09/02/17.
//  Copyright © 2017 Mitosis. All rights reserved.
//

import UIKit

class Home: BaseViewController{
    
   
    @IBOutlet var myView: UIView!
    
    
    @IBOutlet var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSlideMenuButton()
        self.title="Home"
        //Image Loop
        self.pageControl.currentPage = -1
        configurePageControl()
        slide = -1
        self.changeSlide()
        var timer = Timer.scheduledTimer(timeInterval: 10
            , target: self, selector: #selector(changeSlide), userInfo: nil, repeats: true);
        
        
        
        myView.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiped(_gesture:)))
        
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        myView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        myView.addGestureRecognizer(swipeLeft)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    var images = [UIImage(named:"banner2"),UIImage(named:"banner1"),UIImage(named:"banner3"),UIImage(named:"banner4"),UIImage(named:"banner5")]
    
    
    var slide:Int = 0
    
    
    func changeSlide(){
        
        var loop : UIImageView!
        
        loop = UIImageView(frame: myView.bounds)
        loop.contentMode =  UIViewContentMode.scaleToFill
        
        if(slide == images.count-1)
        {
            slide=0
            loop.image = images[slide]
            self.pageControl.currentPage=slide
        }
        else
        {
            slide+=1
            loop.image = images[slide]
            self.pageControl.currentPage=slide
        }
        myView.addSubview(loop)
    }
    
    
    func swiped(_gesture: UIGestureRecognizer) {
        
        var loop : UIImageView!
        loop = UIImageView(frame: myView.bounds)
        loop.contentMode =  UIViewContentMode.scaleToFill
        loop.image = images[slide]
        myView.addSubview(loop)
        
        if let swipeGesture = _gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right :
                
                
                // decrease index first
                
                
                
                
                // check if index is in range
                
                if (slide == 0) {
                    
                    slide = images.count-1
                    loop.image = images[slide]
                    self.pageControl.currentPage = slide
                }
                    
                else
                {
                    
                    slide-=1
                    loop.image = images[slide]
                    self.pageControl.currentPage = slide
                    
                }
                
            case UISwipeGestureRecognizerDirection.left:
                
                
                // increase index first
                
                
                
                // check if index is in range
                
                if (slide == images.count-1) {
                    
                    slide = 0
                    loop.image = images[slide]
                    self.pageControl.currentPage = slide
                }
                else{
                    slide+=1
                    loop.image = images[slide]
                    self.pageControl.currentPage = slide
                }
                
                
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }
    
    func configurePageControl() {
        self.pageControl.numberOfPages = images.count
        self.pageControl.currentPage = slide
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.pageControl.frame = CGRect(x: 0, y: 142, width: self.myView.frame.size.width, height: self.myView.frame.size.height - 30)

        self.view.addSubview(pageControl)
        
    }
    
    
}





//
//  ResponseTimerVC.swift
//  Reflexes
//
//  Created by Henry Goodwin on 30/04/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import UIKit
import iAd

class ClickTimerVC: UIViewController, ADBannerViewDelegate, ADInterstitialAdDelegate{
    
    var interAd = ADInterstitialAd()
    var interAdView: UIView = UIView()
    var closeButton = UIButton(type: UIButtonType.System) as UIButton
    
    var timer:NSTimer = NSTimer()
    var startTime = NSTimeInterval()
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    
    var high: Int! = 6000
    var seconds: Int!
    var fraction: Int!
    
    var strSeconds: String!
    var strFraction: String!
    
    var strSecs: String!
    var strFrac: String!
    
    var score: Int!
    var rep = 0
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet var adBannerView: ADBannerView?
    @IBOutlet weak var highscoreLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rep = 0
        self.canDisplayBannerAds = true
        self.adBannerView?.delegate = self
        self.adBannerView?.hidden = true

        clearBtn.alpha = DIM_ALPHA
        clearBtn.enabled = false
        
        closeButton.frame = CGRectMake(20, 80, 25, 25)
        closeButton.layer.cornerRadius = closeButton.frame.size.width/2
        closeButton.layer.masksToBounds = true
        closeButton.setTitle("x", forState: .Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
        closeButton.layer.borderWidth = 1
        closeButton.addTarget(self, action: #selector(ClickTimerVC.close(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        let fractionDefults = NSUserDefaults.standardUserDefaults()
        let secondDefults = NSUserDefaults.standardUserDefaults()
        let highscoreDefults = NSUserDefaults.standardUserDefaults()
        
        if (fractionDefults.valueForKey("Mil") != nil){
            
            high = highscoreDefults.valueForKey("High") as! Int!
            strSecs = secondDefults.valueForKey("Sec") as! String
            strFrac = fractionDefults.valueForKey("Mil") as! String
    
            highscoreLbl.text = "Highscore: \(strSecs):\(strFrac)"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(sender: UIButton) {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        adBannerView?.hidden = false
        rep = 0
    }
    
    func loadAd() {
        print("load ad")
        interAd = ADInterstitialAd()
        interAd.delegate = self
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        print("ad did load")
        
        interAdView = UIView()
        interAdView.frame = self.view.bounds
        view.addSubview(interAdView)
        
        interAd.presentInView(interAdView)
        UIViewController.prepareInterstitialAds()
        
        interAdView.addSubview(closeButton)
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        print("failed to receive")
        print(error.localizedDescription)
        
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        
    }

    
    @IBAction func startStopTimer(sender: UIButton) {
        
        if (!timer.valid) {
            
            startStopBtn.setTitle("Stop", forState: UIControlState.Normal)
            
            let aSelector : Selector = #selector(ClickTimerVC.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
            clearBtn.enabled = false
            clearBtn.alpha = DIM_ALPHA
            
        } else if (timer.valid) {
            
            invalidate()
//            print(score)
            
        }
    }
    
    func invalidate() {
        
        startStopBtn.setTitle("Start", forState: UIControlState.Normal)
        timer.invalidate()
        
        startStopBtn.enabled = false
        clearBtn.enabled = true
        
        clearBtn.alpha = OPAQUE
        startStopBtn.alpha = DIM_ALPHA
        
        if (score < high) {
            
            high = score
            strSecs = strSeconds
            strFrac = strFraction
            
            highscoreLbl.text = "Highscore: \(strSecs):\(strFrac)"
            
            let secondsDefults = NSUserDefaults.standardUserDefaults()
            secondsDefults.setValue(strSecs, forKey: "Sec")
            secondsDefults.synchronize()
            
            let highscoreDefults = NSUserDefaults.standardUserDefaults()
            highscoreDefults.setValue(high, forKey: "High")
            highscoreDefults.synchronize()
            
            let minutesDefults = NSUserDefaults.standardUserDefaults()
            minutesDefults.setValue(strFrac, forKey: "Mil")
            minutesDefults.synchronize()
        }

    }
    
    @IBAction func clear(sender: UIButton) {
        
        if rep != 5 {
        rep = rep + 1
        }
        
        label.text = "00:00"
        startStopBtn.enabled = true
        startStopBtn.alpha = OPAQUE
        
        clearBtn.enabled = false
        clearBtn.alpha = DIM_ALPHA
        print(rep)
        if rep == 5 {
        adBannerView?.hidden = true
        loadAd()
        rep = 0
        }
        
        
        
    }
    
    @IBAction func alertBtn(sender: UIButton) {
        
        let alertView = UIAlertController(title: "Click Timer", message: "Press Stop as Quickly as You Can", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
        
    }

    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        
        //calculate the seconds in elapsed time.
        seconds = Int(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        fraction = Int(elapsedTime * 10000)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        
        strSeconds = String(format: "%02d", seconds)
        strFraction = String(format: "%04d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        label.text = "\(strSeconds):\(strFraction)"
        
        score = ((seconds * 10000) + Int(fraction))
        
        if label.text == "59:59" {
            
            invalidate()
            
        }
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewWillLoadAd")
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
        self.adBannerView?.hidden = false //now show banner as ad is loaded
    }
    
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
        
    }
    
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        NSLog("bannerViewActionShouldBegin")
        
        return true
    }
    
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("bannerView")
    }
}

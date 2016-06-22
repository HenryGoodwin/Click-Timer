//
//  ResponseTimerVC.swift
//  Reflexes
//
//  Created by Henry Goodwin on 30/04/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ClickTimerVC: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
    
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
    @IBOutlet weak var highscoreLbl: UILabel!
    
    @IBOutlet var banner: GADBannerView!
    var inter: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rep = 0

        clearBtn.alpha = DIM_ALPHA
        clearBtn.enabled = false
    
        let fractionDefults = NSUserDefaults.standardUserDefaults()
        let secondDefults = NSUserDefaults.standardUserDefaults()
        let highscoreDefults = NSUserDefaults.standardUserDefaults()
        
        if (fractionDefults.valueForKey("Mil") != nil){
            
            high = highscoreDefults.valueForKey("High") as! Int!
            strSecs = secondDefults.valueForKey("Sec") as! String
            strFrac = fractionDefults.valueForKey("Mil") as! String
    
            highscoreLbl.text = "Highscore: \(strSecs):\(strFrac)"
        }
        
        banner.hidden = true
        
        banner.delegate = self
        
        banner.adUnitID = "ca-app-pub-7304033372417454/9689620645"
        banner.rootViewController = self
        banner.loadRequest(GADRequest())
        
        createAndLoad()
        inter = createAndLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        banner.hidden = false
    }
    
    func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        banner.hidden = true
    }
    
    func createAndLoad() -> GADInterstitial {
        let request = GADRequest()
        let interstit = GADInterstitial(adUnitID: "ca-app-pub-6065612350257414/1167327080")
        interstit.delegate = self
        interstit.loadRequest(request)
        return interstit
        
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        inter = createAndLoad()
        rep = 0
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
        
        if rep == 5{
            
            if inter.isReady {
                
                inter?.presentFromRootViewController(self)
                    
                }
            
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
        
        if score > 590000
        {
            
            invalidate()
            
        }
    }
    }

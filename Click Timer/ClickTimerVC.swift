//
//  ResponseTimerVC.swift
//  Reflexes
//
//  Created by Henry Goodwin on 30/04/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class ClickTimerVC: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, GKGameCenterControllerDelegate{
    
    var timer:Timer = Timer()
    var startTime = TimeInterval()
    
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
        clearBtn.isEnabled = false
    
        let fractionDefults = UserDefaults.standard
        let secondDefults = UserDefaults.standard
        let highscoreDefults = UserDefaults.standard
        
        if (fractionDefults.value(forKey: "Mil") != nil){
            
            high = highscoreDefults.value(forKey: "High") as! Int!
            strSecs = secondDefults.value(forKey: "Sec") as! String
            strFrac = fractionDefults.value(forKey: "Mil") as! String
    
            highscoreLbl.text = "Highscore: \(strSecs):\(strFrac)"
        }
        
        banner.isHidden = true
        
        banner.delegate = self
        
        banner.adUnitID = "ca-app-pub-7304033372417454/9689620645"
        banner.rootViewController = self
        banner.load(GADRequest())
        
        createAndLoad()
        inter = createAndLoad()
        
        authPlayer()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        banner.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        banner.isHidden = true
    }
    
    func createAndLoad() -> GADInterstitial {
        let request = GADRequest()
        let interstit = GADInterstitial(adUnitID: "ca-app-pub-6065612350257414/1167327080")
        interstit.delegate = self
        interstit.load(request)
        return interstit
        
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        inter = createAndLoad()
        rep = 0
    }
    
    @IBAction func startStopTimer(_ sender: UIButton) {
        
        if (!timer.isValid) {
            
            startStopBtn.setTitle("Stop", for: UIControlState())
            
            let aSelector : Selector = #selector(ClickTimerVC.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
            
            clearBtn.isEnabled = false
            clearBtn.alpha = DIM_ALPHA
            
        } else if (timer.isValid) {
            
            invalidate()
//            print(score)
            
        }
    }
    
    func invalidate() {
        
        startStopBtn.setTitle("Start", for: UIControlState())
        timer.invalidate()
        
        startStopBtn.isEnabled = false
        clearBtn.isEnabled = true
        
        clearBtn.alpha = OPAQUE
        startStopBtn.alpha = DIM_ALPHA
        
        saveHighscore(score)
        
        if (score < high) {
            
            high = score
            strSecs = strSeconds
            strFrac = strFraction
            
            highscoreLbl.text = "Highscore: \(strSecs):\(strFrac)"
            
            let secondsDefults = UserDefaults.standard
            secondsDefults.setValue(strSecs, forKey: "Sec")
            secondsDefults.synchronize()
            
            let highscoreDefults = UserDefaults.standard
            highscoreDefults.setValue(high, forKey: "High")
            highscoreDefults.synchronize()
            
            let minutesDefults = UserDefaults.standard
            minutesDefults.setValue(strFrac, forKey: "Mil")
            minutesDefults.synchronize()
        }

    }
    
    @IBAction func clear(_ sender: UIButton) {
        
        if rep != 5 {
        rep = rep + 1
        }
        
        label.text = "00:00"
        startStopBtn.isEnabled = true
        startStopBtn.alpha = OPAQUE
        
        clearBtn.isEnabled = false
        clearBtn.alpha = DIM_ALPHA
        print(rep)
        
        if rep == 5{
            
            if inter.isReady {
                
                inter?.present(fromRootViewController: self)
                    
                }
            
            }
        }
        
    
    
    @IBAction func callGc(_ sender: UIButton) {
        
        showLeaderBoard()
        
    }
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                
                self.present(view!, animated: true, completion: nil)
                
            }
            else {
                
                print(GKLocalPlayer.localPlayer().isAuthenticated)
                
            }
            
            
        }
    }
    
    func saveHighscore(_ number : Int){
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "Leaderboard")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
            
        }
        
        
    }
    
    func showLeaderBoard(){
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        
        //calculate the seconds in elapsed time.
        seconds = Int(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
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

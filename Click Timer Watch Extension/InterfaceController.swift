//
//  InterfaceController.swift
//  Click Timer Watch Extension
//
//  Created by Henry Goodwin on 10/06/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var timer:NSTimer = NSTimer()
    var startTime = NSTimeInterval()
    
    let DIM_ALPHA: CGFloat = 0.4
    let OPAQUE: CGFloat = 1.0
    
    var high: Int! = 6000
    var seconds: Int!
    var fraction: Int!
    
    var strSeconds: String!
    var strFraction: String!
    
    var strSecs: String!
    var strFrac: String!
    
    var score: Int!

    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var highs: WKInterfaceLabel!
    @IBOutlet var start: WKInterfaceButton!
    @IBOutlet var reset: WKInterfaceButton!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        reset.setAlpha(DIM_ALPHA)
        reset.setEnabled(false)
        
        let fractionDefults = NSUserDefaults.standardUserDefaults()
        let secondDefults = NSUserDefaults.standardUserDefaults()
        let highscoreDefults = NSUserDefaults.standardUserDefaults()
        
        if (fractionDefults.valueForKey("Mil") != nil){
            
            high = highscoreDefults.valueForKey("High") as! Int!
            strSecs = secondDefults.valueForKey("Sec") as! String
            strFrac = fractionDefults.valueForKey("Mil") as! String
            
            highs.setText("High: \(strSecs):\(strFrac)")
        }

        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func startStop() {
        
        if (!timer.valid) {
            

            
            start.setTitle("Stop")
            
            let aSelector : Selector = #selector(InterfaceController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
            reset.setEnabled(false)
            reset.setAlpha(DIM_ALPHA)
            
        } else if (timer.valid) {
            
            invalidate()
            //            print(score)
            
        }

    }
    
    func invalidate() {
        
        start.setTitle("Start")
        timer.invalidate()
        
        start.setEnabled(false)
        reset.setEnabled(true)
        
        reset.setAlpha(OPAQUE)
        start.setAlpha(DIM_ALPHA)
        
        if (score < high) {
            
            high = score
            strSecs = strSeconds
            strFrac = strFraction
            
            highs.setText("High: \(strSecs):\(strFrac)")
            
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

    
    @IBAction func resetBtn() {
        
        label.setText("00:00")
        start.setEnabled(true)
        start.setAlpha(OPAQUE)

        reset.setEnabled(false)
        reset.setAlpha(DIM_ALPHA)
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
        
        label.setText("\(strSeconds):\(strFraction)")
        
        score = ((seconds * 10000) + Int(fraction))
        
        if score > 590000
        {
            
            invalidate()
            
        }
    }

    
    

}

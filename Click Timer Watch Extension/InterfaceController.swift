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
    
    var timer:Timer = Timer()
    var startTime = TimeInterval()
    
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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        reset.setAlpha(DIM_ALPHA)
        reset.setEnabled(false)
        
        let fractionDefults = UserDefaults.standard
        let secondDefults = UserDefaults.standard
        let highscoreDefults = UserDefaults.standard
        
        if (fractionDefults.value(forKey: "Mil") != nil){
            
            high = highscoreDefults.value(forKey: "High") as! Int!
            strSecs = secondDefults.value(forKey: "Sec") as! String
            strFrac = fractionDefults.value(forKey: "Mil") as! String
            
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
        
        if (!timer.isValid) {
            

            
            start.setTitle("Stop")
            
            let aSelector : Selector = #selector(InterfaceController.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
            
            reset.setEnabled(false)
            reset.setAlpha(DIM_ALPHA)
            
        } else if (timer.isValid) {
            
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

    
    @IBAction func resetBtn() {
        
        label.setText("00:00")
        start.setEnabled(true)
        start.setAlpha(OPAQUE)

        reset.setEnabled(false)
        reset.setAlpha(DIM_ALPHA)
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
        
        label.setText("\(strSeconds):\(strFraction)")
        
        score = ((seconds * 10000) + Int(fraction))
        
        if score > 590000
        {
            
            invalidate()
            
        }
    }

    
    

}

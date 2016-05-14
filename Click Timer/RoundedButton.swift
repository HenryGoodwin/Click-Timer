//
//  RoundedButton.swift
//  Reflexes
//
//  Created by Henry Goodwin on 30/04/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
    }
}

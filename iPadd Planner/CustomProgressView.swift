//
//  CustomProgressView.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 20/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit

class CustomProgressView: UIView {
    
    private var _innerProgress: CGFloat = 0.0
   
    var progress: CGFloat {
        set (newProgress) {
            if newProgress > 1.0 {
                _innerProgress = 1.0
            } else if newProgress < 0.0{
                _innerProgress = 0.0
            } else {
                _innerProgress = newProgress
            }
            setNeedsDisplay()
        }
        get {
            return _innerProgress * bounds.width
        }
    }
    
    override func draw(_ rect: CGRect) {
        ProgressBarDraw.drawProgressBar(frame: bounds, progress: progress)
    }
}

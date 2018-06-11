//
//  ProgressBarDraw.swift
//  iPadd Planner
//
//  Created by Md Kamrul Amin on 20/05/2018.
//  Copyright © 2018 Md Kamrul Amin. All rights reserved.
//

import UIKit

class ProgressBarDraw: NSObject {
    
    class func drawProgressBar(frame: CGRect = CGRect(x: 0, y: 0, width: 300, height: 16), progress: CGFloat = 183){
        //colour declarations
        let colour = UIColor(red: 0.847, green: 0.278, blue: 0.118, alpha: 1.000)
        
        // progress border
        let progressBorder = UIBezierPath(roundedRect: CGRect(x: frame.minX + 1, y: frame.minY + 1, width: floor((frame.width - 1) * 0.99666 + 0.5), height: 14), cornerRadius: 7)
        colour.setStroke()
        progressBorder.lineWidth = 1
        progressBorder.stroke()
        
        //progress active drawing
        let progressPath = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: progress, height: 14), cornerRadius: 7)
        colour.setFill()
        progressPath.fill()
    }
        
}

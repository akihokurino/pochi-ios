//
//  File.swift
//  pochi
//
//  Created by Akiho on 2016/12/15.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit

extension UIColor {
    private class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    class func activeColor() -> UIColor {
        return self.rgb(r: 255, g: 121, b: 122, alpha: 1.0)
    }
    
    class func modalBackgroundColor() -> UIColor {
        return self.rgb(r: 0, g: 0, b: 0, alpha: 0.5)
    }
    
    class func inActiveColor() -> UIColor {
        return self.rgb(r: 221, g: 221, b: 221, alpha: 1.0)
    }
    
    class func inputBorderBottomColor() -> UIColor {
        return UIColor.rgb(r: 216, g: 216, b: 216, alpha: 1.0)
    }
    
    class func linkTextColor() -> UIColor {
        return self.rgb(r: 170, g: 170, b: 170, alpha: 1.0)
    }
    
    class func backgroundColor() -> UIColor {
        return self.rgb(r: 249, g: 249, b: 249, alpha: 1.0)
    }
    
    class func cellTitleColor() -> UIColor {
        return self.rgb(r: 68, g: 68, b: 68, alpha: 1.0)
    }
    
    class func sectionTitleColor() -> UIColor {
        return self.rgb(r: 119, g: 119, b: 119, alpha: 1.0)
    }
    
    class func reserveDefiniteColor() -> UIColor {
        return self.rgb(r: 252, g: 196, b: 78, alpha: 1.0)
    }
    
    class func cancelGrayColor() -> UIColor {
        return self.rgb(r: 204, g: 204, b: 204, alpha: 1.0)
    }
    
    class func searchHeaderLeftColor() -> UIColor {
        return self.rgb(r: 255, g: 239, b: 211, alpha: 1.0)
    }
    
    class func searchHeaderRightColor() -> UIColor {
        return self.rgb(r: 253, g: 172, b: 147, alpha: 1.0)
    }
    
    class func mainTextColor() -> UIColor {
        return self.rgb(r: 85, g: 85, b: 85, alpha: 1.0)
    }
    
    class func dateDefaultColor() -> UIColor {
        return self.rgb(r: 102, g: 102, b: 102, alpha: 1.0)
    }
    
    class func labelColor() -> UIColor {
        return self.rgb(r: 136, g: 136, b: 136, alpha: 1.0)
    }
}
    

//
//  RoundButton.swift
//  devslopessocial
//
//  Created by Mago Nicolas Palacios on 8/10/16.
//  Copyright © 2016 Mago Nicolas Palacios. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: shadow_gray, green: shadow_gray, blue: shadow_gray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }

}

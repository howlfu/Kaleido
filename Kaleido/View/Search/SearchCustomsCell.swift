//
//  SearchCustomCell.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/17.
//

import Foundation
import UIKit

class SearchCustomsCell: UITableViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.contentView.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().titleRed)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.contentView.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().mainTint)
    }
}

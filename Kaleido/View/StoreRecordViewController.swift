//
//  StoreRecordViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/9.
//

import Foundation
import UIKit
class StoreRecordViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var dateBackground: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var storeMoney: UITextField!
    
    @IBOutlet weak var payMethod: UITextField!
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        nameText.layer.cornerRadius = textFieldCornerRadius
        dateBackground.layer.cornerRadius = textFieldCornerRadius
        priceText.layer.cornerRadius = BigBtnCornerRadius
        storeMoney.layer.cornerRadius = BigBtnCornerRadius
        payMethod.layer.cornerRadius = BigBtnCornerRadius
        
    }
}

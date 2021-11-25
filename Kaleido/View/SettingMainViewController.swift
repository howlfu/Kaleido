//
//  SettingMainViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/25.
//

import UIKit

class SettingMainViewController: BaseViewController {
    @IBOutlet weak var lashBtn: UIButton!
    
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    @IBOutlet weak var inportBtn: UIButton!
    
    @IBOutlet weak var titleView: UIView!
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        lashBtn.layer.cornerRadius = BigBtnCornerRadius
        otherBtn.layer.cornerRadius = BigBtnCornerRadius
        exportBtn.layer.cornerRadius = BigBtnCornerRadius
        inportBtn.layer.cornerRadius = BigBtnCornerRadius
    }
}

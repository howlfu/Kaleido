//
//  MainViewController.swift
//  Kaleido
//
//  Created by Civet on 2021/10/25.
//

import UIKit
import Foundation

class MainViewController: BaseViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBAction func recordAction(_ sender: Any) {
        
    }
    
    @IBAction func showAction(_ sender: Any) {
    }
    
    @IBAction func storeAction(_ sender: Any) {
    }
    
    
    @IBAction func settingAction(_ sender: Any) {
    }
    
    override func initView() {
        super.initView()
        recordButton.layer.cornerRadius = BigBtnCornerRadius
        showButton.layer.cornerRadius = BigBtnCornerRadius
        storeButton.layer.cornerRadius = BigBtnCornerRadius
        settingButton.layer.cornerRadius = BigBtnCornerRadius
    }


}

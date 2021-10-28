//
//  MainViewController.swift
//  Kaleido
//
//  Created by Civet on 2021/10/25.
//

import UIKit
import Foundation

class MainViewController: UIViewController {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.layer.cornerRadius = 20
        showButton.layer.cornerRadius = 20
        storeButton.layer.cornerRadius = 20
        settingButton.layer.cornerRadius = 20
    }


}

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
    @IBAction func recordAction(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        recordButton.contentVerticalAlignment = .fill
//        recordButton.contentHorizontalAlignment = .fill
//        recordButton.centerTextAndImage(spacing: 8)
//        recordButton.imageEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        recordButton.layer.cornerRadius = 20
    }


}

//
//  recordMainViewController.swift
//  Kaleido
//
//  Created by Civet on 2021/10/28.
//

import UIKit

class RecordMainViewController: BaseViewController{
    @IBOutlet weak var slashBtn: UIButton!
    @IBOutlet weak var keratinBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: 100)
        slashBtn.layer.cornerRadius = 20
        keratinBtn.layer.cornerRadius = 20
    }
}

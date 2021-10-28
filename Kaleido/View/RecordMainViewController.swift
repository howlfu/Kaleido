//
//  recordMainViewController.swift
//  Kaleido
//
//  Created by Civet on 2021/10/28.
//

import UIKit

class RecordMainViewController: BaseViewController{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    override func initView() {
        super.initView()
        self.titleId = "紀錄"
        titleView.roundedBottRight(radius: 100)
        titleLabel.text = self.titleId
    }
}

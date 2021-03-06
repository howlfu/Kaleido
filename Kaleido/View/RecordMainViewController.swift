//
//  recordMainViewController.swift
//  Kaleido
//
//  Created by Civet on 2021/10/28.
//

import UIKit

class RecordMainViewController: BaseViewController{
    @IBOutlet weak var lashBtn: UIButton!
    @IBOutlet weak var keratinBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBAction func keratinAct(_ sender: Any) {
        performSegue(withIdentifier: "toSearchCusView", sender: self)
    }
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        lashBtn.layer.cornerRadius = BigBtnCornerRadius
        keratinBtn.layer.cornerRadius = BigBtnCornerRadius
    }
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
    }
}

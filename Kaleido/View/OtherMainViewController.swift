//
//  OtherMainViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/25.
//

import UIKit
class OtherMainViewController: BaseViewController {
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var lashDoerBtn: UIButton!
    @IBOutlet weak var lashBackground: UIView!
    @IBOutlet weak var payMethodBtn: UIButton!
    @IBOutlet weak var payMethodBackground: UIView!
    @IBOutlet weak var discountBtn: UIButton!
    @IBOutlet weak var discountBackground: UIView!
    @IBOutlet weak var storedBtn: UIButton!
    @IBOutlet weak var storedBackground: UIView!
    @IBOutlet weak var orderListBtn: UIButton!
    @IBOutlet weak var orderListBackground: UIView!
    var nextViewBtnDest: OrderRecordView?
    @IBAction func orderRecordBtnAct(_ sender: Any) {
        nextViewBtnDest = .order
        performSegue(withIdentifier: "toOderRecordView", sender: self)
    }
    @IBAction func storeListBtnAct(_ sender: Any) {
        nextViewBtnDest = .store
        performSegue(withIdentifier: "toOderRecordView", sender: self)
    }
    override func initView() {
        titleView.roundedBottRight(radius: titleViewRadius)
        lashDoerBtn.layer.cornerRadius = BigBtnCornerRadius
        lashDoerBtn.layer.borderColor = UIColor.black.cgColor
        lashDoerBtn.layer.borderWidth = 1
        lashBackground.layer.cornerRadius = BigBtnCornerRadius
        payMethodBtn.layer.cornerRadius = BigBtnCornerRadius
        payMethodBtn.layer.borderColor = UIColor.black.cgColor
        payMethodBtn.layer.borderWidth = 1
        payMethodBackground.layer.cornerRadius = BigBtnCornerRadius
        discountBtn.layer.cornerRadius = BigBtnCornerRadius
        discountBtn.layer.borderColor = UIColor.black.cgColor
        discountBtn.layer.borderWidth = 1
        discountBackground.layer.cornerRadius = BigBtnCornerRadius
        storedBtn.layer.cornerRadius = BigBtnCornerRadius
        storedBtn.layer.borderColor = UIColor.black.cgColor
        storedBtn.layer.borderWidth = 1
        storedBackground.layer.cornerRadius = BigBtnCornerRadius
        orderListBtn.layer.cornerRadius = BigBtnCornerRadius
        orderListBtn.layer.borderColor = UIColor.black.cgColor
        orderListBtn.layer.borderWidth = 1
        orderListBackground.layer.cornerRadius = BigBtnCornerRadius
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OrderRecordViewController {
            let lashRecordVC = segue.destination as! OrderRecordViewController
            guard let dest = self.nextViewBtnDest else {
                return
            }
            lashRecordVC.setNextDest(viewType: dest)
        }
    }
}

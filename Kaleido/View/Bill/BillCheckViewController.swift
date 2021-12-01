//
//  BillCheckViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
import UIKit
class BillCheckViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var remainText: UITextField!
    @IBOutlet weak var savedText: UITextField!
    @IBOutlet weak var totalRemainText: UITextField!
    @IBOutlet weak var payMethodTableView: UITableView!
    @IBOutlet weak var signViewLabel: UILabel!
    @IBOutlet weak var signView: UIView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBAction func checkBtnAct(_ sender: Any) {
    }
    var controller: BillCheckController = BillCheckController()
    var viewModel: BillCheckModel {
        return controller.viewModel
    }
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        priceText.layer.cornerRadius = textFieldCornerRadius
        remainText.layer.cornerRadius = textFieldCornerRadius
        savedText.layer.cornerRadius = textFieldCornerRadius
        totalRemainText.layer.cornerRadius = textFieldCornerRadius
        checkBtn.layer.cornerRadius = BigBtnCornerRadius
    }
    
    public func setOrderData(detail: OrderEntityType) {
        controller.setOrderDetail(detail: detail)
    }
    
}

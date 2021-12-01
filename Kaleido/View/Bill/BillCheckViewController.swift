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
        guard
            let add: Int16 = Int16(self.savedText.text!),
            let price: Int16 = Int16(self.priceText.text!),
            let remain: Int16 = Int16(self.remainText.text!) else {
                return
            }
        var priceRatio = 1.0
        if let selectedPayMethod = self.lastSelectionInex {
            let selectedIndex = payMethodArr.index(payMethodArr.startIndex, offsetBy: selectedPayMethod.row)
            priceRatio = payMethodArr.values[selectedIndex]
        }
        let remainMoney = controller.getCalcResult(price: self.savedText.text!, remain: self.remainText.text!, add: self.savedText.text!, ratio: priceRatio)
        
    }
    var controller: BillCheckController = BillCheckController()
    var viewModel: BillCheckModel {
        return controller.viewModel
    }
    let aCellHightOfViewRadio = 2
    lazy var payMethodArr: [String: Double] = self.controller.getPayMethod()
    var lastSelectionInex: IndexPath?
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        priceText.layer.cornerRadius = textFieldCornerRadius
        remainText.layer.cornerRadius = textFieldCornerRadius
        savedText.layer.cornerRadius = textFieldCornerRadius
        totalRemainText.layer.cornerRadius = textFieldCornerRadius
        checkBtn.layer.cornerRadius = BigBtnCornerRadius
        
        guard let orderTmp = self.viewModel.orderOfCustomer,
              let customerDetail = self.controller.getCustomer(id: orderTmp.user_id)
        else {return}
        let customerMoney = customerDetail.remain_money
        remainText.text = String(customerMoney)
    }
    
    public func setOrderData(detail: OrderEntityType) {
        controller.setOrderDetail(detail: detail)
    }
    
}

extension BillCheckViewController: UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.payMethodTableView.delegate = self
        self.payMethodTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payMethodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payMethodCell", for: indexPath)
        let statusIcon : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let lblTitle : UILabel = cell.contentView.viewWithTag(2) as! UILabel
        let statusBG : UIImageView = cell.contentView.viewWithTag(3) as! UIImageView
        let backgroundView : UIView = cell.contentView.viewWithTag(4)!
        statusIcon.frame.origin.y = (backgroundView.frame.height - statusIcon.frame.size.height) / 2
        statusBG.frame.origin.y = (backgroundView.frame.height - statusBG.frame.size.height) / 2
        lblTitle.frame.origin.y = (backgroundView.frame.height - lblTitle.frame.size.height) / 2
        let textIndex = self.payMethodArr.index(self.payMethodArr.startIndex, offsetBy: indexPath.row)
        lblTitle.text = self.payMethodArr.keys[textIndex]
        cell.contentView.frame.size.width = (cell.contentView.frame.size.width * 2) / 3
        cell.contentView.frame.size.height = (cell.contentView.frame.size.height * 2) / 3
        backgroundView.layer.cornerRadius = BigBtnCornerRadius
        backgroundView.sendSubviewToBack(cell)
        return cell
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return payMethodTableView.frame.height / CGFloat(aCellHightOfViewRadio)
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        cellSelected(cell: selectedCell, currentIndex: indexPath)
    }
    
    func cellSelected(cell: UITableViewCell?, currentIndex: IndexPath) {
        guard let selectedCell = cell else {
            return
        }
        let statusIcon : UIImageView = selectedCell.contentView.viewWithTag(1) as! UIImageView
        guard let lastInex = lastSelectionInex else {
            lastSelectionInex = currentIndex
            statusIcon.image = UIImage(named: "Checked")
            return
        }
        
        if lastInex == currentIndex {
            // clear the same selected
            statusIcon.image =  nil
            lastSelectionInex = nil
        } else {
            statusIcon.image = UIImage(named: "Checked")
            // clear selected before
            guard let lastCell = self.payMethodTableView.cellForRow(at: lastInex) else {
                return
            }
            let lastStatusIcon : UIImageView = lastCell.contentView.viewWithTag(1) as! UIImageView
            lastStatusIcon.image = nil
            lastSelectionInex = currentIndex
        }
       
    }
}

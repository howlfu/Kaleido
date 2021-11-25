//
//  OrderRecordViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/25.
//

import Foundation
import UIKit
class OrderRecordViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateBackground: UIView!
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var addNewBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func searchAct(_ sender: Any) {
    }
    
    @IBAction func addNewAct(_ sender: Any) {
    }
    
    @IBAction func deleteAct(_ sender: Any) {
    }
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        nameText.layer.cornerRadius = textFieldCornerRadius
        dateBackground.layer.cornerRadius = textFieldCornerRadius
        numberText.layer.cornerRadius = textFieldCornerRadius
        searchBtn.layer.cornerRadius = BigBtnCornerRadius
        addNewBtn.layer.cornerRadius = BigBtnCornerRadius
        deleteBtn.layer.cornerRadius = BigBtnCornerRadius
    }
    
    override func initBinding() {
        super.initBinding()
    }
}

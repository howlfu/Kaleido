//
//  DiscountRuleViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/15.
//

import UIKit
class BindingViewController: BaseViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var keyTitle: UILabel!
    @IBOutlet weak var valueTitle: UILabel!
    @IBOutlet weak var keyData: UITextField!
    @IBOutlet weak var valueData: UITextField!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var bindingListTableView: UITableView!
    @IBAction func textPrimaryKeyTrigger(_ sender: Any) {
            view.endEditing(true)
    }
    var controller: BindingController = BindingController()
    var viewModel: BindingViewModel {
        return controller.viewModel
    }
    override func initBinding() {
        super.initBinding()
        bindingListTableView.delegate = self
        
        viewModel.tableViewDiscountData.addObserver(fireNow: false) {[weak self] (newTableData) in
            DispatchQueue.main.async {
                self?.bindingListTableView.reloadData()
            }
        }
        
        viewModel.tableViewPayMethodData.addObserver(fireNow: false) {[weak self] (newTableData) in
            DispatchQueue.main.async {
                self?.bindingListTableView.reloadData()
            }
        }
        if let showType: otherViewBtnDestType = self.viewModel.segueFromOtherViewType {
            switch showType {
            case .discount:
                initDiscountView()
            case .payMethod:
                initPayMethodView()
            default:
                return
            }
        }
        let tapAdd = UITapGestureRecognizer(target: self, action: #selector(handleTapAdd))
        tapAdd.numberOfTapsRequired = 1
        addIcon.addGestureRecognizer(tapAdd)
    }
    
    @objc func handleTapAdd(_ gesture:UITapGestureRecognizer){
        let keyVal = self.keyData.text!
        let valVal = self.valueData.text!
        if let showType: otherViewBtnDestType = self.viewModel.segueFromOtherViewType {
            switch showType {
            case .discount:
                guard let total = Int16(keyVal), let add = Int16(valVal) else {
                    return
                }
                controller.addDiscountRule(name: String(keyVal), total: total, addData: add)
                self.controller.initDiscountTableList()
            case .payMethod:
                guard keyVal != "",
                      valVal != "" else{
                          return
                      }
                guard let percentage = Double(valVal) else {
                    return
                }
                controller.addPayMethod(name: keyVal, percentage: percentage)
                self.controller.initPayMethodTableList()
            default:
                print("")
            }
        }
    }
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        keyData.layer.cornerRadius = textFieldCornerRadius
        valueData.layer.cornerRadius = textFieldCornerRadius
    }
    
    func initDiscountView(){
        titleLabel.text = "折扣綁定"
        keyTitle.text = "金額"
        valueTitle.text = "滿送"
        self.controller.initDiscountTableList()
    }
    
    func initPayMethodView(){
        titleLabel.text = "支付綁定"
        keyTitle.text = "名稱"
        valueTitle.text = "手續費"
        self.controller.initPayMethodTableList()
    }
    
    public func setObjectType(typeData: otherViewBtnDestType) {
        self.viewModel.segueFromOtherViewType = typeData
    }
}

extension BindingViewController:  UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindingListTableView.delegate = self
        self.bindingListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let showType: otherViewBtnDestType = self.viewModel.segueFromOtherViewType {
        switch showType {
        case .discount:
            return self.viewModel.tableViewDiscountData.value.count
        case .payMethod:
            return self.viewModel.tableViewPayMethodData.value.count
        default:
            return 0
            }
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 5
        let cellHight = bindingListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bindingListCell", for: indexPath)
        let index = indexPath.row
        let ketText : UILabel = cell.contentView.viewWithTag(1) as! UILabel
        let valueText : UILabel = cell.contentView.viewWithTag(2) as! UILabel
        let delIcon : UIImageView = cell.contentView.viewWithTag(3) as! UIImageView
        if let showType: otherViewBtnDestType = self.viewModel.segueFromOtherViewType {
            switch showType {
            case .discount:
                let foundList = viewModel.tableViewDiscountData.value
                let keyName = foundList.map{$0.key}[index]
                ketText.text = String(keyName)
                if let valueData = foundList[keyName] {
                    valueText.text = String(valueData)
                }
            case .payMethod:
                let foundList = viewModel.tableViewPayMethodData.value
                let keyName = foundList.map{$0.key}[index]
                ketText.text = keyName
                if let valueData = foundList[keyName] {
                    valueText.text = String(valueData)
                }
            default:
                return cell
            }
        }
        let tapDel = UITapGestureRecognizer(target: self, action: #selector(handleTapDel))
        tapDel.numberOfTapsRequired = 1
        tapDel.cancelsTouchesInView = false
        delIcon.addGestureRecognizer(tapDel)
        return cell
    }
    
    @objc func handleTapDel(_ gesture:UITapGestureRecognizer){
        if let showType: otherViewBtnDestType = self.viewModel.segueFromOtherViewType {
            switch showType {
            case .discount:
                let foundList = viewModel.tableViewDiscountData.value
                guard let indexPath = bindingListTableView.indexPathForRow(at: gesture.location(in: self.bindingListTableView)) else {
                    print("Error: indexPath)")
                    return
                }
                let keyName = foundList.map{$0.key}[indexPath.row]
                if let valueData = foundList[keyName] {
                    controller.deleteDiscountRule(total: keyName, add: valueData)
                } else {
                    controller.deleteDiscountRule(total: keyName, add: 0)
                }
                self.controller.initDiscountTableList()
                
            case .payMethod:
                let foundList = viewModel.tableViewPayMethodData.value
                guard let index = self.bindingListTableView.indexPathForSelectedRow else {
                    return
                }
                let keyName = foundList.map{$0.key}[index.row]
                controller.deletePayMethod(keyVal: keyName)
                self.controller.initPayMethodTableList()
            default:
                return
            }
        }
    }
}

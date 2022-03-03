//
//  SearchCustomsViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/1.
//

import UIKit

class SearchCustomsViewController: BaseViewController{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleView: UIView!
    //props
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var addNewBtn: UIButton!
    
    @IBOutlet weak var birthBackground: UIView!
    @IBOutlet weak var customsListTableView: UITableView!
    var viewModel: SearchCustomsViewModel = SearchCustomsViewModel()
    var selectedLashService: [LashListType]?
    var didSelectTimePicker: Bool = false
    var selectedCustomerId: Int32?
    
    @IBAction func textPrimaryKeyTrigger(_ sender: Any) {
            view.endEditing(true)
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        if Calendar.current.isDateInToday(sender.date) {
            self.didSelectTimePicker = false
        } else {
            self.didSelectTimePicker = true
        }
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func searchAct(_ sender: Any)
    {
        self.tryGetCustomerData()
    }
    
    private func tryGetCustomerData() {
        if nameTextField.hasText || phoneTextField.hasText || self.didSelectTimePicker {
            guard
                let name = nameTextField.text,
                let phone = phoneTextField.text else {
                    return
                }
            var birth = datePicker.date.toYearMonthDayStr()
            if !self.didSelectTimePicker {
                birth = ""
            }
            viewModel.tryGetDataFromDb(name: name, phone: phone, birthday: birth)
        } else {
            viewModel.tryGetDataFromDb()
        }
    }
    
    @IBAction func addNewAct(_ sender: Any)
    {
        guard
            let nameData = nameTextField.text,
            let phoneData = phoneTextField.text
        else{
             return
        }
        var birth = datePicker.date.toYearMonthDayStr()
        if !self.didSelectTimePicker {
            birth = ""
        }
        if nameData != "" && phoneData != "" &&  birth != ""{
            viewModel.setDataToDb = setToDBInfo(name: nameData, phone: phoneData, birth: birth)
        }
    }
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        datePicker.backgroundColor = .white
        searchBtn.layer.cornerRadius = BigBtnCornerRadius
        addNewBtn.layer.cornerRadius = BigBtnCornerRadius
        nameTextField.layer.cornerRadius = textFieldCornerRadius
        phoneTextField.layer.cornerRadius = textFieldCornerRadius
        birthBackground.layer.cornerRadius = textFieldCornerRadius
        customsListTableView.separatorStyle = .none
    }
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
        viewModel.setDataToDbClosure = {  [weak self] () in
            DispatchQueue.main.async {
                self?.customsListTableView.reloadData()
            }
        }
    }
    
    func toOrderDetailView(selectedId: Int32) {
        self.selectedCustomerId = selectedId
        guard let _ = selectedLashService else {
            performSegue(withIdentifier: "toKeratinOrder", sender: self)
            return
        }
        performSegue(withIdentifier: "toLashOrder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LashOrderViewController {
            let lash = segue.destination as! LashOrderViewController
            guard let lashTypeList = selectedLashService,
                  let customerId = self.selectedCustomerId else {
                      return
                  }
            lash.setOrderInfo(lashTypeList: lashTypeList, cId: customerId)
            if let allSelectedItems = selectedLashService {
                let topLashSelected: Bool = allSelectedItems.contains(.topAndBott) || allSelectedItems.contains(.topLash) || allSelectedItems.contains(.addTopLash)
                let bottLashSelected: Bool = allSelectedItems.contains(.bottLash) || allSelectedItems.contains(.topAndBott)
                lash.setLastEnable(isTopEnable: topLashSelected, isBottEnable: bottLashSelected)
            }
        }
        
        if segue.destination is KeratinOrderViewController {
            let keratin = segue.destination as! KeratinOrderViewController
            guard let customerId = self.selectedCustomerId else {
                return
            }
            keratin.setOrderInfo(cId: customerId)
        }
    }
}


extension SearchCustomsViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customsListTableView.delegate = self
        self.customsListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customsListCell", for: indexPath)
        let nameText : UITextField = cell.contentView.viewWithTag(1) as! UITextField
        let birthText : UITextField = cell.contentView.viewWithTag(2) as! UITextField
        let foundCustoms = viewModel.gCellViewData()
//        let index = foundCustoms.index(foundCustoms.startIndex, offsetBy: indexPath.row)
        let index = indexPath.row
        
        let customerDetail = foundCustoms[index]
        let name = customerDetail.full_name
        let birth = customerDetail.birthday
        
        nameText.text = name
        birthText.text = birth
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longTapAct(gesture:)))
        longPress.minimumPressDuration = 1
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allTableCellCount = viewModel.gCellViewData().count
        return allTableCellCount
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 8
        let cellHight = customsListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCustomer: Customer = self.viewModel.gCellViewData()[indexPath.row]
        
        self.nameTextField.text = selectedCustomer.full_name
        self.phoneTextField.text = selectedCustomer.phone_number
        if let birthStr = selectedCustomer.birthday, let birthDate = birthStr.toDate() {
            self.datePicker.setDate(birthDate, animated: false)
            self.didSelectTimePicker = true
        }
        let selectedId = selectedCustomer.id
        self.toOrderDetailView(selectedId: selectedId)
    }
    
    private func delectBtnView () -> UIView {
        let actionBtnViewW = self.view.frame.size.width * 0.95
        let actionBtnViewH = 50.0
        let ViewWidth = self.view.frame.size.width
        let ViewHeight = self.view.frame.size.height
        let btnCentralX = (ViewWidth - actionBtnViewW) / 2
        let btnCentralY = ViewHeight * 0.9
        let delectBtnBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        delectBtnBackground.backgroundColor = .clear
        let delectBtn = UIView(frame: CGRect(x: btnCentralX, y: btnCentralY, width: actionBtnViewW, height: actionBtnViewH))
        delectBtn.backgroundColor = .gray
        delectBtn.layer.cornerRadius = BigBtnCornerRadius
        let lableWidth = actionBtnViewW / 5
        let lableHeigth = actionBtnViewH
        let lableX = (delectBtn.frame.size.width - lableWidth) / 2
        let lableY = (delectBtn.frame.size.height - lableHeigth) / 2
        let label = UILabel(frame: CGRect(x: lableX, y: lableY, width: lableWidth, height: lableHeigth))
        label.text = "刪除"
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = .systemRed
        label.textAlignment = .center
        delectBtn.addSubview(label)
        let tapDelBtn = UITapGestureRecognizer(target: self, action: #selector(tapDelectBtn(gesture:)))
        tapDelBtn.numberOfTapsRequired = 1
        delectBtn.addGestureRecognizer(tapDelBtn)
        
        delectBtnBackground.addSubview(delectBtn)
        delectBtnBackground.tag = 4
        
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(tapDelectBtnBackground(gesture:)))
        tapBackground.numberOfTapsRequired = 1
        delectBtnBackground.addGestureRecognizer(tapBackground)
        return delectBtnBackground
    }
    
    @IBAction func longTapAct(gesture: UILongPressGestureRecognizer) {
        guard let indexPath = customsListTableView.indexPathForRow(at: gesture.location(in: self.customsListTableView)) else {
            print("Error: indexPath)")
            return
        }
        self.customsListTableView.cellForRow(at: indexPath)!.contentView.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().mainTint)
        let foundCustoms = viewModel.gCellViewData()
        let selectedCustomer: Customer = foundCustoms[indexPath.row]
        self.selectedCustomerId = selectedCustomer.id
        
        self.view.alpha = 0.6
        let delectView = self.delectBtnView()
        UIView.transition(with: self.view, duration: 0.5, options: [.curveEaseInOut], animations: {
            self.view.addSubview(delectView)
        }, completion: nil)
    }
    
    @IBAction func tapDelectBtnBackground(gesture: UITapGestureRecognizer) {
        restoreViewToNormal()
    }
    
    @IBAction func tapDelectBtn(gesture: UITapGestureRecognizer) {
        restoreViewToNormal()
        tryDelectCustomer()
    }
    private func restoreViewToNormal() {
        //restore view
        let allSubView = self.view.subviews
        for subView in allSubView {
            if subView.tag == 4 {
                subView.removeFromSuperview()
            }
        }
        self.view.alpha = 1
    }
    
    private func tryDelectCustomer() {
        //delect selected
        guard let cId =  self.selectedCustomerId else {return}
        if self.viewModel.delectCustomer(cId: cId) {
            self.tryGetCustomerData()
        }
    }
}



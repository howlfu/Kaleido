//
//  LashListViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/10/29.
//

import UIKit
class LashListViewController: BaseViewController{
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var toNextViewBtn: UIButton!
    var selectedCellArr: [LashListType] = []
    let aCellHightOfViewRadio = 8
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        toNextViewBtn.layer.cornerRadius = BigBtnCornerRadius
        listTableView.separatorStyle = .none
        toNextViewBtn.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SearchCustomsViewController {
            let  searchVC = segue.destination as! SearchCustomsViewController
            searchVC.selectedLashService = self.selectedCellArr
        }
    }
}

extension LashListViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "lashListCell", for: indexPath)
        let statusIcon : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let lblTitle : UILabel = cell.contentView.viewWithTag(2) as! UILabel
        let statusBG : UIImageView = cell.contentView.viewWithTag(3) as! UIImageView
        let backgroundView : UIView = cell.contentView.viewWithTag(4)!
        statusIcon.frame.origin.y = (backgroundView.frame.height - statusIcon.frame.size.height) / 2
        statusBG.frame.origin.y = (backgroundView.frame.height - statusBG.frame.size.height) / 2
        lblTitle.frame.origin.y = (backgroundView.frame.height - lblTitle.frame.size.height) / 2
        lblTitle.text = LashListType.allCases[indexPath.row].rawValue
        cell.contentView.frame.size.width = (cell.contentView.frame.size.width * 2) / 3
        cell.contentView.frame.size.height = (cell.contentView.frame.size.height * 2) / 3
        backgroundView.layer.cornerRadius = BigBtnCornerRadius
        backgroundView.sendSubviewToBack(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LashListType.allCases.count
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listTableView.frame.height / CGFloat(aCellHightOfViewRadio)
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        let rowIndex:Int = indexPath.row
        cellSelected(cell: selectedCell, index: rowIndex)
    }
    
    
    func cellSelected(cell: UITableViewCell?, index: Int) {
        guard let selectedCell = cell else {
            return
        }
        let statusIcon : UIImageView = selectedCell.contentView.viewWithTag(1) as! UIImageView
        let selectedListType = LashListType.allCases[index]
        if selectedCellArr.contains(selectedListType) {
            selectedCellArr.remove(at: selectedCellArr.firstIndex(of: selectedListType)!)
            statusIcon.image = nil
        } else {
            selectedCellArr.append(selectedListType)
            statusIcon.image =  UIImage(named: "Checked")
            toNextViewBtn.isHidden = false
        }
        
        if selectedCellArr.count == 0 {
            toNextViewBtn.isHidden = true
        }
    }
}


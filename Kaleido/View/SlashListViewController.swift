//
//  SlashList.swift
//  Kaleido
//
//  Created by Howlfu on 2021/10/29.
//

import UIKit
class SlashListViewController: BaseViewController{
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    let aCellHightOfViewRadio = 8
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: 100)
    }
}

extension SlashListViewController: UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCellHight = self.view.frame.height / CGFloat(aCellHightOfViewRadio)
        var cell: UITableViewCell? = nil
        cell  = tableView.dequeueReusableCell(withIdentifier: "slashListCell", for: indexPath)
        let statusBG : UIImageView = cell!.contentView.viewWithTag(3) as! UIImageView
        let statusIcon : UIImageView = cell!.contentView.viewWithTag(1) as! UIImageView
        let lblTitle : UILabel = cell!.contentView.viewWithTag(2) as! UILabel
        statusIcon.frame.origin.y = (tableCellHight - statusIcon.frame.size.height) / 2
        statusBG.frame.origin.y = (tableCellHight - statusBG.frame.size.height) / 2
        lblTitle.frame.origin.y = (tableCellHight - lblTitle.frame.size.height) / 2
        lblTitle.text = SlashListType.allCases[indexPath.row].rawValue
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SlashListType.allCases.count
    }
    

    
    
}

extension SlashListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return self.view.frame.height / CGFloat(aCellHightOfViewRadio)
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let rowIndex:Int = indexPath.row
//            self.selectBtn(rowIndex)
        }
}

//
//  DemoShowAllPhotoViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/24.
//

import UIKit

class DemoShowAllPhotoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var showPhotoTableView: UITableView!
    var controller: DemoShowController = DemoShowController()
    var viewModel: DemoShowModel {
        return controller.viewModel
    }
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
    }
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
    }
    
    public func setSelectedCustomerId(data: Int32) {
        self.viewModel.custmerId = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoAllImageCell", for: indexPath)
      
//        let nameText : UILabel = cell.contentView.viewWithTag(1) as! UILabel
        
        return cell
    }
}


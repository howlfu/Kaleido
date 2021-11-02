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
    var selectedSlashService: [SlashListType]?
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        datePicker.backgroundColor = .white
        datePicker.subviews.first?.semanticContentAttribute = .playback
//        datePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let tempHour = calendar.component(.hour, from: sender.date)
        let tempMinute = calendar.component(.minute, from: sender.date)

        Swift.print("hour: \(tempHour) minute: \(tempMinute)")
    }
}

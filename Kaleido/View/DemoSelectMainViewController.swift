//
//  DemoSelectMainViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import Foundation
import Photos
import UIKit
class DemoSelectMainViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var OrderDetail: UITextView!
    @IBOutlet weak var bindingBtn: UIButton!
    @IBOutlet weak var demoBtn: UIButton!
    @IBOutlet weak var favorite: UIButton!
    @IBAction func bindingAct(_ sender: Any) {
    }
    @IBAction func demoAct(_ sender: Any) {
    }
    @IBAction func favoriteAct(_ sender: Any) {
    }
    var controller: DemoSelectMainController = DemoSelectMainController()
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        bindingBtn.layer.cornerRadius = BigBtnCornerRadius
        demoBtn.layer.cornerRadius = BigBtnCornerRadius
        favorite.layer.cornerRadius = BigBtnCornerRadius
        let orderDetail = controller.getOrderData()
        let orderStr = controller.getOrderInforStr(data: orderDetail)
        OrderDetail.text = String(orderStr.dropLast(2))
    }
    
    override func initBinding() {
        super.initBinding()
        self.tryGetPhotoAuth()
        self.titleView.addGestureRecognizer(tapTitleView)
    }
    
    func tryGetPhotoAuth() {
        PHPhotoLibrary.requestAuthorization({
            (curStatus) in
            switch curStatus {
            case .notDetermined:
                print("notDetermined")
                self.returnToMainView(self)
            case .restricted:
                print("restricted")
            case .denied:
                DispatchQueue.main.async {
                    self.toGetUserAuthInSettings()
                }
            case .authorized:
                print("authorized")
            case .limited:
                print("limited")
            default:
                print("default")
            }
         })
    }
    
    func toGetUserAuthInSettings() {
        prsentNormalAlert(msg: "需要您同意使用照片", btn: "確定", viewCTL: self, completion: {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }, cancellation: {
            self.returnToMainView(self)
        })
    }
    
    public func setOrderInfo(data: Order) {
        self.controller.setOrderInfo(data: data)
    }
}

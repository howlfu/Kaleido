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
    override func initView() {
        super.initView()
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
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
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
}

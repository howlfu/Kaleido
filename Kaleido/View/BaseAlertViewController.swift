//
//  BaseAlertViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/15.
//

import Foundation
import UIKit

func prsentNormalAlert(msg: String, btn: String, viewCTL: UIViewController, completion: (() -> Void)? = nil, cancellation: (() -> Void)? = nil) {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    if let generalVC = mainStoryboard.instantiateViewController(withIdentifier: "baseAlert") as? BaseAlertViewController
    {
        generalVC.setUpDetail(msg: msg, btn: btn)
        generalVC.modalPresentationStyle = .overFullScreen
        generalVC.doneCallBack = completion
        generalVC.cancelCallBack = cancellation
        viewCTL.present(generalVC, animated: false, pushing: false)
    }
}


class BaseAlertViewController: UIViewController, UIGestureRecognizerDelegate {
    //self.dismiss(animated: true, completion: nil)
    @IBAction func btnAction(_ sender: Any) {
        dismiss(animated: false, completion: doneCallBack)
    }
    
    @IBAction func tabBackground(_ sender: Any) {
        dismiss(animated: false, completion: cancelCallBack)
    }
    @IBOutlet weak var alertBackground: UIView!
    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var msgTextField: UITextView!
    @IBOutlet weak var btnTextField: UIButton!
    var msgTextStr:String = ""
    var btnTitleStr:String = ""
    var doneCallBack: (() -> Void)? = nil
    var cancelCallBack: (() -> Void)? = nil
    override func viewDidLoad() {
        msgTextField.text = msgTextStr
        btnTextField.setTitle(btnTitleStr, for: .normal)
//        viewBackground.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5);
        alertBackground.layer.cornerRadius = 10
        alertBackground.clipsToBounds = true
        alertBackground.layer.borderWidth = 1
        alertBackground.layer.borderColor = UIColor.black.cgColor
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector (tabBackground))
        tabGesture.numberOfTapsRequired = 1
        tabGesture.delegate = self
        self.viewBackground.isUserInteractionEnabled = true
        self.viewBackground.addGestureRecognizer(tabGesture)
    }
    
    func setUpDetail(msg: String, btn: String) {
        self.msgTextStr = msg
        self.btnTitleStr = btn
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let tapOnViewRecog = touch.view else {
            return false
        }
        if tapOnViewRecog.isDescendant(of: self.alertBackground) {
            return false
        }
        return true
    }
}

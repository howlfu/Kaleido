//
//  BaseViewController.swift
//  Kaleido
//
//  Created by Civet on 2021/10/28.
//

import UIKit
class BaseViewController: UIViewController, UIGestureRecognizerDelegate{
    var titleId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        if #available(iOS 13.0, *) {
            self.view.window?.overrideUserInterfaceStyle = .light
        }

    }
}


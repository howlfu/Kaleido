//
//  BaseViewController.swift
//  Kaleido
//
//  Created by Civet on 2021/10/28.
//

import UIKit
class BaseViewController: UIViewController, UIGestureRecognizerDelegate{
    let titleViewRadius: CGFloat = 100.0
    let BigBtnCornerRadius: CGFloat = 20.0
    let textFieldCornerRadius: CGFloat = 10.0
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
    }
    
    func initView() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        if #available(iOS 13.0, *) {
            self.view.window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func initBinding() {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeBinding()
    }
    
    func removeBinding()
    {
        
    }
}


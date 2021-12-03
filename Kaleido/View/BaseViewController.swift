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
    var tapTitleView: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        tapTitleView = UITapGestureRecognizer(target: self, action: #selector (returnToMainView))
        tapTitleView.numberOfTapsRequired = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeBinding()
    }
    
    func removeBinding()
    {
        
    }
    
    @IBAction func returnToMainView(_ sender: Any){
        self.navigationController?.popToRootViewController(animated: false)
    }
}


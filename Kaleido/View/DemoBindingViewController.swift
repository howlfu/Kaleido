//
//  DemoBindingViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/20.
//

import Foundation
import Photos
import PhotosUI
import UIKit
class DemoBindingViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var orderCreateDayText: UITextField!
    @IBOutlet weak var photoSelectTableView: UITableView!
    @IBOutlet weak var orderPhotoBindBtn: UIButton!
    @IBAction func bindAct(_ sender: Any) {
        
    }
    var controller: DemoBindingController = DemoBindingController()
    var viewModel: DemoBindingModel {
        return controller.viewModel
    }
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        orderCreateDayText.layer.cornerRadius = textFieldCornerRadius
        orderPhotoBindBtn.layer.cornerRadius = BigBtnCornerRadius
    }
    
    override func initBinding() {
        super.initBinding()
        self.photoSelectTableView.delegate = self
        self.photoSelectTableView.dataSource = self
        self.titleView.addGestureRecognizer(tapTitleView)
        checkPhotoAuth()
        let toPhotoViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        toPhotoViewTap.numberOfTapsRequired = 1
        photoSelectTableView.addGestureRecognizer(toPhotoViewTap)
        self.viewModel.imageSelected.addObserver(fireNow: false) {[weak self] (newData) in
            self?.photoSelectTableView.reloadData()
        }
    }
    @IBAction func handleTap(_ sender: Any){
        self.selectPhoto()
    }
    
    func checkPhotoAuth() {
        let status:PHAuthorizationStatus?
        if #available(iOS 14, *) {
            status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        if status == .denied {
            toGetUserAuthInSettings()
        }
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

extension DemoBindingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.imageSelected.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 2
        let cellHight = photoSelectTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoBindCell", for: indexPath)
        let foundImages = viewModel.imageSelected.value
        let index = indexPath.row
        let cellImage = foundImages[index]
        let imageItem : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageItem.image = cellImage
        let toPhotoViewTap = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAct))
        toPhotoViewTap.minimumPressDuration = 1
        cell.addGestureRecognizer(toPhotoViewTap)
        return cell
    }
    
    @IBAction func longPressAct(gesture: UITapGestureRecognizer) {
        let presentVC = UIViewController()
        let backgroundView = UIView()
        backgroundView.backgroundColor = .gray
        backgroundView.alpha = 0.6
        let imageZoomIn = UIImageView()
        let imageW = backgroundView.frame.size.width
        let imageH = backgroundView.frame.size.height * 2 / 3
        let imageX = photoSelectTableView.frame.origin.x
        let imageY = photoSelectTableView.frame.origin.y
        guard let indexPath = photoSelectTableView.indexPathForRow(at: gesture.location(in: self.photoSelectTableView)) else {
            print("Error: indexPath)")
            return
        }
        if let cell = self.photoSelectTableView.cellForRow(at: indexPath), let cellImage = cell.contentView.viewWithTag(1) as? UIImageView{
            imageZoomIn.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
            imageZoomIn.image = cellImage.image
            backgroundView.addSubview(imageZoomIn)
        }
        let topBackground = UITapGestureRecognizer(target: self, action: #selector(self.tapBackForReturn))
        topBackground.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(topBackground)
        presentVC.view.addSubview(backgroundView)
        self.present(presentVC, animated: false, completion: nil)
    }
    @IBAction func tapBackForReturn(gesture: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}

extension DemoBindingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false, completion: nil)
        if results.count > 0 {
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self]  image, error in
                        if let selectedImage = image as? UIImage {
                            self?.viewModel.imageSelected.value.append(selectedImage)
                        }
                    }
                }
            }
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.viewModel.imageSelected.value.append(image)
        _ = saveImageToDb(data: image)
        dismiss(animated: false)
    }
    
    func saveImageToDb(data: UIImage) -> Bool{
        guard let savedData = data.pngData() else {
            return false
        }
//        do {
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//            try savedData.write(to: URL(string: "\(documentsPath)/image/\()")!, options: .atomic)
//        } catch {
//            print("Error")
//            return false
//        }
        return true
    }
    
    func selectPhoto() {
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 10
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let controller = UIImagePickerController()
            controller.sourceType = .photoLibrary
            controller.delegate = self
            present(controller, animated: true, completion: {
                print("selection done")
            })
        }
    }
}

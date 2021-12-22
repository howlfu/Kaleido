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
        prsentNormalAlert(msg: "綁定照片", btn: "確定", viewCTL: self, completion: {
            self.performSegue(withIdentifier: "backToDemoSearch", sender: self)
        })
    }
    var controller: DemoBindingController = DemoBindingController()
    var viewModel: DemoBindingModel {
        return controller.viewModel
    }
    let imageZoomIn = UIImageView()
    
    public func setSelectedOrder(data: Order) {
        controller.setOrderInfo(data: data)
    }
    
    func saveImageToDb() -> Bool{

//        do {
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//            try savedData.write(to: URL(string: "\(documentsPath)/image/\()")!, options: .atomic)
//        } catch {
//            print("Error")
//            return false
//        }
        return true
    }
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        orderCreateDayText.layer.cornerRadius = textFieldCornerRadius
        orderPhotoBindBtn.layer.cornerRadius = BigBtnCornerRadius
        let orderData = controller.getOrderData()
        orderCreateDayText.text = orderData?.created_at?.toYearMonthDayStr()
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
        self.viewModel.pathSelected.addObserver(fireNow: false) {[weak self] (newData) in
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

extension DemoBindingViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.pathSelected.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 2
        let cellHight = photoSelectTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoBindCell", for: indexPath)
//        let foundImages = viewModel.imageSelected.value
        let index = indexPath.row
//        let cellImage = foundImages[index]
        let pathName = viewModel.pathSelected.value[index]
        let cellImage = getImageByPath(path: pathName)
        let imageItem : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageItem.image = cellImage
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAct))
        longPress.minimumPressDuration = 1
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    @IBAction func longPressAct(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            let backgroundView = UIScrollView()
            backgroundView.delegate = self
            backgroundView.minimumZoomScale = 1.0
            backgroundView.maximumZoomScale = 10.0
            backgroundView.frame = CGRect(origin: UIScreen.main.bounds.origin, size:  UIScreen.main.bounds.size)
            backgroundView.backgroundColor = .gray.withAlphaComponent(0.6)
            let imageW = backgroundView.frame.size.width
            let imageH = backgroundView.frame.size.height * 2 / 3
            let imageX =  backgroundView.frame.origin.x
            let imageY = (backgroundView.frame.size.height - imageH) / 2
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
    
            backgroundView.tag = 100
            self.view.addSubview(backgroundView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageZoomIn
    }
    
    @IBAction func tapBackForReturn(gesture: UITapGestureRecognizer) {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
}

extension DemoBindingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false, completion: nil)
        if results.count > 0 {
            var tmpPathOfSelectedImg: [String] = []
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    var savedName = ""
                    if let forTypeId = itemProvider.registeredTypeIdentifiers.first {
                        itemProvider.loadFileRepresentation(forTypeIdentifier: forTypeId) { (url, error) in
                            if error != nil {
                               print("error \(error!)");
                            } else {
                                if let url = url {
                                    let filePath = url.lastPathComponent;
                                    savedName = filePath
                                }
                            }
                        }
                    }
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self]  image, error in
                        if let selectedImage = image as? UIImage {
                            if let savedIamgePath = self?.saveImage(data: selectedImage, name: savedName) {
                                tmpPathOfSelectedImg.append(savedIamgePath)
                                if result == results.last {
                                    self?.viewModel.pathSelected.value.append(contentsOf: tmpPathOfSelectedImg)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func saveImage(data: UIImage, name: String) -> String {
        var retPath = ""
        do {
            if let PNGImage = data.pngData() {
                let filePathWithName = name
                let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filePathWithName)
                try PNGImage.write(to: filename, options: .atomic)
                retPath = filePathWithName
           }
        } catch {
            print("error")
        }
        return retPath
    }
    
    func getImageByPath(path: String) -> UIImage?{
//        do {
//            let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
//            let readData = try Data(contentsOf: URL(string: filename)!)
//            let retreivedImage = UIImage(data: readData)
//            return retreivedImage
//        } catch {
//            print("Error")
//        }
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
        let pathName = filename.path
        if FileManager.default.fileExists(atPath: pathName) {
            let retImg = UIImage(contentsOfFile: pathName)
            return retImg
        }
        
        return nil
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
//                let asset = result.firstObject
//                print(asset?.value(forKey: "filename"))
//
//            }
//        guard let image = info[.originalImage] as? UIImage else {
//            return
//        }
//        self.viewModel.imageSelected.value.append(image)
//        dismiss(animated: false)
//    }
    
    
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

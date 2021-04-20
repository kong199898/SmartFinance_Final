import Foundation
import UIKit
import Photos

class Attachment: NSObject {
    static let share = Attachment()
    fileprivate var currVC: UIViewController!
    var imagePicked: ((UIImage) -> Void)?
    
    private override init() {
        currVC = UIApplication.shared.windows.first!.rootViewController
    }
    
    enum AttachmentType: String {
        case Camera, PhotoLibrary
    }
    
    func showActionSheet() {
        var alertcontroller = UIAlertController()
        alertcontroller = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        alertcontroller.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.authorizeStatus(attachmentType: .Camera)
        }))
        alertcontroller.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            self.authorizeStatus(attachmentType: .PhotoLibrary)
        }))
        alertcontroller.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        if UIDevice.current.userInterfaceIdiom != .phone {
            alertcontroller.modalPresentationStyle = UIModalPresentationStyle.popover
            alertcontroller.popoverPresentationController?.sourceRect = CGRect(x: currVC.view.frame.size.width/2,
                                                                           y: currVC.view.frame.size.height/4,
                                                                           width: 0,
                                                                           height: 0)
            alertcontroller.popoverPresentationController?.sourceView = currVC.view
            alertcontroller.popoverPresentationController?.permittedArrowDirections = .any
            currVC.present(alertcontroller, animated: true, completion: nil)
        }
        else {
            currVC.present(alertcontroller, animated: true, completion: nil)
        }
    }
    
    func authorizeStatus(attachmentType: AttachmentType) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        
        if attachmentType == AttachmentType.Camera {
            if cameraStatus == .authorized {
                CameraOn()
            } else if cameraStatus == .denied {
                attachmentAlert(attachmentType)
            } else if cameraStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success { self.CameraOn() }
                    else {
                        self.attachmentAlert(attachmentType)
                    }
                }
            } else if cameraStatus == .restricted {
                attachmentAlert(attachmentType)
            }
        }else{
            if photoStatus == .authorized{
                if attachmentType == AttachmentType.PhotoLibrary { LibraryOn() }
            } else if photoStatus == .denied{
                print("permission denied")
                attachmentAlert(attachmentType)
            } else if photoStatus == .notDetermined{
                print("Permission Not Determined")
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized {
                        print("access given")
                        if attachmentType == AttachmentType.PhotoLibrary { self.LibraryOn() }
                    } else {
                        print("restriced manually")
                        self.attachmentAlert(attachmentType)
                    }
                })
            } else if photoStatus == .restricted{
                print("permission restricted")
                attachmentAlert(attachmentType)
            }
        }
    }
    
    @objc func CameraOn() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let ImagePicker = UIImagePickerController()
                    ImagePicker.delegate = self
                    ImagePicker.sourceType = .camera
                    self.currVC?.present(ImagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func LibraryOn() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let ImagePicker = UIImagePickerController()
                    ImagePicker.delegate = self
                    ImagePicker.sourceType = .photoLibrary
                    ImagePicker.mediaTypes = ["public.image"]
                    self.currVC?.present(ImagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func attachmentAlert(_ attachmentType: AttachmentType) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                var alertTitle: String = ""
                if attachmentType == AttachmentType.PhotoLibrary {
                    alertTitle = "SmartFinance does not have access to your photo library."
                }
                if attachmentType == AttachmentType.Camera {
                    alertTitle = "SmartFinance does not have access to your camera."
                }
                let CameraAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let setting = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
                    let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.shared.open(url as URL, options: [:])
                    }
                }
                CameraAlertController .addAction(cancel)
                CameraAlertController .addAction(setting)
                self.currVC?.present(CameraAlertController , animated: true)
            }
        }
    }
}

extension Attachment: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currVC?.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePicked?(image)
        }
        currVC?.dismiss(animated: true)
    }
}

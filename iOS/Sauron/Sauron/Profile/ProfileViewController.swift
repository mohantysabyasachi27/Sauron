//
//  ProfileViewController.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos
import Alamofire
import PopupDialog
import AVKit

enum ProfileSegment: String {
    case reviewed = "Approved"
    case pending = "Pending"
    case rejected = "Rejected"
}

enum UploadType{
    case image
    case video
}

class ProfileViewController: TwitterProfileViewController {
    
    var locationManager:CLLocationManager!
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -111.9280527, longitude: 33.4242)
    
    @IBOutlet weak var leftBarButton: UIButton!
    var rightButton: UIBarButtonItem!

    var tweetTableView: UITableView!
    var photosTableView: UITableView!
    var favoritesTableView: UITableView!
    
    var custom: UIView!
    var label: UILabel!
    
    private var imageTobeUploaded: UIImage!
    private var imageInfoTobeUploaded: [UIImagePickerController.InfoKey : Any]!
    private var videoData: Data!
    private var uploadType: UploadType = .image
    private var catId: Int!
    
    override func numberOfSegments() -> Int {
        return 3
    }
    
    override func segmentTitle(forSegment index: Int) -> String {
        if index == 0{
            return ProfileSegment.pending.rawValue
        } else if index == 1 {
            return ProfileSegment.reviewed.rawValue
        }
        return ProfileSegment.rejected.rawValue
    }
    
    override func prepareForLayout() {
        // TableViews
        let _tweetTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.tweetTableView = _tweetTableView
        
        let _photosTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.photosTableView = _photosTableView
        
        let _favoritesTableView = UITableView(frame: CGRect.zero, style: .plain)
        self.favoritesTableView = _favoritesTableView
        
        self.setupTables()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if !Authentication.shared.isLoggedIn{
            rightButton = UIBarButtonItem(title: "Login", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonClicked(_:)))

//            self.leftBarButton.setTitle("Login", for: .normal)
        } else {
            rightButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonClicked(_:)))
        }
        self.navigationItem.rightBarButtonItem = rightButton

        self.locationString = "Tempe"
        self.username = (Authentication.shared.profile?.firstName ?? "Guest") + " " + (Authentication.shared.profile?.lastName ?? "User")
        self.profileImage = UIImage.init(named: "no_user_pic")
        Authentication.shared.fetchUserProfile {
            self.reloadData()
        }
        Authentication.shared.fetchTickets {
            self.reloadData()
        }

    }
    
    func reloadData() {
        self.username = (Authentication.shared.profile?.firstName ?? "Guest") + " " + (Authentication.shared.profile?.lastName ?? "User")
        self.profileHeaderView.descriptionLabel.text = String(Authentication.shared.profile?.totalPoints ?? 0) + " Points"
        self.tweetTableView.reloadData()
        self.favoritesTableView.reloadData()
        self.photosTableView.reloadData()
        self.shouldUpdateScrollViewContentFrame = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rightButton.tintColor = UIColor.peacockBlue()
        self.determineMyCurrentLocation()
    }
    
    enum AttachmentType: String{
        case camera, video, photoLibrary
    }
    
    @objc func doneButtonClicked(_ button:UIBarButtonItem!){
        Authentication.shared.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            let navCtrl = UINavigationController(rootViewController: viewController)
            navCtrl.modalTransitionStyle = .flipHorizontal
            self.navigationController?.present(navCtrl, animated: true, completion: nil)
        }
    }

    override func scrollView(forSegment index: Int) -> UIScrollView {
        switch index {
        case 0:
            return tweetTableView
        case 1:
            return photosTableView
        case 2:
            return favoritesTableView
        default:
            return tweetTableView
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentActionSheet() {
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }else{
                    print("restriced manually")
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        self.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
    
    

    override func didTapOnReportButton() {
        self.showAttachmentActionSheet()
    }
    
    override func refreshData() {
        self.reloadData()
    }
}



// MARK: UITableViewDelegates & DataSources
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func setupTables() {
        self.tweetTableView.delegate = self
        self.tweetTableView.dataSource = self
        self.tweetTableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCell")

        self.tweetTableView.register(UITableViewCell.self, forCellReuseIdentifier: "tweetCell")
        
        self.photosTableView.delegate = self
        self.photosTableView.dataSource = self
        //self.photosTableView.isHidden = true
        self.photosTableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCell")

//        self.photosTableView.register(UITableViewCell.self, forCellReuseIdentifier: "photoCell")
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        //self.favoritesTableView.isHidden = true
        self.favoritesTableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "TicketTableViewCell")

//        self.favoritesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tweetTableView:
            return Authentication.shared.pendingTickets.count
        case self.photosTableView:
            return Authentication.shared.approvedTickets.count
        case self.favoritesTableView:
            return Authentication.shared.rejectedTickets.count
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.tweetTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell", for: indexPath) as! TicketTableViewCell
            cell.header.text = Authentication.shared.pendingTickets[indexPath.row].ticketId
            cell.subheader.text = String(Authentication.shared.pendingTickets[indexPath.row].date.prefix(10))
            cell.statusIV.image = TicketStatus(id: Authentication.shared.pendingTickets[indexPath.row].status)?.getButtonImage()
            if Authentication.shared.pendingTickets[indexPath.row].isVideo == true{
                cell.movIV.isHidden = false
            }
            return cell
            
        case self.photosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell", for: indexPath) as! TicketTableViewCell
            cell.header.text = Authentication.shared.approvedTickets[indexPath.row].ticketId
            cell.subheader.text = String(Authentication.shared.approvedTickets[indexPath.row].date.prefix(10))
            cell.statusIV.image = TicketStatus(id: Authentication.shared.approvedTickets[indexPath.row].status)?.getButtonImage()
            if Authentication.shared.approvedTickets[indexPath.row].isVideo == true{
                cell.movIV.isHidden = false
            }

            return cell
            
        case self.favoritesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell", for: indexPath) as! TicketTableViewCell
            cell.header.text = Authentication.shared.rejectedTickets[indexPath.row].ticketId
            cell.subheader.text = String(Authentication.shared.rejectedTickets[indexPath.row].date.prefix(10))
            cell.statusIV.image = TicketStatus(id: Authentication.shared.rejectedTickets[indexPath.row].status)?.getButtonImage()
            if Authentication.shared.rejectedTickets[indexPath.row].isVideo == true{
                cell.movIV.isHidden = false
            }

            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tweetTableView:
            let ticket = Authentication.shared.pendingTickets[indexPath.row]
            if ticket.isVideo, let link = ticket.link{
                showVideo(videoURL: URL(string: link)!)
            }
        case self.photosTableView:
            let ticket = Authentication.shared.approvedTickets[indexPath.row]
            if ticket.isVideo, let link = ticket.link{
                showVideo(videoURL: URL(string: link)!)
            }

        case self.favoritesTableView:
            let ticket = Authentication.shared.rejectedTickets[indexPath.row]
            if ticket.isVideo, let link = ticket.link{
                showVideo(videoURL: URL(string: link)!)
            }

        default:
            let ticket = Authentication.shared.pendingTickets[indexPath.row]
            if ticket.isVideo, let link = ticket.link{
                showVideo(videoURL: URL(string: link)!)
            }
        }

    }
        func showVideo(videoURL: URL){
            let player = AVPlayer(url: videoURL)
            let vc = AVPlayerViewController()
            vc.player = player
            
            present(vc, animated: true) {
                vc.player?.play()
            }
        }
}

extension ProfileViewController{
    func uploadData(type: UploadType){
        switch type {
        case .image:
            self.uploadImage(image: imageTobeUploaded, info: imageInfoTobeUploaded)

        case .video:
            self.uploadVideo(videoData)
        }
    }
    func uploadImage(image: UIImage, info: [UIImagePickerController.InfoKey : Any]) {
        if let imageData = image.jpegData(compressionQuality: 1){
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            let fileName = imageURL.lastPathComponent
            let user = Authentication.shared.profile
            let parameters: [String:String] = [
                "username" : user?.emailId ?? "anonymous",
                "latitude"  : String(coordinate.latitude),
                "longitude" : String(coordinate.longitude),
                "date"  : Date().toString(dateFormat: "yyyy-MM-dd"),
                "categoryId": String(catId),
                "isVideo": "false"
            ]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "file", fileName: fileName ?? "image_file.jpeg", mimeType: "image/jpeg")
                multipartFormData.append((parameters.description).data(using: .utf8)!, withName: "ticketData")
            }, to:Constants.ticket, headers: ["Content-Type": "application/x-www-form-urlencoded"])
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        //self.delegate?.showSuccessAlert()
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        //                        self.showSuccesAlert()
                        //self.removeImage("frame", fileExtension: "txt")
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            Authentication.shared.fetchUserProfile {
                                self.reloadData()
                            }
                            Authentication.shared.fetchTickets {
                                self.reloadData()
                            }

                            let popup = PopupDialog(title: "Awesome!!!", message: "You helped make the world a better place.")
                            // Create buttons
                            let buttonOne = CancelButton(title: "Yeyy!!!") {
                                print("You canceled the car dialog.")
                            }
                            popup.addButton(buttonOne)
                            self.present(popup, animated: true, completion: nil)
                            
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                    let popup = PopupDialog(title: "OOPS!!!", message: "It's not you, it's us. Please retry.")
                    // Create buttons
                    let buttonOne = CancelButton(title: "Ok") {
                        print("You canceled the car dialog.")
                    }
                    popup.addButton(buttonOne)
                    self.present(popup, animated: true, completion: nil)
                    
                }
                
            }
        }
    }
    
    func uploadVideo(_ data: Data) {
        //        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        //        let fileName = imageURL.lastPathComponent
        let user = Authentication.shared.profile
        let parameters: [String:String] = [
            "username" : user?.emailId ?? "anonymous",
            "latitude"  : String(coordinate.latitude),
            "longitude" : String(coordinate.longitude),
            "date"  : Date().toString(dateFormat: "yyyy-MM-dd"),
            "categoryId": String(catId),
            "isVideo": "true"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: "file", fileName: "video.mov", mimeType: "video/mov")
            multipartFormData.append((parameters.description).data(using: .utf8)!, withName: "ticketData")
        }, to:Constants.ticket, headers: ["Content-Type": "application/x-www-form-urlencoded"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //self.delegate?.showSuccessAlert()
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    //self.removeImage("frame", fileExtension: "txt")
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        Authentication.shared.fetchUserProfile {
                            self.reloadData()
                        }
                        Authentication.shared.fetchTickets {
                            self.reloadData()
                        }
                        let popup = PopupDialog(title: "Awesome!!!", message: "You helped make the world a better place.")
                        // Create buttons
                        let buttonOne = CancelButton(title: "Yeyy!!!") {
                            print("You canceled the car dialog.")
                        }
                        popup.addButton(buttonOne)
                        self.present(popup, animated: true, completion: nil)
                        
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                let popup = PopupDialog(title: "OOPS!!!", message: "It's not you, it's us. Please retry.")
                // Create buttons
                let buttonOne = CancelButton(title: "Ok") {
                    print("You canceled the car dialog.")
                }
                popup.addButton(buttonOne)
                self.present(popup, animated: true, completion: nil)
                
            }
            
        }
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //            self.imagePickedBlock?(image)
            self.imageTobeUploaded = image
            self.imageInfoTobeUploaded = info
            self.uploadType = .image
            WelcomeAlertView.show(delegate: self)
//            self.uploadImage(image: image, info: info)
            print("in  image")
            
        } else if let videoUrl = info[.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            do {
                let data = try Data(contentsOf: videoUrl as URL)
                print("File size before compression: \(Double(data.count / 1048576)) mb")
                compressWithSessionStatusFunc(videoUrl)
            } catch {
                
            }
        }
        else{
            print("Something went wrong in  video")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                do {
                    let compressedData = try Data(contentsOf: compressedURL)
                    print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                    
                    DispatchQueue.main.async {
                        //                    self.videoPickedBlock?(compressedURL as NSURL)
//                        self.uploadVideo(compressedData)
                        self.uploadType = .video
                        self.videoData = compressedData
                        WelcomeAlertView.show(delegate: self)

                    }
                } catch {
                    
                }
                
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}


extension ProfileViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        coordinate.latitude = userLocation.coordinate.latitude
        coordinate.longitude = userLocation.coordinate.longitude
        print("user latitude = \(coordinate.latitude)")
        print("user longitude = \(coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
}

extension ProfileViewController: WelcomeAlertViewProtocol{
    func dropdownselected(at index: Int) {
        catId = Authentication.shared.categories[index].categoryId
        print("T##items: Any...##Any\(String(describing: catId))")
    }
    
    func dismissed() {
        
    }
    func okPressed(_ view: UIView) {
        self.uploadData(type: self.uploadType)
    }
    
}

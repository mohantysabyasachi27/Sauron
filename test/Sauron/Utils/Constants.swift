//
//  Constants.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation

public struct Constants {
    public static let baseURL: String = "http://localhost:8080/"
    public static let registerURL: String = baseURL + "users"
    public static let loginURL: String = baseURL + "login"
    public static let ticket: String = baseURL + "ticket"

    
    public static let actionFileTypeHeading = "Upload"
    public static let actionFileTypeDescription = "Choose a from below options to upload ..."
    public static let camera = "Camera"
    public static let phoneLibrary = "Phone Library"
    public static let video = "Video"
    
    
    public static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    public static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
    public static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
    
    
    public static let settingsBtnTitle = "Settings"
    public static let cancelBtnTitle = "Cancel"
}

//
//  Bundle+Pod.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation

extension Bundle {
  static func bundleFromPod() -> Bundle? {
    let bundle = Bundle.init(for: TwitterProfileViewController.self)
    if let url = bundle.url(forResource: nil, withExtension: "bundle") {
      return Bundle.init(url: url)
    }
    
    return nil
  }
}

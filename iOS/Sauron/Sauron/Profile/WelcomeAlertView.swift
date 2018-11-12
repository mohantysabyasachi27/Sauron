//
//  WelcomeAlertView.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import UIKit
import DropDown

protocol WelcomeAlertViewProtocol: class {
    func okPressed(_ view: UIView)
    func dismissed()
    func dropdownselected(at index:Int)
}

class WelcomeAlertView: UIView {
    
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertMessage: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var categoryField: UITextField!
    let dropDown = DropDown()
    @IBOutlet weak var okButton: UIButton!
    
    weak var delegate:WelcomeAlertViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /**
     Sets up the view by loading it from the xib file and setting its frame
     */
    func setupView() {
        let nib = Bundle.main.loadNibNamed("WelcomeAlertView", owner: self, options: nil)
        if let view = nib?[0] as? UIView {
            view.frame = bounds
            let uiTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
            view.addGestureRecognizer(uiTapRecognizer)
            addSubview(view)
            dropDown.isHidden = true
            let cat = Authentication.shared.categories
            if !cat.isEmpty {
                dropDown.isHidden = false
                dropDown.anchorView = categoryField
                dropDown.dismissMode = .automatic
                dropDown.dataSource = Authentication.shared.categories.map({ (ctg) -> String in
                    return ctg.categoryTitle
                })
                
            }

        }
    }
    
    class func show(delegate: WelcomeAlertViewProtocol?){
        guard let window = UIApplication.shared.keyWindow else {return}
        let welcomeAlert = WelcomeAlertView(frame: window.bounds)
        welcomeAlert.configureView()
        welcomeAlert.delegate = delegate
        
        let yActual = (Constants.SCREEN_HEIGHT - welcomeAlert.contentView.bounds.height)/2
        welcomeAlert.contentView.frame.origin.y = Constants.SCREEN_HEIGHT
        window.addSubview(welcomeAlert)
        
        UIView.animate(withDuration: 0.3, animations: {
            welcomeAlert.contentView.frame.origin.y = yActual
        }, completion: nil)
        
    }
    
    func configureView(){
        
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        self.delegate?.okPressed(self)
        dismissView()

    }

    @objc func dismissPopUp() {
//        self.delegate?.dismissed()
//        dismissView()
    }
    
    func dismissView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame.origin.y = Constants.SCREEN_HEIGHT
        }, completion: { (finished) -> Void in
            self.removeFromSuperview()
        })
    }
    @IBAction func textFieldTapped(_ sender: Any) {
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.categoryField.text = item
            self.delegate?.dropdownselected(at: index)
        }
        dropDown.show()

    }
}

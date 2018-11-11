//
//  TextFieldEffects.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation
import UIKit

protocol TextFieldsEffectsProtocol {
    func drawViewsForRect(_ rect: CGRect)
    func updateViewsForBoundsChange(_ bounds: CGRect)
    func animateViewsForTextEntry()
    func animateViewsForTextDisplay()
}

open class TextFieldEffects : UITextField, TextFieldsEffectsProtocol {
    
    let placeholderLabel = UILabel()
    
    func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
    
    // MARK: - Overrides
    
    override open func draw(_ rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }
    
    // MARK: - UITextField Observing
    
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(TextFieldEffects.textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(TextFieldEffects.textFieldDidBeginEditing), name:UITextField.textDidBeginEditingNotification, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    @objc open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
}

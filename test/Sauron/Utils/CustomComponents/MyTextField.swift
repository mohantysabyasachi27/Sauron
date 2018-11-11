//
//  MyTextField.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import UIKit

open class MyTextField : TextFieldEffects {
    //@IBDesignable public class MyTextField : TextFieldEffects {
    
    let errorLabel = UILabel()
    
    fileprivate let animationDuration:TimeInterval = 0.3
    fileprivate let textToHintRatio:CGFloat = 0.857
    fileprivate let underlineLayer = CALayer()
    fileprivate let textFieldInsets = CGPoint(x: 0.0, y: 0.0)
    fileprivate let placeHolderInsets = CGPoint(x: 0.0, y: 2.0)
    fileprivate let errorInsets = CGPoint(x: 0.0, y: 1.0)
    fileprivate let lineNTextYSpacing:CGFloat = 6.0
    fileprivate var shouldUpdatePlaceholderOnTextChange:Bool = true
    
    open var activeColor: UIColor = UIColor.peacockBlue() {
        didSet {
            if isFirstResponder {
                placeholderLabel.textColor = activeColor
                if !primitiveHasError {
                    underlineLayer.backgroundColor = activeColor.cgColor
                }
            }
        }
    }
    
    open var placeholderColor: UIColor = UIColor.textPlaceholder() {
        didSet {
            updatePlaceholder()
        }
    }
    
    open var errorColor: UIColor = UIColor.error() {
        didSet {
            updateErrorMessage()
        }
    }
    
    open var underlineColor: UIColor = UIColor.greySeparator() {
        didSet {
            updateUnderline()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable open var shouldAllowPaste: Bool = true
    
    @IBInspectable open var errorMessage: String? {
        didSet {
            updateErrorMessage()
        }
    }
    
    open var clearErrorOnBeginEditing = true
    open var hasError:Bool {
        set(newError) {
            primitiveHasError = newError
            updateUnderline()
            errorLabel.text = primitiveHasError ? errorMessage : nil
            invalidateIntrinsicContentSize()
        }
        
        get {
            return primitiveHasError
        }
    }
    
    fileprivate var primitiveHasError = false
    
    override open var bounds: CGRect {
        didSet {
            updateUnderline()
            updateErrorMessage()
            updatePlaceholder()
        }
    }
    
    open var textAnimated : String! {
        set (newText) {
            shouldUpdatePlaceholderOnTextChange = false
            self.text = newText
            shouldUpdatePlaceholderOnTextChange = true
            UIView.animate(withDuration: animationDuration, animations: { self.updatePlaceholder() })
        }
        
        get {
            return text
        }
    }
    
    override open var text: String? {
        didSet {
            if shouldUpdatePlaceholderOnTextChange {
                updatePlaceholder()
            }
        }
    }
    
    func showError(_ errorMsg: String?) {
        
        if let errMSg = errorMsg , !errMSg.isEmpty {
            primitiveHasError = true
            underlineLayer.backgroundColor = errorColor.cgColor
            errorMessage = errorMsg
            
        } else {
            primitiveHasError = false
            underlineLayer.backgroundColor = underlineColor.cgColor
            errorMessage = nil
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if hasAccessoryView && inputAccessoryView == nil {
            hasAccessoryView = true
        }
    }
    
    override open func drawViewsForRect(_ rect: CGRect) {
        
        tintColor = UIColor.peacockBlue()
        if hasAccessoryView && inputAccessoryView == nil {
            hasAccessoryView = true
        }
        
        updateUnderline()
        updatePlaceholder()
        updateErrorMessage()
        
        layer.addSublayer(underlineLayer)
        
        addSubview(placeholderLabel)
        addSubview(errorLabel)
        
        placeholderLabel.isUserInteractionEnabled = false
        errorLabel.isUserInteractionEnabled = false
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if !shouldAllowPaste {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) {
                return false
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func animateViewsForTextEntry() {
        if self.clearErrorOnBeginEditing {
            primitiveHasError = false
            invalidateIntrinsicContentSize()
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.updatePlaceholder()
            self.updateUnderline()
            
            if self.clearErrorOnBeginEditing {
                self.errorLabel.text = nil
                self.layoutIfNeeded()
            }
        })
    }
    
    override func animateViewsForTextDisplay() {
        UIView.animate(withDuration: animationDuration, animations: {
            self.updatePlaceholder()
            self.updateUnderline()
        })
    }
    
    fileprivate func updateUnderline() {
        underlineLayer.frame = CGRect(x: 0, y: fixedIntrinsicHeight() - 1 , width: bounds.width, height: 1.0)
        
        if primitiveHasError {
            underlineLayer.backgroundColor = errorColor.cgColor
            
        } else if isFirstResponder {
            underlineLayer.backgroundColor = activeColor.cgColor
            
        } else {
            underlineLayer.backgroundColor = placeholderColor.cgColor
        }
    }
    
    fileprivate func updatePlaceholder() {
        
        placeholderLabel.transform = placeholderTransform()
        placeholderLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.font = placeholderFontFromFont(self.font!)
        placeholderLabel.textColor = isFirstResponder ? activeColor : placeholderColor
        placeholderLabel.textAlignment = textAlignment
    }
    
    fileprivate func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        return font
    }
    
    fileprivate var placeholderHeight : CGFloat {
        return 2*placeHolderInsets.y + ((placeholderFontFromFont(self.font!).lineHeight) * textToHintRatio);
    }
    
    fileprivate func placeholderTransform() -> CGAffineTransform {
        if isFirstResponder || !(text!.isEmpty) {
            return CGAffineTransform(scaleX: textToHintRatio, y: textToHintRatio)
        } else {
            return CGAffineTransform.identity
        }
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || !(text!.isEmpty) {
            return CGRect(x: placeHolderInsets.x, y: 0, width: bounds.width - (2*placeHolderInsets.x), height: (placeholderHeight - 2*placeHolderInsets.y))
        } else {
            return textRect(forBounds: bounds)
        }
    }
    
    fileprivate func updateErrorMessage() {
        errorLabel.frame = errorRectForBounds(bounds)
        errorLabel.text = primitiveHasError ? errorMessage : nil
        errorLabel.font = errorFontFromFont(self.font!)
        errorLabel.textColor = errorColor
        errorLabel.textAlignment = textAlignment
        errorLabel.adjustsFontSizeToFitWidth = true
    }
    
    fileprivate func errorFontFromFont(_ font: UIFont) -> UIFont! {
        return UIFont(name: font.fontName, size: (font.pointSize * textToHintRatio))
    }
    
    fileprivate var errorHeight : CGFloat {
        return bounds.height - fixedIntrinsicHeight();
    }
    
    open func errorRectForBounds(_ bounds: CGRect) -> CGRect {
        return CGRect(x: errorInsets.x, y: fixedIntrinsicHeight() - 2 , width: bounds.width - (2*errorInsets.x), height: errorHeight + 2)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = bounds
        
        newBounds.origin.x += textFieldInsets.x;
        newBounds.size.width -= textFieldInsets.x;
        
        newBounds.origin.y += (textFieldInsets.y + placeholderHeight);
        newBounds.size.height -= (textFieldInsets.y + placeholderHeight + errorHeight + lineNTextYSpacing);
        return newBounds
    }
    
    open override var intrinsicContentSize : CGSize {
        return CGSize(width:bounds.width, height:fixedIntrinsicHeight() + errorIntrinsicHeight())
    }
    
    fileprivate func fixedIntrinsicHeight() -> CGFloat {
        return self.font!.lineHeight + 2*textFieldInsets.y + placeholderHeight + lineNTextYSpacing
    }
    
    fileprivate func errorIntrinsicHeight() -> CGFloat {
        return primitiveHasError ? (2*errorInsets.y + errorFontFromFont(self.font!).lineHeight) : 0.0;
    }
    
    //MARK: - Keyboard Handling -
    open var hasAccessoryView: Bool = true {
        didSet {
            if hasAccessoryView {
                if inputAccessoryView == nil {
                    inputAccessoryView = inputAccessoryBar()
                }
            } else {
                inputAccessoryView = nil
            }
        }
    }
    
    open var nextTextField:UITextField? {
        didSet {
            if hasAccessoryView && nextTextField != nil {
                inputAccessoryView = inputAccessoryBar()
            }
        }
    }
    
    open var previousTextField:UITextField? {
        didSet {
            if hasAccessoryView && previousTextField != nil {
                inputAccessoryView = inputAccessoryBar()
            }
        }
    }
    
    fileprivate func inputAccessoryBar() -> UIToolbar {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.tintColor = UIColor.peacockBlue()
        var barItems = [UIBarButtonItem]()
        
        if nextTextField != nil || previousTextField != nil {//previousTextField and nextTextField reserved for the future use
            let activeAttributes = [NSAttributedString.Key.foregroundColor:UIColor.peacockBlue() as Any]
            let disabledAttributes = [NSAttributedString.Key.foregroundColor:UIColor.textPlaceholder() as Any]
            
            let previous = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(MyTextField.previousBarItemTapped))
            previous.setTitleTextAttributes(previousTextField == nil ? disabledAttributes : activeAttributes, for: UIControl.State())
            barItems.append(previous)
            
            let next = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(MyTextField.nextBarItemTapped))
            next.setTitleTextAttributes(nextTextField == nil ? disabledAttributes : activeAttributes, for: UIControl.State())
            barItems.append(next)
        }
        
        barItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(MyTextField.doneBarItemTapped))
        barItems.append(done)
        toolbar.setItems(barItems, animated: false)
        
        return toolbar
    }
    
    @objc func nextBarItemTapped() {
        if let textField = nextTextField {
            textField.becomeFirstResponder()
        }
    }
    
    @objc func previousBarItemTapped() {
        if let textField = previousTextField {
            textField.becomeFirstResponder()
        }
    }
    
    @objc func doneBarItemTapped() {
        resignFirstResponder()
    }
}

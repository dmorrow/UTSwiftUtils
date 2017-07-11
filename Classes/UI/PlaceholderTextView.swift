//
//  PlaceholderTextView.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 12/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9, *)
open class PlaceholderTextView: UITextView {
    
    open let placeholderLabel: UILabel = UILabel()
    
    open var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.attributedText = attributedPlaceholder
        }
    }
    
    override open var contentInset: UIEdgeInsets {
        didSet {
            updateLabelConstraints()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateLabelConstraints()
        }
    }
    
    private var placeholderLeadingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var placeholderTrailingConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var placeholderTopConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        placeholderLeadingConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        placeholderTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor)
        placeholderTrailingConstraint = placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        placeholderLeadingConstraint.isActive = true
        placeholderTrailingConstraint.isActive = true
        placeholderTopConstraint.isActive = true
    }
    
    private func updateLabelConstraints() {
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
        placeholderLeadingConstraint.constant = textContainerInset.left + textContainer.lineFragmentPadding
        placeholderTopConstraint.constant = textContainerInset.top
        placeholderTrailingConstraint.constant = -(textContainerInset.right + textContainer.lineFragmentPadding)
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLabelConstraints()
    }
    
    open override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    
}

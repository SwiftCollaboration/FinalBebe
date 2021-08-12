//
//  ChatCollectionViewCell.swift
//  BebeLogin
//
//  Created by 이도희 on 2021/08/08.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var cvMessage: UIView!
    
    var containerViewWidthAnchor: NSLayoutConstraint?
    var containerViewRightAnchor: NSLayoutConstraint?
    var containerViewRightTestAnchor: NSLayoutConstraint?
    var containerViewLeftAnchor: NSLayoutConstraint?
    var containerViewHeightAnchor: NSLayoutConstraint?
    var textLabelHeightAnchor: NSLayoutConstraint?
    
    func setUITraits() {
        cvMessage.layer.cornerRadius = 10

        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
    }
    
    func setAnchors() {
        
        let messageWidth = frame.width - measuredFrameHeightForEachMessage(lblMessage.text!).width
        
        cvMessage.translatesAutoresizingMaskIntoConstraints = false
        cvMessage.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerViewLeftAnchor = cvMessage.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
        containerViewRightAnchor = cvMessage.rightAnchor.constraint(equalTo: rightAnchor, constant: -50)
        containerViewRightTestAnchor = cvMessage.rightAnchor.constraint(equalTo: leftAnchor, constant: messageWidth)
        containerViewWidthAnchor = cvMessage.widthAnchor.constraint(equalToConstant: 200)
        containerViewHeightAnchor = cvMessage.heightAnchor.constraint(equalToConstant: frame.height)
        containerViewWidthAnchor?.isActive = true
        containerViewHeightAnchor?.isActive = true
        
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        lblMessage.leftAnchor.constraint(equalTo: cvMessage.leftAnchor, constant: 10).isActive = true
        lblMessage.rightAnchor.constraint(equalTo: cvMessage.rightAnchor, constant: 10).isActive = true
        textLabelHeightAnchor = lblMessage.heightAnchor.constraint(equalToConstant: frame.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAnchors()
        setUITraits()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func measuredFrameHeightForEachMessage(_ message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        let height = measuredFrameHeightForEachMessage(lblMessage.text!).height + 50    // 말풍선의 높이
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
        newFrame.size.height = height
        containerViewHeightAnchor?.constant = height
        textLabelHeightAnchor?.constant = height
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}

//
//  MessageInputView.swift
//  pochi
//
//  Created by akiho on 2017/02/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import NextGrowingTextView
import RxSwift
import RxCocoa

class MessageInputView: UIView {
    
    private static let HEIGHT: CGFloat = 48
    private static let MAX_LINE: Int = 5
    
    @IBOutlet weak var textView: NextGrowingTextView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    private var initTextViewHeight: CGFloat = 0
    private var currentTextViewHeight: CGFloat = 0
    
    var observeSendBtn: Driver<Void> {
        return sendBtn.rx.tap.asDriver()
    }
    
    var observeMediaBtn: Driver<Void> {
        return cameraBtn.rx.tap.asDriver()
    }
    
    class func instance() -> MessageInputView {
        let view = R.nib.messageInputView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height - MessageInputView.HEIGHT,
            width: UIScreen.main.bounds.width,
            height: MessageInputView.HEIGHT)
        
        return view
    }
    
    func setup() {
        initTextViewHeight = textView.frame.size.height
        currentTextViewHeight = initTextViewHeight
        textView.inputView?.backgroundColor = UIColor.backgroundColor()
        
        sendBtn.isEnabled = false
        
        textView.maxNumberOfLines = MessageInputView.MAX_LINE + 1
        
        textView.delegates.willChangeHeight = { height in
            let diff: CGFloat = height - self.currentTextViewHeight
            self.frame = CGRect(
                x: 0,
                y: self.frame.origin.y - diff,
                width: UIScreen.main.bounds.width,
                height: self.frame.size.height + diff)
            
            self.currentTextViewHeight = height
        }
        
        textView.delegates.shouldChangeTextInRange = { (range: NSRange, replacementText: String) -> Bool in
            let currentLine = Int(floor(self.textView.contentSize.height / self.textView.font!.lineHeight))
            return currentLine <= MessageInputView.MAX_LINE
        }
        
        textView.delegates.textViewDidChange = { _ in
            self.toggleActiveSendBtn()
        }
    }
    
    private func toggleActiveSendBtn() {
        if textView.text.isEmpty {
            sendBtn.setTitleColor(UIColor.cancelGrayColor(), for: .normal)
            sendBtn.isEnabled = false
        } else {
            sendBtn.setTitleColor(UIColor.activeColor(), for: .normal)
            sendBtn.isEnabled = true
        }
    }
    
    func reset() {
        textView.text = ""
        currentTextViewHeight = initTextViewHeight
        
        frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height - MessageInputView.HEIGHT,
            width: UIScreen.main.bounds.width,
            height: MessageInputView.HEIGHT)
        
        textView.frame = CGRect(
            x: textView.frame.origin.x,
            y: textView.frame.origin.y,
            width: textView.frame.size.width,
            height: initTextViewHeight)
    }
}

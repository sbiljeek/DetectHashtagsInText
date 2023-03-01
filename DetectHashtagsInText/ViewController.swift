//
//  ViewController.swift
//  DetectHashtagsInText
//
//  Created by Salman Biljeek on 3/1/23.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        let textView: UITextView = {
            let textView = UITextView()
            textView.isSelectable = true
            textView.delegate = self
            textView.text = "This is a UITextView containing multiple hashtags. #Clicking a #hashtag will call a function where you can handle additional actions such as opening the hashtag page."
            textView.font = .systemFont(ofSize: 18)
            textView.textColor = .label.withAlphaComponent(0.7)
            textView.textAlignment = .left
            textView.backgroundColor = .clear
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.textContainerInset = .zero
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainer.lineBreakMode = .byTruncatingTail
            return textView
        }()
        
        textView.detectHashtags()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if url.absoluteString.contains("hash:") {
            let hashtag = String(url.absoluteString.dropFirst(5).lowercased())
            let vc = HashtagViewController(hashtag: hashtag)
            self.navigationController?.pushViewController(vc, animated: true)
            return true
        }
        return false
    }
}

extension UITextView {
    func detectHashtags() {
        let nsText: NSString = self.text as NSString
        let nsTxt = nsText.replacingOccurrences(of: "\\n", with: " ")
        let nsString = nsTxt.replacingOccurrences(of: "\n", with: " ")
        let paragraphStyle = self.typingAttributes[NSAttributedString.Key.paragraphStyle] ?? NSMutableParagraphStyle()
        let attrs = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.font!.pointSize),
            NSAttributedString.Key.foregroundColor: self.textColor as Any
        ] as [NSAttributedString.Key : Any]
        let attrString = NSMutableAttributedString(string: nsText as String, attributes: attrs)
        
        do {
            let hashtagRegexString = "[#]\\w\\S*\\b"
            let hashtagRegex = try NSRegularExpression(pattern: hashtagRegexString, options: [])
            
            let hashtagMatches = hashtagRegex.matches(in: nsString, options: [], range: NSRange(location: 0, length: nsString.utf16.count))
            
            for match in hashtagMatches {
                guard let range = Range(match.range, in: nsString) else { continue }
                let hash = nsString[range]
                let hashString = String(hash).dropFirst()
                let matchRange: NSRange = NSRange(range, in: nsString)
                attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(hashString)", range: matchRange)
                attrString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: self.font!.pointSize), range: matchRange)
            }
        } catch {
            print(error)
        }
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.link
        ]
        self.linkTextAttributes = linkAttributes
        
        self.attributedText = attrString
    }
}


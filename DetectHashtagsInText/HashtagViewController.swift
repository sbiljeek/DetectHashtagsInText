//
//  HashtagViewController.swift
//  DetectHashtagsInText
//
//  Created by Salman Biljeek on 3/1/23.
//

import UIKit

class HashtagViewController: UIViewController {
    
    init(hashtag: String) {
        self.hashtag = hashtag
        super.init(nibName: nil, bundle: nil)
    }
    
    var hashtag: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "#\(self.hashtag)"
        
        let label: UILabel = {
            let label = UILabel()
            label.text = "Hashtag Controller"
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            label.font = .systemFont(ofSize: 22)
            return label
        }()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

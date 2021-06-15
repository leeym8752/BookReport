//
//  DetailViewController.swift
//  BookReport
//
//  Created by 이예민 on 2021/06/16.
//

import UIKit

class DetailViewController: UIViewController {
    
    var bookInfo: Book?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var bookPublisherLabel: UILabel!
    
    @IBOutlet weak var bookCoverImage: UIImageView!
    
    @IBOutlet weak var bookDescLabel: UILabel!
    
    @IBOutlet weak var addWishBookButton: UIButton!
    
    @IBOutlet weak var addAlreadyBookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        
    }
    
    func updateUI() {
        if let bookInfo = bookInfo {
            bookTitleLabel.text = bookInfo.title.htmlEscaped
            bookAuthorLabel.text = bookInfo.author.htmlEscaped
            bookDescLabel.text = bookInfo.description.htmlEscaped
            bookDescLabel.lineBreakStrategy = .hangulWordPriority
            bookPublisherLabel.text = bookInfo.publisher.htmlEscaped
            
            addWishBookButton.layer.borderWidth = 1
            addWishBookButton.layer.borderColor = UIColor.systemBlue.cgColor
            addWishBookButton.layer.cornerRadius = 5
            
            addAlreadyBookButton.layer.borderWidth = 1
            addAlreadyBookButton.layer.borderColor = UIColor.systemBlue.cgColor
            addAlreadyBookButton.layer.cornerRadius = 5
            
            let url = URL(string: bookInfo.thumbnailPath)!
            bookCoverImage.kf.setImage(with: url)
        }
    }
}

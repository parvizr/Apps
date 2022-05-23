//
//  ViewController.swift
//  facebookfeed1
//
//  Created by javad on 18.02.22.
//

import UIKit

let cellID = "cellID"

class Post{
    var name: String?
    var statusText: String?
    var profileImageName: String?
    var statusImageName: String?
    var numLikes: Int?
    var numComments: Int?
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postMark = Post()
        postMark.name = "Mark Zuckerberg"
        postMark.statusText = "Meanwhile, beast turned to the dark side. Let's extend a bit more this text in order to see whether the textview will be extended or not. I want to write here a bit more, because this text is very less."
        postMark.numLikes = 400
        postMark.numComments = 123
        
        let postSteve = Post()
        postSteve.name = "Steve Jobs"
        postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
        "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying me we've done something wonderful, that's what matters to me.\n\n " +
            "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
        postSteve.profileImageName = "steve_profile"
        postSteve.statusImageName = "steve_status"
        postSteve.numLikes = 1000
        postSteve.numComments = 55
        
        let postGandhi = Post()
        postGandhi.name = "Mahatma Gandi"
        postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" +
            "The weak can never forgive. Forgiveness is the attribute of the strong.\n" +
            "Happiness is when what you think, what you say, and what you do are in harmony. Let's extend a bit more this text in order to see whether the textview will be extended or not."
        postGandhi.profileImageName = "gandhi_profile"
        postGandhi.statusImageName = "gandhi_status"
        postGandhi.numLikes = 333
        postGandhi.numComments = 22
       
        posts.append(postMark)
        posts.append(postSteve)
        posts.append(postGandhi)
        
        navigationItem.title = "Facebook Feed"
        
        collectionView.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FeedCell
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        return feedCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 500)
    }
    
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    var statusImageView: UIImageView?
    
    func animateImageview(statusImageView: UIImageView) {
        
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.backgroundColor = .black
            blackBackgroundView.frame = self.view.frame
            view.addSubview(blackBackgroundView)
            blackBackgroundView.alpha = 0
            
            if let keyWindow = UIApplication.shared.keyWindow {
                navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 45)
                navBarCoverView.backgroundColor = .black
                navBarCoverView.alpha = 0
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = .black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.clipsToBounds = true
            zoomImageView.frame = startingFrame
            view.addSubview(zoomImageView)
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y =  self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
            }, completion: nil)
        }
    }
    
    @objc func zoomOut() {
        
        if let startingFrame = statusImageView?.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75) {
                self.zoomImageView.frame = startingFrame
                self.navBarCoverView.alpha = 0
                self.blackBackgroundView.alpha = 0
                self.tabBarCoverView.alpha = 0
            } completion: { (didComplete) in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            }
        }
    }
}

class FeedCell: UICollectionViewCell, UITextViewDelegate {
    
    var feedController: FeedController?
    
    @objc func animate() {
        feedController?.animateImageview(statusImageView: statusImageView)
    }

    var post: Post? {
        didSet {
            if let name = post?.name{
                
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedText.append(NSAttributedString(string: "\nDecember 18 • San Francisco • ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor (red: 155/255, green: 161/255, blue: 171/255, alpha: 1)]))
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "globe_small")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                attributedText.append(NSAttributedString(attachment: attachment))
                
                nameLabel.attributedText = attributedText
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                
            }
            
            if let statusText = post?.statusText{
                statusTextView.text = statusText
                statusTextView.layoutIfNeeded()
                statusTextView.heightAnchor.constraint(equalToConstant: statusTextView.intrinsicContentSize.height).isActive = true
            }
            
            if let profileImageName = post?.profileImageName{
                profileImageView.image = UIImage(named: profileImageName)
            }
            
            if let statusImageName = post?.statusImageName{
                statusImageView.image = UIImage(named: statusImageName)
            }
        }
      
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        statusTextView.delegate = self
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
       
       
        return label} ()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "488 Likes   10.7K Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.init(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 226/255, green: 228/255, blue: 232/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Like", for: .normal)
        button.setTitleColor(UIColor(red: 143/255, green: 150/255, blue: 163/255, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let commentbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Comment", for: .normal)
        button.setTitleColor(UIColor(red: 143/255, green: 150/255, blue: 163/255, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(UIColor(red: 143/255, green: 150/255, blue: 163/255, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentbutton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
                
        NSLayoutConstraint.activate([

            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            profileImageView.heightAnchor.constraint(equalToConstant: 44),
            profileImageView.widthAnchor.constraint(equalToConstant: 44),
            statusTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 1),
            statusTextView.leftAnchor.constraint(equalTo: leftAnchor),
            statusTextView.rightAnchor.constraint(equalTo: rightAnchor),
//            statusTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            statusImageView.topAnchor.constraint(equalTo: statusTextView.bottomAnchor, constant: 1),
            statusImageView.heightAnchor.constraint(equalToConstant: 200),
            statusImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            statusImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            statusImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            likesCommentsLabel.topAnchor.constraint(equalTo: statusImageView.bottomAnchor, constant: 1),
            likesCommentsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            likesCommentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dividerLineView.topAnchor.constraint(equalTo: likesCommentsLabel.bottomAnchor, constant: -4),
            dividerLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dividerLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dividerLineView.heightAnchor.constraint(equalToConstant: 0.4),
            
            //button constraints
            likeButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 120),
//            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
          

            commentbutton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor, constant: 4),
            commentbutton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor),
            commentbutton.widthAnchor.constraint(equalToConstant: 120),
//            commentbutton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareButton.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor, constant: 4),
            shareButton.leadingAnchor.constraint(equalTo: commentbutton.trailingAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 120),
//            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor)


        ])
        


    }
}

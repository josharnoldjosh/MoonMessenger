//
//  ConvoViewController.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/11/21.
//

import Foundation
import UIKit
import SwiftUI
import Preview
import SnapKit


struct ConvoItem : Hashable {
    var id:UUID
    var username:String
    var image:UIImage
    var lastMessageDate:Date
    var lastMessageText:String
}


final class ConvoCell : UICollectionViewCell {
    
    var imageView:UIImageView!
    var username:UILabel!
    var text:UILabel!
    var time:UILabel!
    var line:UIView!
    let inset:CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        snap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        imageView = UIImageView()
        imageView.backgroundColor = .darkShadow
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (ConvoList.rowHeight - (inset*2)) / 2
        contentView.addSubview(imageView)
                
        username = UILabel()
        username.textColor = .white
        contentView.addSubview(username)
        
        text = UILabel()
        text.textColor = .white
        text.alpha = 0.5
        contentView.addSubview(text)
        
        time = UILabel()
        time.textColor = .white
        time.alpha = 0.25
        contentView.addSubview(time)
        
        line = UIView()
        line.backgroundColor = .darkShadow
        contentView.addSubview(line)
    }
            
    func snap() {
        imageView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(inset)
            make.width.equalTo(ConvoList.rowHeight - (CGFloat(inset) * CGFloat(2)))
        }
        
        username.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(inset)
            make.left.equalTo(imageView.snp.right).offset(inset)
            make.height.lessThanOrEqualToSuperview()
            make.right.equalToSuperview().inset(30)
        }
        
        text.snp.makeConstraints { make in
            make.top.equalTo(self.username.snp.bottom).offset(5)
            make.left.equalTo(imageView.snp.right).offset(inset)
            make.height.lessThanOrEqualToSuperview()
            make.right.equalToSuperview().inset(30)
        }
                
        time.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(inset)
            make.right.equalToSuperview().inset(inset)
            make.width.lessThanOrEqualToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalTo(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(3)
        }
        
    }
    
    func applyData(item:ConvoItem) {
        imageView.image = item.image
        username.attributedText = NSAttributedString(
            string: item.username,
            attributes: [.kern : 3, .font : UIFont.body]
        )
        text.attributedText = NSAttributedString(
            string: item.lastMessageText,
            attributes: [.font : UIFont.caption]
        )
        time.attributedText = NSAttributedString(
            string: "5m",
            attributes: [.font : UIFont.caption]
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        imageView.layer.cornerRadius = imageView.frame.height / 2
    }
}


final class ConvoList : UIView, UICollectionViewDelegate {
            
    static let rowHeight:CGFloat = 90
    private var collectionView:UICollectionView!
    private var data:UICollectionViewDiffableDataSource<Int, ConvoItem>!
    private var action: (_ convo:ConvoItem) -> ()?
    
    init(convoDidTap: @escaping (_ convo:ConvoItem) -> ()) {
        self.action = convoDidTap
        super.init(frame: .zero)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        addSubview(collectionView)
        
        collectionView.register(ConvoCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        data = UICollectionViewDiffableDataSource<Int, ConvoItem>.init(collectionView: collectionView, cellProvider: { collectionView, indexPath, convoItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let cell = cell as? ConvoCell {
                cell.applyData(item: convoItem)
            }
            return cell
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refresh() {
        var snap = data.snapshot()
        if snap.sectionIdentifiers.count == 0 {
            snap.appendSections([0])
        }
        guard snap.itemIdentifiers.count < 2 else {return}
        snap.appendItems([
            ConvoItem(id: UUID(), username: "Naruto", image: UIImage(named: "Naruto") ?? UIImage(), lastMessageDate: Date(), lastMessageText: "Hey! How's it going?"),
            ConvoItem(id: UUID(), username: "Kakashi", image: UIImage(named: "Kakashi") ?? UIImage(), lastMessageDate: Date(), lastMessageText: "Hello world. This is a message..."),
        ])
        print(snap.itemIdentifiers.count)
        data.apply(snap)
    }
    
    private func getLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(ConvoList.rowHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    //TODO: Add touch down animation
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
    }
    
    //TODO: UNDO touch down animation
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let convo = data.snapshot().itemIdentifiers[indexPath.row]
        self.action(convo)
    }
}



final class ConvoViewController : UIViewController {
    
    let logo = UIImageView(image: UIImage(named: "Moon") ?? UIImage())
    
    var newConvo:ImageButton!
    var profile:ImageButton!
    var settings:ImageButton!
    
    var convoList:ConvoList!
            
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hero.isEnabled = true
        view.backgroundColor = .background
        setupUI()
        snap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        convoList.refresh()
    }
    
    func setupUI() {
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)
        
        convoList = ConvoList() { convo in
            let vc = MessagesViewController(convo: convo)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        view.addSubview(convoList)
        
        newConvo = ImageButton(imageNames: ["ButtonCircleA", "ButtonCircleC"], onTap: {
            
        })
        view.addSubview(newConvo)
        
        profile = ImageButton(imageNames: ["UserA", "UserB"], onTap: {
            
        })
        view.addSubview(profile)
        
        settings = ImageButton(imageNames: ["SettingsA", "SettingsB"], onTap: {
            
        })
        view.addSubview(settings)
    }
    
    func snap() {
        logo.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        newConvo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.width.height.equalTo(120)
        }
        
        settings.snp.makeConstraints { make in
            make.left.equalTo(self.newConvo.snp.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.width.height.equalTo(120)
        }
        
        profile.snp.makeConstraints { make in
            make.right.equalTo(self.newConvo.snp.left)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.width.height.equalTo(120)
        }
        
        convoList.snp.makeConstraints { make in
            make.top.equalTo(self.logo.snp.bottom).offset(20)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.newConvo.snp.top)
        }
    }
}



@available(iOS 13.0, *)
struct ConvoViewControllerContentView_Previews : PreviewProvider {
    static var previews : some View {
        Group {
            Preview.make(ConvoViewController())
        }
    }
}


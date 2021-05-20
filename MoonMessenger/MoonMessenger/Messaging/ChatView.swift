//
//  ChatView.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/3/21.
//

import UIKit
import SnapKit


struct ElementKind  {
    static let avatar = "avatar-element-kind"
    static let seen = "seen-element-kind"
    static let date = "date-element-kind"
}


final class ChatView : UIView, UIScrollViewDelegate {
    
    var style:ChatStyle!
    var collectionView:UICollectionView!
    var data:UICollectionViewDiffableDataSource<Section, Message>!
    
    var didScroll: ((_ offset:CGPoint) -> ())?
        
    init(style:ChatStyle = ChatStyle(), frame:CGRect = .zero) {
        super.init(frame: frame)
        self.style = style
        self.setupUI()
        self.setupData()
        self.clear()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //TODO: Fix bug where messages size doesn't automatically update unless I scroll..?
        DispatchQueue.main.async {
            self.data.apply(self.data.snapshot(), animatingDifferences: true)
        }
    }
        
    func setupUI() {
        backgroundColor = .systemBackground
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: getLayout())
        registerSupplementaryViews()
        registerCells()
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func registerCells() {
        // Outgoing
        collectionView.register(OutgoingBubbleCell.self, forCellWithReuseIdentifier: "Outgoing")
        collectionView.register(OutgoingTop.self, forCellWithReuseIdentifier: "OutgoingTop")
        collectionView.register(OutgoingMiddle.self, forCellWithReuseIdentifier: "OutgoingMiddle")
        collectionView.register(OutgoingBottom.self, forCellWithReuseIdentifier: "OutgoingBottom")
        // Incoming
        collectionView.register(IncomingBubbleCell.self, forCellWithReuseIdentifier: "Incoming")
        collectionView.register(IncomingTop.self, forCellWithReuseIdentifier: "IncomingTop")
        collectionView.register(IncomingMiddle.self, forCellWithReuseIdentifier: "IncomingMiddle")
        collectionView.register(IncomingBottom.self, forCellWithReuseIdentifier: "IncomingBottom")
    }
    
    func registerSupplementaryViews() {
        // "Date" Header
        collectionView.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeader.reuseIdentifier)
        
        // Empty Header, a.k.a, nothing
        collectionView.register(EmptyHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyHeader.reuseIdentifier)
        
        // Avatar
        collectionView.register(AvatarBadge.self, forSupplementaryViewOfKind: ElementKind.avatar, withReuseIdentifier: AvatarBadge.reuseIdentifier)
        
        // Empty avatar
        collectionView.register(EmptyAvatar.self, forSupplementaryViewOfKind: ElementKind.avatar, withReuseIdentifier: EmptyAvatar.reuseIdentifier)
        
        // Seen
        collectionView.register(SeenBadge.self, forSupplementaryViewOfKind: ElementKind.seen, withReuseIdentifier: SeenBadge.reuseIdentifier)
        
        // Empty Seen
        collectionView.register(EmptySeenBadge.self, forSupplementaryViewOfKind: ElementKind.seen, withReuseIdentifier: EmptySeenBadge.reuseIdentifier)
    }
    
    func getLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem.init(layoutSize: size, supplementaryItems: [makeAvatar(), makeSeen()])
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection.init(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: style.avatar.showIncomingAvatar ? style.avatar.scale : 0,
            bottom: 0,
            trailing: style.seen.enableSeen ? style.seen.scale : 0)
        section.interGroupSpacing = self.style.layout.sameMessageSpacing
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = self.style.layout.uniqueMessageSpacing
        section.boundarySupplementaryItems = [makeDateHeader()]
        return UICollectionViewCompositionalLayout.init(section: section, configuration: config)
    }
    
    func makeDateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(10)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    func makeAvatar() -> NSCollectionLayoutSupplementaryItem {
        let anchor = NSCollectionLayoutAnchor(edges: [.bottom, .leading], fractionalOffset: CGPoint(x: -0.75, y: 0))
        let scale = style.avatar.scale
        let size = NSCollectionLayoutSize(widthDimension: .absolute(scale), heightDimension: .absolute(scale))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: ElementKind.avatar, containerAnchor: anchor)
        return badge
    }
    
    func makeSeen() -> NSCollectionLayoutSupplementaryItem {
        let anchor = NSCollectionLayoutAnchor(edges: [.bottom, .trailing], fractionalOffset: CGPoint(x: 0.75, y: 0))
        let scale = style.seen.scale
        let size = NSCollectionLayoutSize(widthDimension: .absolute(scale), heightDimension: .absolute(scale))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: size, elementKind: ElementKind.seen, containerAnchor: anchor)
        return badge
    }
    
    func setupData() {
        setupMessageBubbleData()
        setupSupplementaryViews()
    }
    
    func setupMessageBubbleData() {
        data = UICollectionViewDiffableDataSource<Section, Message>.init(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, message) -> UICollectionViewCell? in
                                                                                                
            var cell:BubbleCell!
                                                            
            if message.origin == .outgoing {
                guard let outgoing = collectionView.dequeueReusableCell(withReuseIdentifier: "Outgoing", for: indexPath) as? BubbleCell else {return nil}
                if message.corners == Rounding.top {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutgoingTop", for: indexPath) as? BubbleCell
                }else if message.corners == Rounding.middle {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutgoingMiddle", for: indexPath) as? BubbleCell
                }else if message.corners == Rounding.bottom {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutgoingBottom", for: indexPath) as? BubbleCell
                }else {
                    cell = outgoing
                }
                cell.applyStyle(style: self.style.outgoing)
                
            }else if message.origin == .incoming {
                guard let incoming = collectionView.dequeueReusableCell(withReuseIdentifier: "Incoming", for: indexPath) as? BubbleCell else {return nil}
                if message.corners == Rounding.top {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IncomingTop", for: indexPath) as? BubbleCell
                }else if message.corners == Rounding.middle {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IncomingMiddle", for: indexPath) as? BubbleCell
                }else if message.corners == Rounding.bottom {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IncomingBottom", for: indexPath) as? BubbleCell
                }else {
                    cell = incoming
                }
                cell.applyStyle(style: self.style.incoming)
            }else{
                return nil
            }
            
            cell.text = message.text
            cell.message = message
            return cell
        })
    }
    
    func setupSupplementaryViews() {                        
        data.supplementaryViewProvider = { collectionView, kind, indexPath in
                        
            if kind == UICollectionView.elementKindSectionHeader {
                return DateStampBuilder(data: self.data, style: self.style).build(collectionView: collectionView, kind: kind, indexPath: indexPath)
            }
            
            if kind == ElementKind.avatar {
                return AvatarBadgeBuilder(data: self.data, style: self.style).build(collectionView: collectionView, indexPath: indexPath)
            }
            
            if kind == ElementKind.seen {
                return SeenBadgeBuilder(data: self.data, style: self.style).build(collectionView: collectionView, indexPath: indexPath)
            }
            return nil
        }
    }
    }


/**
 * Update the gradient background.
 */
extension ChatView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in self.collectionView.visibleCells {
            guard let cell = cell as? BubbleCell else {continue}
            cell.updateGradient()
        }
        self.didScroll?(self.collectionView.contentOffset)
    }        
}


/**
 * Public API functions
 */
extension ChatView {    
    
    /**
     * Removes all messages from the ChatView.
     */
    public func clear() {
        let data = NSDiffableDataSourceSnapshot<Section, Message>()
        self.data.apply(data)
    }
        
    /**
     * Appends messages to the ChatView.
     */
    public func addMessages(_ messages:[Message], scrollToBottom:Bool = true, animate:Bool = true) {
        var snap = self.data.snapshot()
        let builder = DataBuilder(data: snap)
        snap = builder.build(messages: messages)        
        self.data.apply(snap, animatingDifferences: animate)
                
        if scrollToBottom {
            self.scrollToBottom(animated: animate)
        }
    }
    
    /**
     * Scrolls to the bottom/most recent message in the ChatView.
     */
    public func scrollToBottom(animated:Bool = true) {
        guard self.data.snapshot().sectionIdentifiers.count > 0 else {return}
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            let lastSection = self.collectionView.numberOfSections - 1
            let lastRow = self.collectionView.numberOfItems(inSection: lastSection)
            let indexPath = IndexPath(row: lastRow - 1, section: lastSection)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
    }
    
    /**
     * Updates the style of the ChatView.
     */
    public func updateStyle(style:ChatStyle = ChatStyle()) {
        self.style = style
        self.data.apply(self.data.snapshot())        
    }
    
    
    /**
     * Toggle's the visibility of the typing indicator.
     */
    public func setTypingIndicator(visible:Bool = true) {
        //TODO: Implement Typing Indicator!
    }
    
    /**
     * TODO: Add closures for "reached bottom" & "reached top" ?
     */
}

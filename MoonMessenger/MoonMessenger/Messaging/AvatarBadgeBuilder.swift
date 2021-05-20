//
//  AvatarBadgeBuilder.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 4/18/21.
//


import UIKit


final class AvatarBadgeBuilder {
    
    var style:ChatStyle!
    var data:UICollectionViewDiffableDataSource<Section, Message>!
        
    init(data:UICollectionViewDiffableDataSource<Section, Message>, style:ChatStyle) {
        self.data = data
        self.style = style
    }
    
    func build(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionReusableView? {
        if getCell(collectionView: collectionView, indexPath: indexPath) != nil && style.avatar.showIncomingAvatar && !isNotLastIncoming(collectionView: collectionView, indexPath: indexPath) {
            let avatar = collectionView.dequeueReusableSupplementaryView(ofKind: ElementKind.avatar, withReuseIdentifier: AvatarBadge.reuseIdentifier, for: indexPath) as? AvatarBadge
            if let message = getCell(collectionView: collectionView, indexPath: indexPath)?.message {
                avatar?.setAvatar(message: message, style: style)
            }
            return avatar
        }
        
        let empty = collectionView.dequeueReusableSupplementaryView(ofKind: ElementKind.avatar, withReuseIdentifier: EmptyAvatar.reuseIdentifier, for: indexPath) as? EmptyAvatar
        return empty
    }
    
    func getCell(collectionView:UICollectionView, indexPath:IndexPath) -> IncomingBubbleCell? {
        guard let cell = self.data.collectionView(collectionView, cellForItemAt: indexPath) as? IncomingBubbleCell else {return nil}
        return cell
    }
    
    func isNotLastIncoming(collectionView:UICollectionView, indexPath:IndexPath) -> Bool {
        guard let cell = self.data.collectionView(collectionView, cellForItemAt: indexPath) as? IncomingBubbleCell else {return false}
        let snap = self.data.snapshot()
        let idx = snap.indexOfItem(cell.message!)!
        let next = snap.itemIdentifiers.index(after: idx)        
        if next == snap.itemIdentifiers.count {
            return false
        }
        let finalMessage = snap.itemIdentifiers[next]
        return finalMessage.origin == .incoming
    }
}

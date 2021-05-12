//
//  SeenBadgeBuilder.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 4/18/21.
//

import UIKit


final class SeenBadgeBuilder {
    
    var style:ChatStyle!
    var data:UICollectionViewDiffableDataSource<Section, Message>!
        
    init(data:UICollectionViewDiffableDataSource<Section, Message>, style:ChatStyle) {
        self.data = data
        self.style = style
    }
    
    func build(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionReusableView? {
        if let message = getMessage(collectionView: collectionView, indexPath: indexPath) {
            if message.seen && isLastSeenMessage(check: message) {
                let seenView = collectionView.dequeueReusableSupplementaryView(ofKind: ElementKind.seen, withReuseIdentifier: SeenBadge.reuseIdentifier, for: indexPath) as? SeenBadge
                seenView?.updateStyle(style: self.style)
                return seenView
            }
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: ElementKind.seen, withReuseIdentifier: EmptySeenBadge.reuseIdentifier, for: indexPath) as? EmptySeenBadge        
    }
    
    func getMessage(collectionView:UICollectionView, indexPath:IndexPath) -> Message? {
        guard let cell = self.data.collectionView(collectionView, cellForItemAt: indexPath) as? BubbleCell else {return nil}
        return cell.message
    }
    
    func isLastSeenMessage(check:Message) -> Bool {
        if let id = self.data.snapshot().itemIdentifiers.filter({$0.seen == true}).last?.id {
            return id == check.id
        }
        return false
    }
}

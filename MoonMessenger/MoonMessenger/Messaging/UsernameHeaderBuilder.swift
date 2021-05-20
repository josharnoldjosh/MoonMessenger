//
//  UsernameHeaderBuilder.swift
//  MoonMessenger
//
//  Created by Josh Arnold on 5/20/21.
//

import UIKit


final class UsernameHeaderBuilder {
    
    var style:ChatStyle!
    var data:UICollectionViewDiffableDataSource<Section, Message>!
        
    init(data:UICollectionViewDiffableDataSource<Section, Message>, style:ChatStyle) {
        self.data = data
        self.style = style
    }
    
    func build(collectionView:UICollectionView, kind:String, indexPath:IndexPath) -> UICollectionReusableView? {
                        
        // If current cell is outgoing! Ignore all
        if let cell = getCell(collectionView: collectionView, indexPath: indexPath) {
                                    
            if cell.message?.origin == .incoming {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UsernameHeader.reuseIdentifier, for: indexPath) as? UsernameHeader
                print(cell.message)
                view?.setText(cell.message?.username ?? "User", style: self.style)
                return view
            }
        }
                                        
        // Else return empty
        let empty = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyUsernameHeader.reuseIdentifier, for: indexPath) as? EmptyUsernameHeader
        return empty
    }
        
    func getCell(collectionView:UICollectionView, indexPath:IndexPath) -> BubbleCell? {
        guard let cell = self.data.collectionView(collectionView, cellForItemAt: indexPath) as? BubbleCell else {return nil}
        return cell
    }
        
    /// Returns (prev, current) dates
    func getMessages(collectionView:UICollectionView, indexPath:IndexPath) -> (Message, Message)? {
        guard let cell = self.data.collectionView(collectionView, cellForItemAt: indexPath) as? BubbleCell else {return nil}
        let snap = self.data.snapshot()
        let idx = snap.indexOfItem(cell.message!)!
        let prev = snap.itemIdentifiers.index(before: idx)
        if prev < 0 {
            return nil
        }
        let finalMessage = snap.itemIdentifiers[prev]
        return (finalMessage, cell.message!)
    }
}

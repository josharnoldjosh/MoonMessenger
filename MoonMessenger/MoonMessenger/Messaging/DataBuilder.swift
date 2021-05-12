//
//  DataBuilder.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/8/21.
//

import UIKit


final class DataBuilder {
    
    var data:NSDiffableDataSourceSnapshot<Section, Message>
    var messages:[Message] = []
    
    init(data:NSDiffableDataSourceSnapshot<Section, Message>) {
        self.messages += data.itemIdentifiers
        self.data = data
    }
    
    func atLeastOneMessageIsSeen(messages:[Message]) -> Bool {
        return !messages.filter({$0.seen == true}).isEmpty
    }

    func lastSeenIdx() -> UUID {
        return self.messages.filter({ $0.seen == true }).last?.id ?? UUID()
    }
    
    //TODO: Based on date spacing, maybe start a new section instead of continuing a bubble...
    func build(messages:[Message]) -> NSDiffableDataSourceSnapshot<Section, Message> {
                                         
        self.messages += messages
        
        // We update the last message to seen if necesscary
        // Only if the new messages have a "seen" message
        if (atLeastOneMessageIsSeen(messages: messages)) {
            let lastIdx = lastSeenIdx()
            self.messages = self.messages.map({
                if $0.id == lastIdx {
                    return $0.changing(change: {$0.seen = true})
                }
                return $0.changing(change: {$0.seen = false})
            })
            print(self.messages.filter({$0.seen == true}).count)
        }

        for i in 0...self.messages.count-1 {
            
            if i < self.data.itemIdentifiers.count {
                continue
            }
                                    
            if data.sectionIdentifiers.last?.origin == self.messages[i].origin && i >= 1 && (self.delta(A: self.messages[i-1].date, B: self.messages[i].date) <= 2) {
                
                // Update previous message's rounding from basic -> top
                if count(data.sectionIdentifiers.last!) == 1 {
                    
                    data.deleteItems([data.itemIdentifiers.last!])
                                        
                    data.appendItems([self.messages[i-1].changing {$0.corners = .top}], toSection: data.sectionIdentifiers.last)
                
                // Update previous messages' rounding from bottom -> middle
                } else {
                    data.deleteItems([data.itemIdentifiers.last!])
                    data.appendItems([self.messages[i-1].changing {$0.corners = .middle}], toSection: data.sectionIdentifiers.last)
                }
                
                // Add bottom rounding
                let m = self.messages[i].changing {$0.corners = .bottom}
                data.appendItems([m], toSection: data.sectionIdentifiers.last)
                
            }else{
                
                // Init as basic type first
                let m = self.messages[i].changing {$0.corners = .basic}
                data.appendSections([Section(origin: m.origin)])
                data.appendItems([m], toSection: data.sectionIdentifiers.last)
            }
        }
        
        return self.data
    }
    
    func count(_ section:Section) -> Int {
        return self.data.itemIdentifiers(inSection: section).count
    }
    
    func delta(A:Date, B:Date) -> Int {        
        if let days = Calendar.current.dateComponents([.hour], from: A, to: B).hour {
            return abs(days)
        }
        return 0
    }
}

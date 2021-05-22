//
//  DateStampBuilder.swift
//  SnapKitTest
//
//  Created by Josh Arnold on 1/8/21.
//

import UIKit


final class DateStampBuilder {
    
    var style:ChatStyle!
    var data:UICollectionViewDiffableDataSource<Section, Message>!
        
    init(data:UICollectionViewDiffableDataSource<Section, Message>, style:ChatStyle) {
        self.data = data
        self.style = style
    }
    
    func build(collectionView:UICollectionView, kind:String, indexPath:IndexPath) -> UICollectionReusableView? {
        
        guard kind == UICollectionView.elementKindSectionHeader else {return nil}
                                        
        if let (prev, current) = self.getMessages(collectionView: collectionView, indexPath: indexPath) { // Compare current bubble & previous bubble..?
            let delta = self.delta(A: prev.date, B: current.date)
            if delta >= 1 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DateHeader.reuseIdentifier, for: indexPath) as? DateHeader
                view?.setText(current.date.relativeTime, style: self.style)
                return view
            }
        }else if let cell = self.getCell(collectionView: collectionView, indexPath: indexPath) { // First message bubble
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DateHeader.reuseIdentifier, for: indexPath) as? DateHeader
            view?.setText(cell.message!.date.relativeTime, style: self.style)
            return view
        }
         
        // Return no header
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: ElementKind.empty, withReuseIdentifier: EmptyHeader.reuseIdentifier, for: indexPath) as? EmptyHeader
        return nil
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
    
    /// Returns the delta between two dates
    func delta(A:Date, B:Date) -> Int {
        return abs(Calendar.current.dateComponents([.hour], from: A, to: B).hour!)
    }
}


//TODO: Update this relative time to be more similar to iMessage, etc
extension Date {
    
    var time:String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let hour = components.hour!
        let minute = components.minute!
        let dateAsString = String(hour) + ":" + String(minute)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
    }
    
    var yearsFromNow: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    var monthsFromNow: Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month!
    }
    
    var weeksFromNow: Int {
        return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear!
    }
    
    var daysFromNow: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
    
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    var hoursFromNow: Int {
        return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
    }
    
    var minutesFromNow: Int {
        return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
    }
    
    var secondsFromNow: Int {
        return Calendar.current.dateComponents([.second], from: self, to: Date()).second!
    }
    
    var dayOfWeek:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
        
    var shortDate: String  { localizedDescription(dateStyle: .short,  timeStyle: .none) }
    
    var relativeTime: String {
        
        if minutesFromNow == 0 {
            return "Just now"
        }
        
        if hoursFromNow < 1 {
            return "\(self.minutesFromNow)m ago"
        }
        
        if hoursFromNow <= 48 {
            if isInYesterday {
                return "YESTERDAY " + self.time
            }
            return self.time
        }
        
        if daysFromNow <= 7 {
            return self.dayOfWeek + " " + self.time
        }
        
        return self.shortDate + " " + self.time
    }
}


extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}

extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                           in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}

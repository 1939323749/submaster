//
//  Item.swift
//  submaster
//
//  Created by mba on 2023/10/20.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Subscribe {
    var id: UUID
    var name:String
    var desc:String
    var fee:String
    var createTime: Date
    var startTime:Date
    var endTime:Date
    var isAutomaticallyRenew:Bool
    
    @Relationship(deleteRule:.nullify,inverse: \Tag.subs)
    var tags:[Tag]
    
    init(name: String, desc: String, fee: String, createTime: Date=Date.now, startTime: Date=Date.now, endTime: Date=Calendar.current.date(byAdding: .month, value: 1, to: Date.now)!, isAutomaticallyRenew: Bool=false, tags: [Tag]=[]) {
        self.id = UUID()
        self.name = name
        self.desc = desc
        self.fee = fee
        self.createTime = createTime
        self.startTime = startTime
        self.endTime = endTime
        self.isAutomaticallyRenew = isAutomaticallyRenew
        self.tags = tags
    }
}

@Model
final class Tag{
    var id:UUID
    var name:String
    var desc:String
    
    var subs:[Subscribe]
    
    init(name: String, desc: String, subs: [Subscribe]) {
        self.id = UUID()
        self.name = name
        self.desc = desc
        self.subs = subs
    }
}

@Model
final class Profile{
    var id: UUID
    var name: String
    var avatar:Data?
    var subs:[Subscribe]
    
    init(name: String="default", subs: [Subscribe]=[]) {
        self.id = UUID()
        self.name = name
        self.subs = subs
    }
}

@Model
final class Setting{
    var currentProfile:Profile
    var aMonthDays:Int
    var currencyType:String
    var subQuanInMainScreen:Int
    var showSubsOrder:String
    var showBudgetCard:Bool
    var budget:Double
    
    init(currentProfile: Profile=Profile(name: "default", subs: []), aMonthDays: Int = 31, currencyType: String = "¥", subQuanInMainScreen: Int = 5, showSubsOrder: String = "newer",showBudgetCard:Bool=true,budget:Double=100.0) {
        self.currentProfile = currentProfile
        self.aMonthDays = aMonthDays
        self.currencyType = currencyType
        self.subQuanInMainScreen = subQuanInMainScreen
        self.showSubsOrder = showSubsOrder
        self.showBudgetCard = showBudgetCard
        self.budget = budget
    }
}

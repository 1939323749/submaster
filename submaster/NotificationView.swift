//
//  NotificationView.swift
//  submaster
//
//  Created by mba on 2023/10/22.
//

import SwiftUI
import SwiftData

struct NotificationView: View {
    @Binding var isPresented:Bool
    @Query var subscribes:[Subscribe]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationSplitView{
            VStack{
                if subscribes.count==0{
                    VStack{
                        Spacer()
                        Text("Notifiction is empty.")
                            .font(.footnote)
                        Spacer()
                    }
                }
                else {
                    List{
                        ForEach(subscribes){sub in
                            if isOverdue(sub: sub){
                                HStack{
                                    Text("\(sub.name) had overdue at \(getPassedTime(sub:sub))")
                                }
                            }
                        }
                        .onDelete{indexSet in
                            for index in indexSet {
                                modelContext.delete(subscribes[index])
                            }
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement:.topBarTrailing){
                    Button(action:{
                        isPresented.toggle()
                    }){
                        Text("Read all")
                    }
                }
            }
        }detail: {
            Text("Notifigation")
        }
    }
    func isOverdue(sub:Subscribe)->Bool{
        if sub.isAutomaticallyRenew {
            return false
        }
        return sub.endTime<Date.now
    }
    
    func getPassedTime(sub: Subscribe) -> String {
        let currentTime = Date()
        let passedTimeInterval = currentTime.timeIntervalSince(sub.createTime)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour], from: sub.endTime, to: currentTime)
        
        var passedTime = ""
        if let days = components.day, days > 0 {
            passedTime += "\(days) day"
            if days > 1 {
                passedTime += "s"
            }
        } else if let hours = components.hour, hours > 0 {
            passedTime += "\(hours) hour"
            if hours > 1 {
                passedTime += "s"
            }
        } else {
            passedTime = "Less than an hour"
        }
        
        return passedTime + " ago"
    }
}

#Preview {
    @State var isPresented=false
    return NotificationView(isPresented: $isPresented)
}

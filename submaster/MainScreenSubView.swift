//
//  MainScreenSubView.swift
//  submaster
//
//  Created by mba on 2023/11/2.
//

import SwiftUI
import SwiftData

struct MainScreenSubView: View {
    var modelContext:ModelContext
    @Bindable var setting:Setting
    @State var sub:Subscribe
    @State var showAlert=false
    @Binding var isEditting:Bool
    var body: some View {
        ZStack(alignment: .topTrailing){
            Image(systemName: "ellipsis")
                .padding(.top,-5)
                .padding(.trailing,20)
                .onTapGesture {
                    showAlert.toggle()
                }
                .onLongPressGesture(perform: {
                    isEditting.toggle()
                })

                .alert(isPresented:$showAlert) {
                            Alert(
                                title: Text("Are you sure you want to delete this?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Delete")) {
                                    modelContext.delete(sub)
                                },
                                secondaryButton: .cancel()
                            )
                        }
            VStack{
                HStack{
                    VStack{
                        HStack{
                            Text(sub.name)
                                .font(.title)
                            if sub.isAutomaticallyRenew{
                                Image(systemName: "clock.arrow.2.circlepath")
                            }
                            Spacer()
                        }
                        HStack{
                            Text(setting.currencyType+sub.fee)
                            Spacer()
                        }
                    }
                    .padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("It will end in \(getRemainDays())")
                        .font(.footnote)
                        .padding(.leading)
                    Spacer()
                }
                ScrollView(.horizontal,showsIndicators: false){
                    HStack{
                        ForEach(sub.tags){tag in
                            HStack{
                                Text(tag.name)
                                    .padding(.all,8)
                            }
                            .background(Color.yellow.opacity(0.2))
                            .clipShape(.capsule)
                            .padding(.leading)
                        }
                    }
                    
                }
            }
            .padding(.top,-10)
        }
        .frame(width: 360,height:200)
        .background(Color.green.opacity(0.3))
        .clipShape(RoundedRectangle(cornerSize: CGSizeMake(25, 25), style: .circular))
        .padding()
        .popover(isPresented: $isEditting) {
            EditSubView(sub: sub, isEditting: $isEditting)
        }
    }
    
    private func getRemainDays()->String{
        let currentTime = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour], from: currentTime, to: sub.endTime)
        
        var remainTime = ""
        if let days = components.day, days > 0 {
            remainTime += "\(days) day"
            if days > 1 {
                remainTime += "s"
            }
        }
        return remainTime
    }
}

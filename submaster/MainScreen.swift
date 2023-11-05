//
//  MainScreen.swift
//  submaster
//
//  Created by mba on 2023/10/29.
//

import SwiftUI
import SwiftData
import Expression

struct MainScreen:View {
    @Environment(\.modelContext) private var modelContext
    @Query private var subs: [Subscribe]
    @Query private var tags:[Tag]
    @Query private var profiles:[Profile]
    @Query private var setting:[Setting]
    @State private var isNotificationPresented=false
    @State private var totalFee:String?
    @State private var used:Double=0.0
    @State private var isEditting=false
    var body: some View {
            NavigationSplitView{
                if setting.count>0{
                    VStack{
                        TabView{
                            ScrollView{
                                CardView(setting: setting[0],totalFee: $totalFee,total: $used)
                                    .task(id: setting[0].currentProfile) {
                                        getTotalFee()
                                    }
                                BudgetsView(used: $used, setting: setting[0])
                                ForEach(setting[0].currentProfile.subs.prefix(setting[0].subQuanInMainScreen)){sub in
                                    MainScreenSubView(modelContext: modelContext, setting: setting[0],sub: sub,isEditting: $isEditting)
                                }
                                Text("Already the buttom!")
                                    .font(.footnote)
                                    .foregroundStyle(Color.secondary)
                            }.tabItem{
                                Image(systemName:"star")
                                Text("Home")
                            }
                            .task(id: setting[0].showSubsOrder) {
                                setting[0].currentProfile.subs.reverse()
                            }
                            NewSubView(profile: setting[0].currentProfile).tabItem{
                                VStack{
                                    Image(systemName:"plus.circle")
                                }
                                .frame(width: 50,height: 50)
                                .background(Color.blue)
                                .foregroundStyle(Color.green)
                                .clipShape(Circle())
                            }
                            SettingView(modelContext: modelContext,setting: setting[0]).tabItem{
                                Image(systemName:"star")
                                Text("about")
                            }
                        }
                    }
                    .toolbar{
                        ToolbarItem(placement:.topBarLeading){
                            ProfileView(modelContext: modelContext,setting: setting[0])
                        }
                        ToolbarItem(placement:.topBarTrailing){
                            Button(action: {
                                isNotificationPresented.toggle()
                            }, label: {
                                Image(systemName: "bell")
                            })
                        }
                    }
                }
            }detail: {
                Text("")
            }
            .popover(isPresented: $isNotificationPresented){
                NotificationView(isPresented:$isNotificationPresented)
            }
            .task {
                if setting.count==0{
                    modelContext.insert(Setting())
                }
                if profiles.count==0{
                    modelContext.insert(Profile(name: "default", subs: []))
                }
            }
            .task(id: profiles, {
                if profiles.count==1{
                    setting[0].currentProfile=profiles[0]
                }
            })
            .task(id: isEditting) {
                getTotalFee()
            }
        }
    private func getTotalFee(){
        if setting.count>0{
            if setting[0].currentProfile.subs.count>0{
                var exp=""
                for sub in setting[0].currentProfile.subs {
                    exp+=sub.fee
                    exp+="+"
                }
                exp.removeLast()
                var result :Double = 0.0
                let expression = AnyExpression(exp)
                do {
                    result = try expression.evaluate()
                    used=result
                    if String(result).hasSuffix(".0"){
                        totalFee=String(result).replacingOccurrences(of: ".0", with: "")
                    }
                }catch{
                    print("error occurred")
                }
            }else{
                totalFee="0.0"
            }
        }

    }
}


struct CardView:View {
    @Bindable var setting:Setting
    @Binding var totalFee:String?
    @Binding var total:Double
    var body: some View {
        VStack{
            HStack{
                VStack{
                    Text("total")
                        .font(.title)
                        .padding(.top,12)
                    if let totalFee{
                        Text(setting.currencyType+totalFee)
                            .font(.largeTitle)
                            .padding()
                    }
                }
                Spacer()
            }
            HStack{
                Spacer()
                NavigationLink(
                    destination: PieChartView(total: $total, setting: setting),
                    label: {
                    VStack{
                        Text("analyse")
                    }})
                .padding()
                Spacer()
            }
            .frame(width:120,height: 48)
            .background(Color.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.bottom,24)
            Spacer()
        }
        .frame(width:360,height:200)
        .background(Color.green.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.top,24)
    }
}



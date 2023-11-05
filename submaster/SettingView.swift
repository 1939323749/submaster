//
//  SettingView.swift
//  submaster
//
//  Created by mba on 2023/11/2.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    var modelContext:ModelContext
    @State var isAddingProfile=false
    @State var newProfile:Profile?
    @State var alertQuantityInvalid=false
    @State var budgetText="100"
    
    @Bindable var setting:Setting
    
    var body: some View {
        List{
            Section("add profile"){
                NavigationLink("manage profiles"){
                    ProfilesListView(modelContext: modelContext)
                }
            }
            Section("manage tags"){
                NavigationLink("manage tags"){
                    TagsListView(modelContext: modelContext)
                }
            }
            Section("Budget"){
                TextField("budget",text: $budgetText)
            }
            .task(id: budgetText) {
                setting.budget=Double(budgetText) ?? 100.0
            }
            Section("settings"){
                Stepper("Now long is a month: \(setting.aMonthDays)",value: $setting.aMonthDays)
                Stepper("Show \(setting.subQuanInMainScreen) subs in main screen",value: $setting.subQuanInMainScreen)
                Picker("Currency", selection: $setting.currencyType){
                    Text("CNY¥").tag("¥")
                    Text("USD$").tag("$")
                }
                Picker("Sub order in mainscreen", selection: $setting.showSubsOrder){
                    Text("Newer").tag("newer")
                    Text("Older").tag("older")
                }
                Toggle(isOn: $setting.showBudgetCard) {
                    Text("Show budget card")
                }
            }
            .task(id: setting.subQuanInMainScreen) {
                if setting.subQuanInMainScreen<0{
                    alertQuantityInvalid.toggle()
                    setting.subQuanInMainScreen=0
                }
            }
            .alert(isPresented: $alertQuantityInvalid){
                Alert(
                    title: Text("Invalid quanlity"),
                    dismissButton: nil
                )
            }

        }
        .popover(isPresented: $isAddingProfile, content: {
            if let newProfile{
                NewProfileView(newProfile: newProfile , isAddingProfile: $isAddingProfile)
            }
        })
        .task(id: newProfile){
            if newProfile != nil{
                isAddingProfile.toggle()
            }
        }
    }
}

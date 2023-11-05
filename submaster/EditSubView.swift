//
//  EditSubView.swift
//  submaster
//
//  Created by mba on 2023/11/5.
//

import SwiftUI
import SwiftData

struct EditSubView: View {
    @Bindable var sub:Subscribe
    
    @Binding var isEditting:Bool
    
    @State var newGroup=""
    @State var tags:[SubTag]=[]
    @State var alertSuccess=false
    
    @FocusState var isEdittingName
    @FocusState var isEdittingDesc
    @FocusState var isEdittingFee
    @FocusState var isEdittingGroup
    
    @Query var subs:[Subscribe]
    @Query var alltags:[Tag]=[]
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationSplitView{
            List{
                Section("name"){
                    HStack{
                        TextEditor(text: $sub.name)
                            .focused($isEdittingName)
                        if isEdittingName{
                            Button(action:{
                                isEdittingName.toggle()
                            }){
                                Text("Done")
                            }
                        }
                    }
                }
                Section("description"){
                    HStack{
                        TextEditor(text: $sub.desc)
                            .focused($isEdittingDesc)
                        if isEdittingDesc{
                            Button(action:{
                                isEdittingDesc.toggle()
                                modelContext.insert(sub)
                            }){
                                Text("Done")
                            }
                        }
                    }
                }
                Section("fee"){
                    HStack{
                        TextEditor(text: $sub.fee)
                            .focused($isEdittingFee)
                        if isEdittingFee{
                            Button(action:{
                                isEdittingFee.toggle()
                            }){
                                Text("Done")
                            }
                        }
                    }
                }
                Section("auto renew"){
                    Toggle(isOn: $sub.isAutomaticallyRenew){
                        Text("Automatically renew")
                    }
                }
                Section("piriod"){
                    DatePicker(selection: $sub.startTime, in: ...Date.now, displayedComponents: .date){
                        Text("Start time")
                    }
                    DatePicker(selection: $sub.endTime, in: (Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date())..., displayedComponents: .date){
                        Text("End time")
                    }
                }
                Section("tags"){
                    ScrollView(.horizontal){
                        HStack(spacing:20){
                            ForEach(tags,id:\.self.id){tag in
                                tag
                            }
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement:.topBarTrailing){
                    Button(action:{
                        alertSuccess.toggle()
                        isEditting.toggle()
                    }){
                        Text("Done")
                    }
                }
            }
            .alert(isPresented: $alertSuccess){
                Alert(title: Text("Edit successfully"))
            }
        }detail: {
            Text("new sub")
        }
        .onAppear{
            tags=getSubTags(tags: alltags)
        }
    }
    
    func getSubTags(tags: [Tag]) -> [SubTag] {
        if tags.isEmpty {
            return []
        }
        
        var res: [SubTag] = []
        
        for tag in tags {
            var isChoosed=false
            if sub.tags.contains(tag){
                isChoosed.toggle()
            }
            res.append(SubTag(tag: tag, isChoosed: isChoosed, sub: sub))
        }
        
        return res
    }
}

//
//  NewSubView.swift
//  submaster
//
//  Created by mba on 2023/10/22.
//

import SwiftUI
import SwiftData

struct SubTag:View {
    var id=UUID()
    @State var tag:Tag
    @State var isChoosed:Bool
    
    @Bindable var sub:Subscribe
    
    var body: some View {
        VStack{
            HStack{
                if isChoosed{
                    Image(systemName:"minus.circle")
                }else{
                    Image(systemName: "plus.circle")
                }
                Text(tag.name)
            }
            .padding()
            .onTapGesture {
                isChoosed.toggle()
            }
        }
        .background(getColorScheme())
        .clipShape(Capsule())
        .onChange(of: isChoosed) {
            if isChoosed{
                sub.tags.append(tag)
            } else {
                if let index = sub.tags.firstIndex(of: tag) {
                    sub.tags.remove(at: index)
                }
            }
        }
    }
    private func getColorScheme()->Color{
        if isChoosed{
            return Color.green
        }
        return Color.white
    }
}

struct NewSubView: View {
    @Bindable var profile:Profile
    
    @State var newSub=Subscribe(name: "name", desc: "vip", fee: "20.0")
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
                        TextEditor(text: $newSub.name)
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
                        TextEditor(text: $newSub.desc)
                            .focused($isEdittingDesc)
                        if isEdittingDesc{
                            Button(action:{
                                isEdittingDesc.toggle()
                                modelContext.insert(newSub)
                            }){
                                Text("Done")
                            }
                        }
                    }
                }
                Section("fee"){
                    HStack{
                        TextEditor(text: $newSub.fee)
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
                    Toggle(isOn: $newSub.isAutomaticallyRenew){
                        Text("Automatically renew")
                    }
                }
                Section("piriod"){
                    DatePicker(selection: $newSub.startTime, in: ...Date.now, displayedComponents: .date){
                        Text("Start time")
                    }
                    DatePicker(selection: $newSub.endTime, in: (Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date())..., displayedComponents: .date){
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
                        if !newSub.name.elementsEqual("name"){
                            modelContext.insert(newSub)
                            profile.subs.append(newSub)
                            newSub=Subscribe(name: "name", desc: "vip", fee: "20.0")
                            alertSuccess.toggle()
                        }
                    }){
                        Text("Done")
                    }
                }
            }
            .alert(isPresented: $alertSuccess){
                Alert(title: Text("Add new subscription successfully"))
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
            if newSub.tags.contains(tag){
                isChoosed.toggle()
            }
            res.append(SubTag(tag: tag, isChoosed: isChoosed, sub: newSub))
        }
        
        return res
    }
}

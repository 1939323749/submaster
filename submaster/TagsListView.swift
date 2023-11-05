//
//  TagsView.swift
//  submaster
//
//  Created by mba on 2023/11/3.
//

import SwiftUI
import SwiftData

struct TagsListView: View {
    var modelContext:ModelContext
    @Query var tags:[Tag]
    @State var isAddingNewTag=false
    @State var newTag:Tag?
    @State var showDeleteAlert=false
    @State var tagToBeDeleted:Tag?
    @State var deleteTag=false
    var body: some View {
        List{
            ForEach(tags){tag in
                VStack{
                    Text(tag.name)
                    Text(tag.desc)
                }
            }
            .onDelete{indexSet in
                for index in indexSet{
                    if tags[index].subs.count==0{
                        modelContext.delete(tags[index])
                    }else{
                        showDeleteAlert.toggle()
                        tagToBeDeleted=tags[index]
                    }
                }
            }
            Button {
                newTag=Tag(name: "name", desc: "empty", subs: [])
            } label: {
                Text("Add a new tag")
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing, content: {
                EditButton()
            })
        }
        .alert(isPresented: $showDeleteAlert, content: {
            Alert(title: Text("these's some subs under this tag"), primaryButton: .destructive(Text("Delete"), action: {
                deleteTag.toggle()
            }), secondaryButton: .cancel())
        })
        .popover(isPresented: $isAddingNewTag, content: {
            if let newTag{
                NewTagView(isAddingNewTag: $isAddingNewTag, newTag: newTag)
            }
        })
        .task(id: newTag) {
            if newTag != nil{
                isAddingNewTag.toggle()
            }
        }
        .task(id: isAddingNewTag) {
            if let newTag{
                if !newTag.name.elementsEqual("name"){
                    modelContext.insert(newTag)
                }
            }
        }
        .task(id: deleteTag) {
            if let tagToBeDeleted{
                modelContext.delete(tagToBeDeleted)
            }
        }
    }
}

struct NewTagView:View {
    @Binding var isAddingNewTag:Bool
    @Bindable var newTag:Tag
    var body: some View {
        List{
            Section("name"){
                TextField("new tag name",text: $newTag.name)
            }
            Section("describe"){
                TextField("new tag describe",text: $newTag.desc)
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isAddingNewTag.toggle()
                } label: {
                    Text("Done")
                }
            }
        }
    }
}

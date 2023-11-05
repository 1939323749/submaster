//
//  ProfileView.swift
//  submaster
//
//  Created by mba on 2023/11/3.
//

import SwiftUI
import SwiftData

struct ProfileView:View {
    var modelContext : ModelContext
    @Bindable var setting:Setting
    
    @Query var profiles:[Profile]
    var body: some View {
        HStack{
            // click here to switch profile
            VStack{
                Menu(content:{
                    Picker("profile", selection: $setting.currentProfile) {
                        ForEach(profiles) { prof in
                            if let avatarData = prof.avatar {
                                Image(uiImage: UIImage(data: avatarData)!)
                                    .tag(prof)
                            } else {
                                Image(systemName: "person")
                                    .tag(prof)
                            }
                        }
                    }
                },label: {
                    if let avatar = setting.currentProfile.avatar{
                        Image(uiImage: UIImage(data: avatar)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.circle)
                            .frame(width: 42,height: 42)
                    }else{
                        Image(systemName: "person")
                    }
                }
                     )
            }

            VStack{
                HStack{
                    Text(setting.currentProfile.name)
                        .font(.footnote)
                        .foregroundStyle(LinearGradient(colors: [.green,.blue], startPoint: .leading, endPoint: .trailing))
                    Spacer()
                }
            }
        }
    }
}

struct ProfilesListView:View {
    var modelContext:ModelContext
    @Query var profiles:[Profile]
    @State var addNewProfile=false
    @State var newProfile:Profile?
    @State var alertProfileQuantity=false
    var body: some View {
        List{
            ForEach(profiles){profile in
                HStack{
                    Text(profile.name)
                    Spacer()
                    if let avatar=profile.avatar{
                        Image(uiImage: UIImage(data: avatar)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50,height: 50)
                            .clipShape(.circle)
                    }else{
                        Image(systemName: "person")
                    }
                }
            }
            .onDelete { indexSet in
                if profiles.count==1{
                    alertProfileQuantity.toggle()
                }else{
                    for index in indexSet{
                        modelContext.delete(profiles[index])
                    }
                }
            }
            Button("Add a new profile"){
                newProfile=Profile(name: "name", subs: [])
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .popover(isPresented: $addNewProfile) {
            if let newProfile{
                NewProfileView(newProfile: newProfile, isAddingProfile: $addNewProfile)
            }
        }
        .alert(isPresented: $alertProfileQuantity, content: {
            Alert(title: Text("Reserve at least one profile!"))
        })
        .task(id: newProfile) {
            if newProfile != nil{
                addNewProfile.toggle()
            }
        }
        .task(id: addNewProfile) {
            if let newProfile{
                if newProfile.name.elementsEqual("name"){
                    modelContext.insert(newProfile)
                }
            }
        }
    }
}

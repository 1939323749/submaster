//
//  NewProfileView.swift
//  submaster
//
//  Created by mba on 2023/10/22.
//

import SwiftUI
import PhotosUI

struct NewProfileView: View {
    @Bindable var newProfile:Profile
    @Binding var isAddingProfile:Bool
    @State var selectedImage:PhotosPickerItem?
    @State var selectedImageData:Data?
    @FocusState var isEdittingName
    var body: some View {
        NavigationSplitView{
            List{
                Section("avatar"){
                    PhotosPicker("choose an avatar(optitional)", selection: $selectedImage)
                }
                if let avatar = newProfile.avatar{
                    Image(uiImage: UIImage(data: avatar)!)
                        .resizable()
                        .frame(width: 300,height: 300)
                }
                Section("name"){
                    HStack{
                        TextField("name", text: $newProfile.name)
                            .focused($isEdittingName)
                        Button(action:{
                            isEdittingName.toggle()
                        }){
                            Text("Done")
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement:.topBarLeading){
                    Button(action:{
                        isAddingProfile.toggle()
                    }){
                        Text("Done")
                    }
                }
            }
            .task(id: selectedImage, {
                if let selectedImage{
                    selectedImageData=try? await selectedImage.loadTransferable(type: Data.self)
                    newProfile.avatar=selectedImageData
                }
            })
        }detail: {
            Text("new profile")
        }
    }
}

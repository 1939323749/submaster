//
//  BudgetsView.swift
//  submaster
//
//  Created by mba on 2023/11/2.
//

import SwiftUI

struct BudgetsView: View {
    @State var showAlert=false
    
    @Binding var used:Double
    @Bindable var setting:Setting
    var body: some View {
        if setting.showBudgetCard{
            ZStack(alignment: .topTrailing){
                Image(systemName: "ellipsis")
                    .padding([.top,.trailing],20)
                    .onTapGesture {
                        showAlert.toggle()
                    }
                    .alert(isPresented:$showAlert) {
                                Alert(
                                    title: Text("Are you sure you want to delete this?"),
                                    message: Text("There is no undo"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        setting.showBudgetCard.toggle()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                if setting.budget-used>0{
                    ProgressView(value: setting.budget-used,total: setting.budget) {
                                   Text("Budget")
                               } currentValueLabel: {
                                   HStack{
                                       Text("surplus: \(String(format: "%.2f",setting.budget-used))")
                                       Spacer()
                                       Text("Total: \(String(format: "%.2f", setting.budget))")
                                   }
                               }
                               .padding(.all,36)
                }
            }
            .frame(width: 360)
            .background(Color.green.opacity(0.3))
            .clipShape(RoundedRectangle(cornerSize: CGSizeMake(25, 25), style: .circular))
            .padding()
        }else{
            Spacer()
        }
        
    }
}

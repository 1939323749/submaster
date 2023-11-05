//
//  PieChartView.swift
//  submaster
//
//  Created by mba on 2023/11/5.
//

import SwiftUI
import SwiftData
import Charts
import Expression

struct PieChartView:View {
    @Query private var tags:[Tag]
    @Binding var total:Double
    @Bindable var setting:Setting
    @State private var selectedSector: String?
    @State private var selectedCount: Int?
    @State var coffeeSales :[(name:String,count:Double)]=[]
    var body: some View {
        VStack{
            HStack{
                yearAndMonth()
            }
            HStack{
                Spacer()
                VStack{
                    Text("Preview")
                        .font(.title)
                        .padding(.top,24)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            Spacer()
                            Text("Spend")
                            Text(String(format: "%.2f", total))
                            Spacer()
                        }
                        Spacer()
                        VStack{
                            Spacer()
                            Text("Daily average spend")
                            Text(String(format: "%.2f", total/Double(setting.aMonthDays)))
                            Spacer()
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .frame(width: 360,height: 240)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            HStack{
                Spacer()
                VStack{
                    if let count=selectedSector{
                        Text(count.description)
                            .font(.title)
                            .padding(.top,24)
                        Text(getSpend(name:count)!.description)
                            .font(.footnote)
                    }else{
                        Text("Tag")
                            .font(.title)
                            .padding(.top,24)
                    }
                    Chart {
                        ForEach(coffeeSales, id: \.name) { coffee in
                            SectorMark(
                                angle: .value("Cup", coffee.count),
                                innerRadius: .ratio(0.42),
                                angularInset: 2.0
                            )
                            .foregroundStyle(by: .value("Type", coffee.name))
                            .cornerRadius(10)
                            .opacity(selectedSector == nil ? 1.0 : (selectedSector == coffee.name ? 1.0 : 0.5))
                        }
                    }
                    .chartAngleSelection(value: $selectedCount)
                    .frame(height: 192)
                    .onChange(of: selectedCount) { oldValue, newValue in
                        if let newValue {
                            selectedSector = findSelectedSector(value: newValue)
                        } else {
                            selectedSector = nil
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .onAppear {
                getData()
            }
            .frame(width: 360,height: 300)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.top,12)
            Spacer()
        }
    }
    func findSelectedSector(value: Int) -> String? {
     
        var accumulatedCount = 0.0
     
        let coffee = coffeeSales.first { (_, count) in
            accumulatedCount += count
            return value <= Int(accumulatedCount)
        }
     
        return coffee?.name
    }
    func getSpend(name:String)->Double?{
        for subscription in coffeeSales {
                if subscription.name == name {
                    return subscription.count
                }
            }
            return nil
    }
    private func getData(){
        for tag in tags {
            var feeUnderTag=""
            for sub in tag.subs {
                feeUnderTag+=sub.fee
                feeUnderTag+="+"
            }
            var fee=0.0
            feeUnderTag.removeLast()
            do {
                let exp=AnyExpression(feeUnderTag)
                fee=try exp.evaluate()
            }catch{
                print("error")
            }
            coffeeSales.append((tag.name,fee))
        }
        
    }
}

struct yearAndMonth:View {
    var body: some View {
        Text(currentMonth)
            .font(.title)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }
        
    private var currentMonth: String {
        let date = Date()
        return dateFormatter.string(from: date)
    }
}

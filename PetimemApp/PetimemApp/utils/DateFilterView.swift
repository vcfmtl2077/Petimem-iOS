//
//  DateFilterView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct DateFilterView: View {
    @State var start: Date
    @State var end: Date
    var onSubmit:(Date,Date) -> ()
    var onClose: () -> ()
    var body: some View {
        VStack(spacing: 15){
          
            DatePicker("Start", selection: $start, displayedComponents: .date)
            DatePicker("End", selection: $end, displayedComponents: .date)
               
            HStack(spacing: 15){
                Button("Cancel"){
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button("Filter"){
                    onSubmit(start,end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.buttonAdd)
            }
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}

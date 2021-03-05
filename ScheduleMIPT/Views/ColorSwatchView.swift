//
//  ColorSwatchView.swift
//  ScheduleMIPT
//
//  Created by Яков Каюмов on 25.02.2021.
//  Copyright © 2021 Admin. All rights reserved.
//

import SwiftUI

struct ColorSwatchView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var selection: String
    
    let swatchesLight = ["SEM", "BOT", "LEC", "LAB", "RST"]
    
    let swatchesDark = ["SEM_TEXT", "BOT_TEXT", "LEC_TEXT", "LAB_TEXT", "RST_TEXT"]

    var body: some View {

        let swatches = colorScheme == .dark ? swatchesDark : swatchesLight

        let selectionSuffix = colorScheme == .dark ? "_TEXT" : ""
        
        let rows = [GridItem(.fixed(45))]
        
        LazyHGrid(rows: rows, alignment: .center, spacing: 0) {
            ForEach(swatches, id: \.self){ swatch in
                ZStack {
                    Circle()
                        .fill(Color(swatch))
                        .opacity(0.8)
                        .frame(width: 35, height: 35)
                        .padding(10)

                    if selection + selectionSuffix == swatch {
                        Circle()
                            .stroke(Color(swatch), lineWidth: 5)
                            .opacity(0.8)
                            .frame(width: 45, height: 45)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    selection = String(swatch.prefix(3))
                })
            }
        }
        .padding(10)
    }
}

struct ColorSwatchView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSwatchView(selection: .constant("SEM"))
            .preferredColorScheme(.light)
    }
}


//
//  ModalView.swift
//  3dPractical
//
//  Created by user215333 on 3/12/22.
//

import SwiftUI

struct ModalView: View {
    @Binding var isPresented: Bool
    @Binding var showsUserLocation: Bool
    var body: some View {
        VStack {
            Text("FILTERS")
                .padding()
            Toggle("Show user location", isOn: $showsUserLocation)
                .padding()
            Button("Go back") {
                isPresented = false
            }
        }
    }
}

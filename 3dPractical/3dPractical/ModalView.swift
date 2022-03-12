//
//  ModalView.swift
//  3dPractical
//
//  Created by user215333 on 3/12/22.
//

import SwiftUI

struct ModalView: View {
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            Text("MODAL VIEW")
                .padding()
            Button("Go back") {
                isPresented = false
            }
        }
    }
}

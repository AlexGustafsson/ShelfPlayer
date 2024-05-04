//
//  AudiobookUnavailableView.swift
//  Multiplatform
//
//  Created by Rasmus Krämer on 04.05.24.
//

import SwiftUI

struct AudiobookUnavailableView: View {
    var body: some View {
        ContentUnavailableView("error.unavailable.audiobook", systemImage: "book", description: Text("error.unavailable.text"))
    }
}

#Preview {
    AudiobookUnavailableView()
}

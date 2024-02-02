//
//  AuthorUnavailableView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 04.10.23.
//

import SwiftUI

struct AuthorUnavailableView: View {
    var body: some View {
        ContentUnavailableView("error.unavailable.author", systemImage: "person", description: Text("error.unavailable.text"))
    }
}

#Preview {
    AuthorUnavailableView()
}

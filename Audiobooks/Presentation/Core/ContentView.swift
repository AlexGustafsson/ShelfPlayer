//
//  ContentView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 16.09.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var state: Step = AudiobookshelfClient.shared.isAuthorized ? .sessionImport : .login
    
    var body: some View {
        switch state {
        case .login:
            LoginView() {
                state = .sessionImport
            }
        case .sessionImport:
            SessionsImportView() { success in
                if success {
                    state = .library
                } else {
                    state = .offline
                }
            }
        case .library:
            LibraryView()
        case .offline:
            Text("Offline")
        }
    }
}

// MARK: Helper

extension ContentView {
    enum Step {
        case login
        case sessionImport
        case library
        case offline
    }
}

#Preview {
    ContentView()
}

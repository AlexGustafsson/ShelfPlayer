//
//  LibrarySelectorModifier.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 06.10.23.
//

import SwiftUI
import ShelfPlayerKit

struct LibrarySelectModifier: ViewModifier {
    @Environment(\.libraries) var libraries
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(libraries) { library in
                            Button {
                                NotificationCenter.default.post(name: Library.changeLibraryNotification, object: nil, userInfo: [
                                    "libraryId": library.id,
                                ])
                            } label: {
                                Label(library.name, systemImage: library.type == .audiobooks ? "book" : "waveform")
                            }
                        }
                        
                        Divider()
                        
                        Button {
                            NotificationCenter.default.post(name: Library.changeLibraryNotification, object: nil, userInfo: [
                                "offline": true,
                            ])
                        } label: {
                            Label("offline.enable", systemImage: "network.slash")
                        }
                    } label: {
                        Label("tip.changeLibrary", systemImage: "books.vertical.fill")
                            .labelStyle(.iconOnly)
                    }
                }
            }
    }
}

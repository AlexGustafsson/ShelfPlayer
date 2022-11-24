//
//  DebugView.swift
//  Books
//
//  Created by Rasmus Krämer on 24.11.22.
//

import SwiftUI

struct DebugView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id, order: .reverse)]) private var cachedMediaProgresses: FetchedResults<CachedMediaProgress>
    @State private var search: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Button {
                    NotificationCenter.default.post(name: .logout, object: nil)
                } label: {
                    Text("Logout")
                }
                
                ForEach(cachedMediaProgresses.filter { progress in
                    if search == "" {
                        return true
                    }
                    
                    return progress.libraryItemId?.contains(search) ?? false
                }) { progress in
                    HStack {
                        Text(progress.libraryItemId!)
                        Divider()
                        Text(String(progress.progress))
                            .font(.caption)
                    }
                }
            }
            .searchable(text: $search)
        }
        .tabItem {
            Label("Debug", systemImage: "gear.circle.fill")
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}

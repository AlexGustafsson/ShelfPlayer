//
//  PodcastLibraryView.swift
//  Multiplatform
//
//  Created by Rasmus Krämer on 23.04.24.
//

import SwiftUI
import ShelfPlayerKit

internal struct PodcastLibraryPanel: View {
    @Environment(\.library) private var library
    
    @State private var search = ""
    @State private var lazyLoader = LazyLoadHelper<Podcast, String>.podcasts
    
    private var visible: [Podcast] {
        guard !search.isEmpty else {
            return lazyLoader.items
        }
        
        return lazyLoader.items.filter {
            $0.name.localizedCaseInsensitiveContains(search)
            || $0.author?.localizedCaseInsensitiveContains(search) ?? false
        }
    }
    
    var body: some View {
        Group {
            if lazyLoader.items.isEmpty {
                if lazyLoader.failed {
                    ErrorView()
                        .refreshable {
                            await lazyLoader.refresh()
                        }
                } else {
                    LoadingView()
                        .onAppear {
                            lazyLoader.initialLoad()
                        }
                        .refreshable {
                            await lazyLoader.refresh()
                        }
                }
            } else {
                ScrollView {
                    if visible.isEmpty && !lazyLoader.finished {
                        Button {
                            lazyLoader.didReachEndOfLoadedContent()
                        } label: {
                            Text("podcasts.loadMore")
                            
                            if lazyLoader.working {
                                ProgressIndicator()
                            }
                        }
                        .disabled(lazyLoader.working)
                        .padding(.top, 40)
                    }
                    
                    PodcastVGrid(podcasts: visible) {
                        if $0 == visible.last {
                            lazyLoader.didReachEndOfLoadedContent()
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .refreshable {
                    await lazyLoader.refresh()
                }
            }
        }
        .navigationTitle("panel.library")
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "search.podcasts")
        .modifier(NowPlaying.SafeAreaModifier())
        .modifier(AccountSheetToolbarModifier(requiredSize: .compact))
        .onAppear {
            lazyLoader.library = library
        }
        .onReceive(Search.shared.searchPublisher) { (library, search) in
            self.search = search
        }
    }
}

#Preview {
    PodcastLibraryPanel()
        .environment(NowPlaying.ViewModel())
}

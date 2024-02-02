//
//  PodcastLibraryView+Latest.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 07.10.23.
//

import SwiftUI
import SPBase

extension PodcastLibraryView {
    struct LatestEpisodesView: View {
        @Environment(\.libraryId) var libraryId
        
        @State var failed = false
        @State var episodes = [Episode]()
        
        var body: some View {
            NavigationStack {
                Group {
                    if failed {
                        ErrorView()
                    } else if episodes.isEmpty {
                        LoadingView()
                    } else {
                        List {
                            EpisodeList(episodes: episodes)
                                .modifier(NowPlayingBarSafeAreaModifier())
                        }
                        .listStyle(.plain)
                    }
                }
                .navigationTitle("title.latest")
                .task(fetchItems)
                .refreshable(action: fetchItems)
            }
            .modifier(NowPlayingBarModifier())
            .tabItem {
                Label("tab.latest", systemImage: "clock")
            }
        }
    }
}

extension PodcastLibraryView.LatestEpisodesView {
    @Sendable
    func fetchItems() {
        Task.detached {
            do {
                episodes = try await AudiobookshelfClient.shared.getEpisodes(limit: 20, libraryId: libraryId)
            } catch {
                failed = true
            }
        }
    }
}

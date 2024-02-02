//
//  PodcastLibraryView+Home.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 07.10.23.
//

import SwiftUI
import SPBase

extension PodcastLibraryView {
    struct ListenNowView: View {
        @Environment(\.libraryId) var libraryId: String
        
        @State var episodeRows = [EpisodeHomeRow]()
        @State var podcastRows = [PodcastHomeRow]()
        
        @State var failed = false
        
        var body: some View {
            NavigationStack {
                Group {
                    if episodeRows.isEmpty && podcastRows.isEmpty {
                        if failed {
                            ErrorView()
                        } else {
                            LoadingView()
                                .padding(.top, 50)
                                .task(fetchItems)
                        }
                    } else {
                        ScrollView {
                            VStack {
                                ForEach(episodeRows) { row in
                                    VStack(alignment: .leading) {
                                        RowTitle(title: row.label)
                                        
                                        if row.id == "continue-listening" {
                                            EpisodeFeaturedGrid(episodes: row.episodes)
                                        } else {
                                            EpisodeGrid(episodes: row.episodes)
                                        }
                                    }
                                }
                                
                                ForEach(podcastRows) { row in
                                    VStack(alignment: .leading) {
                                        RowTitle(title: row.label)
                                        PodcastHGrid(podcasts: row.podcasts)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("title.listenNow")
                .modifier(LibrarySelectorModifier())
                .modifier(NowPlayingBarSafeAreaModifier())
                .refreshable(action: fetchItems)
            }
            .modifier(NowPlayingBarModifier())
            .tabItem {
                Label("tab.home", systemImage: "waveform")
            }
        }
    }
}

extension PodcastLibraryView.ListenNowView {
    @Sendable
    func fetchItems() {
        Task.detached {
            do {
                (episodeRows, podcastRows) = try await AudiobookshelfClient.shared.getPodcastsHome(libraryId: libraryId)
            } catch {
                failed = true
            }
        }
    }
}

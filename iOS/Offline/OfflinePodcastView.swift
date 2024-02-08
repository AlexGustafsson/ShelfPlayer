//
//  OfflinePodcastView.swift
//  iOS
//
//  Created by Rasmus Krämer on 03.02.24.
//

import SwiftUI
import Defaults
import SPBase
import SPOffline
import SPOfflineExtended

struct OfflinePodcastView: View {
    @State private var episodeFilter = EpisodeSortFilter.Filter.all
    
    @Default(.episodesSort) private var episodesSort
    @Default(.episodesAscending) private var episodesAscending
    
    let podcast: Podcast
    @State var episodes: [Episode]
    
    var body: some View {
        List {
            ForEach(episodes) {
                EpisodeSingleList.EpisodeRow(episode: $0)
                    .modifier(SwipeActionsModifier(item: $0))
            }
        }
        .contentMargins(5)
        .listStyle(.plain)
        .navigationTitle(podcast.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EpisodeSortFilter(filter: $episodeFilter, sortOrder: $episodesSort, ascending: $episodesAscending)
            }
        }
        .modifier(NowPlayingBarSafeAreaModifier())
        .onReceive(NotificationCenter.default.publisher(for: PlayableItem.downloadStatusUpdatedNotification)) { _ in
            do {
                episodes = try OfflineManager.shared.getEpisodes(podcastId: podcast.id)
            } catch {}
        }
    }
}

#Preview {
    NavigationStack {
        OfflinePodcastView(podcast: .fixture, episodes: .init(repeating: [.fixture], count: 7))
    }
}

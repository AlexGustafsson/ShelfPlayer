//
//  EpisodeView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 08.10.23.
//

import SwiftUI
import ShelfPlayerKit

struct EpisodeView: View {
    @Environment(\.library) private var library
    @State private var viewModel: EpisodeViewModel
    
    init(_ episode: Episode) {
        _viewModel = .init(initialValue: .init(episode: episode))
    }
    
    var body: some View {
        ScrollView {
            Header()
            
            Description(description: viewModel.episode.description)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
            
            DisclosureGroup("timeline", isExpanded: $viewModel.sessionsVisible) {
                Timeline(item: viewModel.episode, sessions: viewModel.sessions)
                    .padding(.top, 8)
            }
            .disclosureGroupStyle(BetterDisclosureGroupStyle(horizontalLabelPadding: 20))
        }
        .ignoresSafeArea(edges: .top)
        .sensoryFeedback(.error, trigger: viewModel.errorNotify)
        .modifier(NowPlaying.SafeAreaModifier())
        .modifier(ToolbarModifier())
        .environment(viewModel)
        .onAppear {
            viewModel.library = library
        }
        .task {
            await viewModel.load()
        }
        .refreshable {
            await viewModel.load()
        }
        .userActivity("io.rfk.shelfplayer.episode") {
            $0.title = viewModel.episode.name
            $0.isEligibleForHandoff = true
            $0.persistentIdentifier = convertIdentifier(item: viewModel.episode)
            $0.targetContentIdentifier = convertIdentifier(item: viewModel.episode)
            $0.userInfo = [
                "libraryID": viewModel.episode.libraryID,
                "episodeID": viewModel.episode.id,
                "podcastID": viewModel.episode.podcastId,
            ]
            $0.webpageURL = viewModel.episode.url
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        EpisodeView(.fixture)
    }
    .environment(NowPlaying.ViewModel())
}
#endif

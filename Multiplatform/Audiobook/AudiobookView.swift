//
//  AudiobookView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 04.10.23.
//

import SwiftUI
import SPBase

struct AudiobookView: View {
    @Environment(\.libraryId) private var libraryId
    
    let viewModel: AudiobookViewModel
    
    init(audiobook: Audiobook) {
        viewModel = .init(audiobook: audiobook)
    }
    
    private let divider: some View = Divider()
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Header()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                
                divider
                
                Description(description: viewModel.audiobook.description)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                
                if let chapters = viewModel.chapters, chapters.count > 1 {
                    divider
                    
                    ChaptersList(chapters: chapters)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                }
                
                if viewModel.audiobooksInSeries.count > 1 {
                    divider
                    
                    VStack(alignment: .leading) {
                        RowTitle(title: String(localized: "audiobook.similar.series"))
                            .padding(.horizontal, 20)
                        AudiobookHGrid(audiobooks: viewModel.audiobooksInSeries, small: true)
                    }
                    .padding(.bottom, 20)
                }
                
                if viewModel.audiobooksByAuthor.count > 1, let author = viewModel.audiobook.author {
                    divider
                    
                    VStack(alignment: .leading) {
                        RowTitle(title: String(localized: "audiobook.similar.author \(author)"))
                            .padding(.horizontal, 20)
                        AudiobookHGrid(audiobooks: viewModel.audiobooksByAuthor, small: true)
                    }
                }
                
                Spacer()
            }
        }
        .modifier(NowPlaying.SafeAreaModifier())
        .modifier(ToolbarModifier())
        .environment(viewModel)
        .task { await viewModel.fetchData(libraryId: libraryId) }
        .userActivity("io.rfk.shelfplayer.audiobook") {
            $0.title = viewModel.audiobook.name
            $0.isEligibleForHandoff = true
            $0.persistentIdentifier = viewModel.audiobook.id
            $0.targetContentIdentifier = "audiobook:\(viewModel.audiobook.id)"
            $0.userInfo = [
                "audiobookId": viewModel.audiobook.id,
            ]
            $0.webpageURL = AudiobookshelfClient.shared.serverUrl.appending(path: "item").appending(path: viewModel.audiobook.id)
        }
    }
}

#Preview {
    NavigationStack {
        AudiobookView(audiobook: Audiobook.fixture)
    }
}

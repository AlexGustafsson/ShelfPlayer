//
//  NowPlayingSheet+Controls.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 10.10.23.
//

import SwiftUI
import AudiobooksKit

extension NowPlayingSheet {
    struct Title: View {
        let item: PlayableItem
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Group {
                        if let episode = item as? Episode, let formattedReleaseDate = episode.formattedReleaseDate {
                            Text(formattedReleaseDate)
                        } else if let audiobook = item as? Audiobook {
                            if let series = audiobook.series.audiobookSeriesName ?? audiobook.series.name {
                                Text(series)
                            }
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                    Text(item.name)
                        .lineLimit(1)
                        .font(.headline)
                        .fontDesign(item as? Audiobook != nil ? .serif : .default)
                        .foregroundStyle(.primary)
                    
                    if let author = item.author {
                        Text(author)
                            .lineLimit(1)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
        }
    }
}

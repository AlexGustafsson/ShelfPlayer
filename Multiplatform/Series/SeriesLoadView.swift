//
//  SeriesLoadView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 05.10.23.
//

import SwiftUI
import ShelfPlayerKit

internal struct SeriesLoadView: View {
    @Environment(\.libraryID) private var libraryId
    
    let series: Audiobook.ReducedSeries
    
    @State private var failed = false
    @State private var resolved: Series?
    
    var body: some View {
        if let resolved = resolved {
            SeriesView(resolved)
        } else if failed {
            SeriesUnavailableView()
                .refreshable {
                    await loadSeries()
                }
        } else {
            LoadingView()
                .task {
                    await loadSeries()
                }
        }
    }
    
    private nonisolated func loadSeries() async {
        var id = await series.id
        
        if id == nil {
            id = try? await AudiobookshelfClient.shared.seriesID(name: series.name, libraryId: libraryId)
        }
        
        guard let id else {
            return
        }
        
        guard let series = try? await AudiobookshelfClient.shared.series(seriesId: id, libraryId: libraryId) else {
            await MainActor.withAnimation {
                failed = true
            }
            
            return
        }
        
        await MainActor.withAnimation {
            self.resolved = series
        }
    }
}

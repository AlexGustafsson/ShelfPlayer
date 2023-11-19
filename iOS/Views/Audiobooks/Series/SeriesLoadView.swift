//
//  SeriesLoadView.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 05.10.23.
//

import SwiftUI
import AudiobooksKit

struct SeriesLoadView: View {
    @Environment(\.libraryId) var libraryId
    
    let seriesId: String
    
    @State var failed = false
    @State var series: Series?
    
    var body: some View {
        if failed {
            SeriesUnavailableView()
        } else if let series = series {
            SeriesView(series: series)
        } else {
            LoadingView()
                .task {
                    if let series = await AudiobookshelfClient.shared.getSeriesById(seriesId, libraryId: libraryId) {
                        self.series = series
                    } else {
                        failed = true
                    }
                }
        }
    }
}

#Preview {
    SeriesLoadView(seriesId: "fixture")
}

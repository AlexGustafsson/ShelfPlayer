//
//  EpisodeView+Toolbar.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 09.10.23.
//

import SwiftUI
import SPFoundation
import SPOffline
import SPOfflineExtended

internal extension EpisodeView {
    struct ToolbarModifier: ViewModifier {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        @Environment(EpisodeViewModel.self) private var viewModel
        
        private var isRegularPresentation: Bool {
            horizontalSizeClass == .regular
        }
        
        func body(content: Content) -> some View {
            content
                .navigationTitle(viewModel.episode.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(isRegularPresentation ? .automatic : viewModel.toolbarVisible ? .visible : .hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(!viewModel.toolbarVisible && !isRegularPresentation)
                .toolbar {
                    if !viewModel.toolbarVisible {
                        ToolbarItem(placement: .principal) {
                            Text(verbatim: "")
                        }
                        
                        if !isRegularPresentation {
                            ToolbarItem(placement: .navigation) {
                                FullscreenBackButton(isLight: viewModel.dominantColor?.isLight, isToolbarVisible: false)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        DownloadButton(item: viewModel.episode, downloadingLabel: false)
                            .labelStyle(.iconOnly)
                            .modifier(FullscreenToolbarModifier(isLight: viewModel.dominantColor?.isLight, isToolbarVisible: viewModel.toolbarVisible))
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Divider()
                            
                            Button(role: .destructive) {
                                viewModel.resetProgress()
                            } label: {
                                Label("progress.reset", systemImage: "xmark")
                            }
                        } label: {
                            Group {
                                if viewModel.progressEntity.progress >= 1 {
                                    Image(systemName: "minus")
                                } else {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .symbolVariant(.circle)
                            .modifier(FullscreenToolbarModifier(isLight: viewModel.dominantColor?.isLight, isToolbarVisible: viewModel.toolbarVisible))
                        } primaryAction: {
                            viewModel.toggleFinished()
                        }
                    }
                }
        }
    }
}

//
//  NowPlayingSheet+Controls.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 10.10.23.
//

import SwiftUI
import Defaults
import MediaPlayer
import ShelfPlayerKit
import SPPlayback

internal extension NowPlaying {
    struct Controls: View {
        @Environment(ViewModel.self) private var viewModel
        
        let compact: Bool
        
        var body: some View {
            VStack(spacing: 0) {
                ProgressSlider(compact: compact)
                ControlButtons(compact: compact)
                
                VolumeSlider(dragging: .init(get: { viewModel.volumeDragging }, set: { viewModel.volumeDragging = $0; viewModel.controlsDragging = $0 }))
                VolumePicker()
                    .hidden()
                    .frame(height: 0)
            }
        }
    }
}

private struct ProgressSlider: View {
    @Environment(NowPlaying.ViewModel.self) private var viewModel
    
    let compact: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            NowPlaying.Slider(percentage: .init(get: { viewModel.displayedProgress }, set: {
                if Defaults[.lockSeekBar] {
                    return
                }
                
                viewModel.setPosition(percentage: $0)
            }), dragging: .init(get: { viewModel.seekDragging }, set: { viewModel.seekDragging = $0; viewModel.controlsDragging = $0 }))
            .frame(height: 10)
            .padding(.bottom, compact ? 2 : 4)
            
            HStack(spacing: 0) {
                Group {
                    if viewModel.buffering {
                        ProgressView()
                            .scaleEffect(0.5)
                            .tint(.white)
                    } else {
                        Text(viewModel.chapterCurrentTime, format: .duration(unitsStyle: .positional, allowedUnits: [.hour, .minute, .second], maximumUnitCount: 3))
                    }
                }
                .frame(width: 64, alignment: .leading)
                
                Spacer()
                
                Group {
                    if viewModel.seekDragging {
                        Text(viewModel.played, format: .duration(unitsStyle: .abbreviated))
                    } else if let chapter = AudioPlayer.shared.chapter {
                        Text(chapter.title)
                            .animation(.easeInOut, value: chapter.title)
                    } else {
                        Text(viewModel.remaining, format: .duration(unitsStyle: .abbreviated))
                    }
                }
                .font(.caption2)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                .transition(.opacity)
                .padding(.vertical, compact ? 2 : 4)
                
                Spacer()
                
                Text(viewModel.chapterDuration, format: .duration(unitsStyle: .positional, allowedUnits: [.hour, .minute, .second], maximumUnitCount: 3))
                    .frame(width: 64, alignment: .trailing)
            }
            .font(.footnote.smallCaps())
            .foregroundStyle(.secondary)
        }
    }
}

private struct ControlButtons: View {
    @Environment(NowPlaying.ViewModel.self) private var viewModel
    
    let compact: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Label("playback.back", systemImage: "backward.fill")
                .labelStyle(.iconOnly)
                .symbolEffect(.bounce.up, value: viewModel.notifyBackwards)
                .font(.system(size: 32))
                .modifier(ButtonHoverEffectModifier())
                .gesture(TapGesture().onEnded { _ in
                    AudioPlayer.shared.skipBackwards()
                })
                .gesture(LongPressGesture().onEnded { _ in
                    if AudioPlayer.shared.chapter != nil {
                        AudioPlayer.shared.chapterCurrentTime = 0
                    }
                })
            
            Button {
                AudioPlayer.shared.playing.toggle()
            } label: {
                Label("playback.toggle", systemImage: viewModel.playing ? "pause.fill" : "play.fill")
                    .labelStyle(.iconOnly)
                    .contentTransition(.symbolEffect(.replace.byLayer.downUp))
            }
            .frame(width: 52, height: 52)
            .font(.system(size: 48))
            .modifier(ButtonHoverEffectModifier())
            .padding(.horizontal, 50)
            
            Label("playback.next", systemImage: "forward.fill")
                .labelStyle(.iconOnly)
                .symbolEffect(.bounce.up, value: viewModel.notifyForwards)
                .font(.system(size: 32))
                .modifier(ButtonHoverEffectModifier())
                .gesture(TapGesture().onEnded { _ in
                    AudioPlayer.shared.skipForwards()
                })
                .gesture(LongPressGesture().onEnded { _ in
                    if AudioPlayer.shared.chapter != nil {
                        AudioPlayer.shared.chapterCurrentTime = AudioPlayer.shared.chapterDuration
                    }
                })
        }
        .foregroundStyle(.primary)
        .padding(.top, compact ? 60 : 44)
        .padding(.bottom, compact ? 80 : 68)
    }
}

private struct VolumePicker: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: CGRect.zero)
        return volumeView
    }
    
    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}

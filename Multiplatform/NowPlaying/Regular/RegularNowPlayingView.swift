//
//  RegularNowPlayingView.swift
//  Multiplatform
//
//  Created by Rasmus Krämer on 23.04.24.
//

import SwiftUI
import SPBase
import SPPlayback

struct RegularNowPlayingView: View {
    @Namespace private var namespace
    @Environment(\.dismiss) var dismiss
    
    @State private var bookmarksActive = false
    @State private var controlsDragging = false
    @State private var availableWidth: CGFloat = .zero
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        availableWidth = proxy.size.width
                    }
                    .onChange(of: proxy.size.width) {
                        availableWidth = proxy.size.width
                    }
            }
            .frame(height: 0)
            
            if let item = AudioPlayer.shared.item {
                Rectangle()
                    .foregroundStyle(.background)
                
                VStack {
                    HStack(spacing: availableWidth < 1000 ? 20 : 80) {
                        VStack {
                            Spacer()
                            
                            ItemImage(image: item.image, aspectRatio: .none)
                                .shadow(radius: 15)
                                .padding(.vertical, 10)
                                .scaleEffect(AudioPlayer.shared.playing ? 1 : 0.8)
                                .animation(.spring(duration: 0.3, bounce: 0.6), value: AudioPlayer.shared.playing)
                            
                            Spacer()
                            
                            NowPlayingTitle(item: item, namespace: namespace)
                            NowPlayingControls(namespace: namespace, compact: true, controlsDragging: $controlsDragging)
                            
                        }
                        .frame(width: min(availableWidth / 2.25, 450))
                        
                        NowPlayingNotableMomentsView(includeHeader: false, bookmarksActive: $bookmarksActive)
                            .mask(
                                VStack(spacing: 0) {
                                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]), startPoint: .top, endPoint: .bottom)
                                        .frame(height: 40)
                                    
                                    Rectangle().fill(Color.black)
                                    
                                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                        .frame(height: 40)
                                }
                            )
                            .frame(maxWidth: .infinity)
                    }
                    
                    Buttons(notableMomentsToggled: $bookmarksActive)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 25, coordinateSpace: .global)
                        .onEnded {
                            if $0.translation.height > 200 {
                                dismiss()
                            }
                        }
                )
                .padding(.bottom, 20)
                .padding(.horizontal, 40)
                .padding(.top, 60)
                .ignoresSafeArea(edges: .all)
                .overlay(alignment: .top) {
                    Button {
                        dismiss()
                    } label: {
                        Rectangle()
                            .foregroundStyle(.gray.opacity(0.75))
                            .frame(width: 50, height: 7)
                            .clipShape(RoundedRectangle(cornerRadius: 10000))
                    }
                    .padding(.top, 35)
                }
            }
        }
    }
}

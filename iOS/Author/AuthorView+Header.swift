//
//  AuthorView+Header.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 06.10.23.
//

import SwiftUI
import SPBase

extension AuthorView {
    struct Header: View {
        let author: Author
        
        @State var descriptionSheetVisible = false
        
        var body: some View {
            VStack {
                ItemImage(image: author.image)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10000))
                
                Text(author.name)
                    .fontDesign(.serif)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                if let description = author.description {
                    Button {
                        descriptionSheetVisible.toggle()
                    } label: {
                        Text(description)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .lineLimit(3)
                            .sheet(isPresented: $descriptionSheetVisible) {
                                NavigationStack {
                                    Text(description)
                                        .navigationTitle(author.name)
                                        .padding(20)
                                    
                                    Spacer()
                                }
                                .presentationDragIndicator(.visible)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

//
//  AudiobookshelfClient+Util.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 03.10.23.
//

import Foundation

extension AudiobookshelfClient {
    struct AudiobookshelfHomeRow: Codable {
        let id: String
        let label: String
        let type: String
        let entities: [AudiobookshelfItem]
    }
    
    struct SearchResponse: Codable {
        let book: [SearchLibraryItem]?
        let podcast: [SearchLibraryItem]?
        // let narrators: [AudiobookshelfItem]
        let series: [SearchSeries]?
        let authors: [AudiobookshelfItem]?
        
        struct SearchLibraryItem: Codable {
            let matchKey: String
            let matchText: String
            let libraryItem: AudiobookshelfItem
        }
        struct SearchSeries: Codable {
            let series: AudiobookshelfItem
            let books: [AudiobookshelfItem]
        }
    }
    
    struct ResultResponse: Codable {
        let results: [AudiobookshelfItem]
    }
    
    struct EpisodesResponse: Codable {
        let episodes: [AudiobookshelfItem.AudiobookshelfPodcastEpisode]
    }
    
    public struct StatusResponse: Codable {
        public let isInit: Bool
        public let authMethods: [String]
        public let serverVersion: String
    }
    
    struct AuthorizationResponse: Codable {
        let user: User
        
        struct User: Codable {
            let id: String
            let token: String
            let username: String
            
            let mediaProgress: [MediaProgress]
        }
    }
    
    struct LibrariesResponse: Codable {
        let libraries: [Library]
        
        struct Library: Codable {
            let id: String
            let name: String
            let mediaType: String
            let displayOrder: Int
        }
    }
    
    struct AuthorsResponse: Codable {
        let authors: [AudiobookshelfItem]
    }
}

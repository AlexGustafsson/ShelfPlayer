//
//  AudiobookshelfClient.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 17.09.23.
//

import Foundation

public class AudiobookshelfClient {
    public private(set) var serverUrl: URL!
    public private(set) var token: String!
    
    public private(set) var clientVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    public private(set) var clientBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
    
    public private(set) var clientId: String
    
    #if DISABLE_APP_GROUP
    #warning("UserDefaults will not be stored in group container")
    static let defaults = UserDefaults.standard
    #else
    static let defaults = UserDefaults(suiteName: "group.io.rfk.shelfplayer")!
    #endif
    
    init(serverUrl: URL!, token: String!) {
        self.serverUrl = serverUrl
        self.token = token
        
        if let clientId = Self.defaults.string(forKey: "clientId") {
            self.clientId = clientId
        } else {
            clientId = String.random(length: 100)
            Self.defaults.set(clientId, forKey: "clientId")
        }
    }
}

public extension AudiobookshelfClient {
    var isAuthorized: Bool {
        self.token != nil
    }
    
    func setServerUrl(_ serverUrl: String) throws {
        guard let serverUrl = URL(string: serverUrl) else {
            throw AudiobookshelfClientError.invalidServerUrl
        }
        
        Self.defaults.set(serverUrl, forKey: "serverUrl")
        self.serverUrl = serverUrl
    }
    
    func setToken(_ token: String) {
        Self.defaults.set(token, forKey: "token")
        self.token = token
    }
    
    func logout() {
        Self.defaults.set(nil, forKey: "token")
        exit(0)
    }
}

enum AudiobookshelfClientError: Error {
    case invalidServerUrl
    case invalidHttpBody
    case invalidResponse
    case missing
}

extension AudiobookshelfClient {
    public static let shared = AudiobookshelfClient(serverUrl: defaults.url(forKey: "serverUrl"), token: defaults.string(forKey: "token"))
}

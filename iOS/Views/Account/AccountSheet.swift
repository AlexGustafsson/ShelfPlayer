//
//  AccountSheet.swift
//  Audiobooks
//
//  Created by Rasmus Krämer on 16.10.23.
//

import SwiftUI
import SPBaseKit
import SPOfflineKit
import SPOfflineExtendedKit

struct AccountSheet: View {
    @State var username: String?
    
    var body: some View {
        List {
            Section {
                if let username = username {
                    Text(username)
                } else {
                    ProgressView()
                        .onAppear {
                            Task.detached {
                                username = try? await AudiobookshelfClient.shared.getUsername()
                            }
                        }
                }
                Button(role: .destructive) {
                    OfflineManager.shared.deleteProgressEntities()
                    AudiobookshelfClient.shared.logout()
                } label: {
                    Text("account.logout")
                }
            } header: {
                Text("account.user")
            } footer: {
                Text("account.logout.disclaimer")
            }
            
            Section {
                Button {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } label: {
                    Text("account.settings")
                }
                
                Button(role: .destructive) {
                    OfflineManager.shared.deleteProgressEntities()
                    NotificationCenter.default.post(name: Library.libraryChangedNotification, object: nil, userInfo: [
                        "offline": false,
                    ])
                } label: {
                    Text("account.delete.cache")
                }
                Button(role: .destructive) {
                    OfflineManager.shared.deleteDownloads()
                } label: {
                    Text("account.delete.downloads")
                }
            }
            
            Group {
                Section("account.server") {
                    Text(AudiobookshelfClient.shared.token)
                    Text(AudiobookshelfClient.shared.serverUrl.absoluteString)
                }
                
                Section {
                    Text("account.version \(AudiobookshelfClient.shared.clientVersion) (\(AudiobookshelfClient.shared.clientBuild))")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            #if DEBUG
            Section {
                HStack {
                    Spacer()
                    Text("developedBy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            #endif
        }
    }
}

struct AccountSheetToolbarModifier: ViewModifier {
    @State var accountSheetPresented = false
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $accountSheetPresented) {
                AccountSheet()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        accountSheetPresented.toggle()
                    } label: {
                        Image(systemName: "server.rack")
                    }
                }
            }
    }
}

#Preview {
    Text(":)")
        .sheet(isPresented: .constant(true)) {
            AccountSheet()
        }
}

#Preview {
    NavigationStack {
        Text(":)")
            .modifier(AccountSheetToolbarModifier())
    }
}

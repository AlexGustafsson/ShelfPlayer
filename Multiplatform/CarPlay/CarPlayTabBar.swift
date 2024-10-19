//
//  CarPlayTabBar.swift
//  Multiplatform
//
//  Created by Rasmus Krämer on 18.10.24.
//

import Foundation
import CarPlay
import ShelfPlayerKit

internal final class CarPlayTabBar {
    private let interfaceController: CPInterfaceController
    private let offlineController: CarPlayOfflineController
    
    private var updateTask: Task<Void, Never>?
    private var libraries: [Library: LibraryTemplate]
    
    internal let template: CPTabBarTemplate
    
    init(interfaceController: CPInterfaceController) {
        self.interfaceController = interfaceController
        
        offlineController = .init(interfaceController: interfaceController)
        offlineController.template.tabImage = UIImage(systemName: "bookmark")
        offlineController.template.tabTitle = String(localized: "carPlay.offline.tab")
        
        updateTask = nil
        libraries = [:]
        
        template = .init(templates: [offlineController.template])
        
        updateTemplates()
        print("ddd")
    }
    
    protocol LibraryTemplate {
        var template: CPListTemplate { get }
    }
}

private extension CarPlayTabBar {
    func updateTemplates() {
        updateTask?.cancel()
        updateTask = .detached {
            guard let libraries = try? await AudiobookshelfClient.shared.libraries() else {
                return
            }
            
            var templates: [CPTemplate] = [self.offlineController.template]
            
            for library in libraries {
                if library.type == .audiobooks {
                    let controller = CarPlayAudiobookLibraryController(interfaceController: self.interfaceController, library: library)
                    self.libraries[library] = controller
                    
                    controller.template.tabTitle = library.name
                    controller.template.tabImage = .init(systemName: "headphones")
                    
                    templates.append(controller.template)
                }
            }
            
            self.template.updateTemplates(templates)
        }
    }
}

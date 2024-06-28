//
//  SurveyApp.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//
//  App main window definition

import ComposableArchitecture
import SwiftUI

@main
struct SurveyApp: App {
    
    /// Create app store
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
#if DEBUG
            ._printChanges() // this is for state changes debugging only
#endif
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: SurveyApp.store)
        }
    }
}

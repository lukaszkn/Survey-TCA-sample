//
//  SurveyApp.swift
//  Survey
//
//  Created by Lukasz on 27/06/2024.
//

import ComposableArchitecture
import SwiftUI

@main
struct SurveyApp: App {
    
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges() // this is for state changes debugging only
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: SurveyApp.store)
        }
    }
}

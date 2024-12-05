//
//  FirstXCODEProjectApp.swift
//  FirstXCODEProject
//
//  Created by egehan.cakir on 2.12.2024.
//

import SwiftUI

@main
struct FirstXCODEProjectApp: App {
    @StateObject var transactipnListVM = TransactionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(transactipnListVM)
        }
    }
}

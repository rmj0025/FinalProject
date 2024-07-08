//
//  SavedQuotesView.swift
//  FinalProject
//
//

import SwiftUI

struct SavedQuotesView: View {
    
    @ObservedObject private var viewModel = QuotesViewModel()
    @State private var quote = Quote(author: "", body: "")
    
    var body: some View {
        List(viewModel.quotes.indices, id: \.self) { index in
            QuoteDetailView(quote: viewModel.quotes[index])
        }
        .onAppear {
            viewModel.fetchUserQuotes()
        }
        .navigationTitle("Saved Quotes")
    }
}

#Preview {
    SavedQuotesView()
}

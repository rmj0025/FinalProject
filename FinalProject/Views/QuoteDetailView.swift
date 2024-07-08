//
//  QuoteDetailView.swift
//  FinalProject
//
//

import SwiftUI

struct QuoteDetailView: View {
    var quote: Quote
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\"\(quote.body)\"")
                .font(.body)
            Text("\"\(quote.author)\"")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    QuoteDetailView(quote: Quote(author: "Author", body: "Sample quote body"))
}

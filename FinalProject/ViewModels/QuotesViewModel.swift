//
//  QuotesViewModel.swift
//  FinalProject
//
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class QuotesViewModel: ObservableObject {
    @Published private(set) var quote: Quote?
    @Published var quotes = [Quote]()
    @Published var hasError = false
    @Published var error: QuoteModelError?
    
    private let url = "https://favqs.com/api/qotd"
    private let apiKey = "f36b2272bd4ddb244716c2843e4fcc15"
    private var db = Firestore.firestore()
    
    @MainActor
    func fetchRandomQuote() async {
        guard let url = URL(string: url) else {
            self.hasError = true
            self.error = .invalidURL
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Token token=\"\(apiKey)\"", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let quoteResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
            self.quote = quoteResponse.quote
        } catch {
            self.hasError = true
            self.error = .customError(error: error)
            print(error)
        }
    }
    
    func saveQuote() {
        guard let user = Auth.auth().currentUser else {
            print("User not signed in")
            return
        }
        
        print("Authenticated User ID: \(user.uid)")
        
        guard let quote = quote else {
            print("No quote to save")
            return
        }
        
        db.collection("quotes").addDocument(data: [
            "body": quote.body,
            "author": quote.author,
            "userId": user.uid
        ]) { error in
            if let error = error {
                print("Error saving quote: \(error.localizedDescription)")
            } else {
                print("Quote saved sucessfully!")
            }
        }
    }
    
    func fetchUserQuotes() {
        self.quotes.removeAll()
        
        guard let user = Auth.auth().currentUser else {
            print("User not signed in")
            return
        }
        
        print("Authenticated User ID: \(user.uid)")
        
        db.collection("quotes").whereField("userId", isEqualTo: user.uid).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching user quotes: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    if let body = data["body"] as? String,
                       let author = data["author"] as? String {
                        let res = Quote(author: author, body: body)
                        self.quotes.append(res)
                    }
                }
            }
        }
    }
}

extension QuotesViewModel {
    enum QuoteModelError: LocalizedError {
        case invalidURL
        case customError(error: Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .customError(let error):
                return error.localizedDescription
            }
        }
    }
}

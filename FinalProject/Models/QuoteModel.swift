//
//  QuoteModel.swift
//  FinalProject
//
//

import Foundation
import FirebaseFirestore

struct Quote: Codable {
    var author: String
    var body: String
    var userId: String?
    var timestamp: Timestamp?
}

struct QuoteResponse: Codable {
    var quote: Quote
}

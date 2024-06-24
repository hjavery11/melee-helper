//
//  ResponseBuilder.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/22/24.
//

import Foundation

let exampleJSONString = """
struct JSONResponse: Decodable {
    let title: String?
    let subtitle: String?
    let overview: String
    let sections: [Section]?
    let summary: String?
    
    struct Section: Decodable {
        let title: String
        let points: [String]
    }
    
    
    //Example JSONResponse that only returns 1 section
//    {
//        "title": "Fox vs Jigglypuff",
//        "subtitle": "Neutral Game",
//        "overview": "Brief overview about this before getting into points",
//        "sections": [
//            {
//                "title": "First tip",
//                "points": [
//                "first point about tip",
//                "second point about tip"
//                ]
//            }
//        ],
//        "summary": "closing words about this topic"
//    }
"""

struct ResponseBuilder {
    private var decoder = JSONDecoder()

    
    func parseJSON(rawString: String) -> JSONResponse? {
        guard let jsonData = rawString.data(using: .utf8) else { return nil }
        do {
            let response = try decoder.decode(JSONResponse.self, from: jsonData)
            return response
        } catch {
            print("Error decoding JSON: \(error)")
            print("JSON data was: \(rawString)")
            return nil
        }
    }
}


struct JSONResponse: Decodable {
    let title: String?
    let subtitle: String?
    let overview: String
    let sections: [Section]?
    let summary: String?
    
    struct Section: Decodable {
        let title: String
        let points: [String]
    }
    
    
    //Example JSONResponse that only returns 1 section
//    {
//        "title": "Fox vs Jigglypuff",
//        "subtitle": "Neutral Game",
//        "overview": "Brief overview about this before getting into points",
//        "sections": [
//            {
//                "title": "First tip",
//                "points": [
//                "first point about tip",
//                "second point about tip"
//                ]
//            }
//        ],
//        "summary": "closing words about this topic"
//    }
    
    
}

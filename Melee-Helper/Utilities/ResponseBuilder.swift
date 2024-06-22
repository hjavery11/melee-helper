//
//  ResponseBuilder.swift
//  Melee-Helper
//
//  Created by Harrison Javery on 6/22/24.
//

import Foundation


import Foundation

struct ResponseBuilder {
    private var decoder = JSONDecoder()

    
    func parseJSON(rawString: String) -> JSONResponse? {
        guard let jsonData = rawString.data(using: .utf8) else { return nil }
        do {
            let response = try decoder.decode(JSONResponse.self, from: jsonData)
            return response
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}


struct JSONResponse: Decodable {
    let title: String
    let overview: String
    let sections: [Section]
    let summary: String
    
    struct Section: Decodable {
        let title: String
        let points: [String]
    }
}

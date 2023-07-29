//
//  Parser.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 27.07.23.
//

import UIKit

final class Parser {
    
    func parse(_ data: Data, completion: @escaping (Feed?) -> Void) {
        DispatchQueue.global().async {
            let parser = XMLParser(data: data)
            let parserDelegate = ParserDelegate()
            parser.delegate = parserDelegate
            
            parser.parse()
            completion(parserDelegate.feed)
        }
    }
    
}

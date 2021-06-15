//
//  EscapeHTML.swift
//  BookReport
//
//  Created by 이예민 on 2021/06/15.
//

import Foundation

extension String {
    // html 태그 제거 + html entity들 디코딩.
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData, options: options, documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}

//
//  String+Extension.swift
//  NewQrCode
//
//  Created by Mehedi on 4/27/21.
//

import UIKit

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func toDate() -> Date? {
        return iCal.dateFormatter.date(from: self)
    }
    
    func toKeyValuePair(splittingOn separator: Character) -> (first: String, second: String)? {
        let arr = self.split(separator: separator,
                             maxSplits: 1,
                             omittingEmptySubsequences: false)
        if arr.count < 2 {
            return nil
        } else {
            return (String(arr[0]), String(arr[1]))
        }
    }
    
    var isValidURL: Bool {
        
        if containsIgnoringCase(find: "viber") {
            return true
        }
        if containsIgnoringCase(find: "http") {
            return true
        }
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    var isNumericForCodeBar: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9","-","$",":","+","."]
        return Set(self).isSubset(of: nums)
    }
    
    func isEmpty() -> Bool {
        for s in self {
            if s != " "{
                return false
            }
        }
        return true
    }
}

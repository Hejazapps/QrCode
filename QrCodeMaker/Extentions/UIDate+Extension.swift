//
//  UIDate+Extension.swift
//  NewQrCode
//
//  Created by Mehedi on 5/3/21.
//

import UIKit

extension Date {
    /// Convert String to Date
    func toString() -> String {
        return iCal.dateFormatter.string(from: self)
    }
}

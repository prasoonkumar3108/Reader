//
//  UIColor+AppColors.swift
//  Reader
//
//  Created by Prasoon Tiwari on 29/10/25.
//

import Foundation
import UIKit

extension UIColor {
    static var background: UIColor { UIColor(named: "Color/Background") ?? .systemBackground }
    static var secondaryBackground: UIColor { UIColor(named: "Color/SecondaryBackground") ?? .secondarySystemBackground }
    static var primary: UIColor { UIColor(named: "Color/Primary") ?? .systemBlue }
    static var secondary: UIColor { UIColor(named: "Color/Secondary") ?? .systemGray }
    static var textPrimary: UIColor { UIColor(named: "Color/TextPrimary") ?? .label }
    static var textSecondary: UIColor { UIColor(named: "Color/TextSecondary") ?? .secondaryLabel }
    //static var separator: UIColor { UIColor(named: "Color/Separator") ?? .separator }
}

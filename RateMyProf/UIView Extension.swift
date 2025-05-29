//
//  UIView Extension.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 07/01/25.
//
import UIKit
import NVActivityIndicatorView

extension UIView {
    private static var loaderView: UIView?
    
    func startLoader() {
        if UIView.loaderView != nil {
            return
        }
        let loaderView = UIView(frame: self.bounds)
        //loaderView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.addSubview(loaderView)
        let loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .ballPulse, color: UIColor(hex: "#17C6ED"))
        loader.center = loaderView.center
        loaderView.addSubview(loader)
        loader.startAnimating()
        UIView.loaderView = loaderView
    }
    
    func stopLoader() {
        DispatchQueue.main.async {
            UIView.loaderView?.removeFromSuperview()
            UIView.loaderView = nil
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex
        hexSanitized = hexSanitized.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

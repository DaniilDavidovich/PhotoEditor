//
//  AllertHelper.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//

import UIKit


final class AllertHelper {
    
    static func presentSuccessAllert(in viewController: UIViewController) {
        let alert = UIAlertController(title: "Success!", message: "Your photo has been successfully saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }

    static func presentErrorAllert(in viewController: UIViewController) {
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}

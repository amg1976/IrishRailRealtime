//
//  UIViewController+Extensions.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 28/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func show(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }

}

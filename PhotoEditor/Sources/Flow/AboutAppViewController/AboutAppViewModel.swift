//
//  AboutAppViewModel.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//

import Foundation
import UIKit


protocol AboutAppViewModelDelegate: AnyObject {
    func urlError()
}


final class AboutAppViewModel {
    
    //MARK: - Properties
    
    private var model: DeveloperInfoModel

    weak var delegate: AboutAppViewModelDelegate?
    
    private let url = URL(string: "https://github.com/DaniilDavidovich")
    
    
    //MARK: - Lyfecycle
    
    init(model: DeveloperInfoModel) {
        self.model = model
    }
    
    
    //MARK: - Methods
    
    func getModel() -> DeveloperInfoModel {
        return model
    }
    
    func openUrl() {
        if let url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            delegate?.urlError()
        }
    }
}

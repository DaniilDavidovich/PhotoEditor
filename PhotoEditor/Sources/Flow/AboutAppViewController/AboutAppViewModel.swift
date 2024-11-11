//
//  AboutAppViewModel.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//

import Foundation
import UIKit

protocol AboutAppViewModelProtocol {
    init(model: DeveloperInfoModel)
    func getModel() -> DeveloperInfoModel
    func openUrl(completion: @escaping (Bool) -> Void)
}


final class AboutAppViewModel: AboutAppViewModelProtocol {
    
    //MARK: - Properties
    
    private var model: DeveloperInfoModel
    
    private let url = URL(string: "https://github.com/DaniilDavidovich")
    
    
    //MARK: - Lyfecycle
    
    init(model: DeveloperInfoModel) {
        self.model = model
    }
    
    
    //MARK: - Methods
    
    func getModel() -> DeveloperInfoModel {
        return model
    }
    
    func openUrl(completion: @escaping (Bool) -> Void) {
        if let url {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        } else {
            completion(false)
        }
    }
}

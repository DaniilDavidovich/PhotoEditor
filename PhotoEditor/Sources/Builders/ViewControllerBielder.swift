//
//  ViewControllerBielder.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//


final class ViewControllerBuilder {
    
    static func getPhotoEditorViewController() -> PhotoEditorViewController {
        let viewModel = PhotoEditorViewModel()
        let viewController = PhotoEditorViewController(viewModel: viewModel)
        return viewController
    }
    
    static func getSettingViewController() -> SettingViewController {
        let viewModel = SettingViewModel()
        let viewController = SettingViewController(viewModel: viewModel)
        return viewController
    }
    
    static func getAboutAppViewController() -> AboutAppViewController {
        let model = DeveloperInfoModel.setupMockModel()
        let viewModel = AboutAppViewModel(model: model)
        let viewController = AboutAppViewController(viewModel: viewModel)
        return viewController
    }
}

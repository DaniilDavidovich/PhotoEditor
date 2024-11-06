//
//  SettingViewModel.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//


final class SettingViewModel {
    
    //MARK: - Properties
    
    private var dataSourceModel: [[DataSourceModel]] = [[.aboutApp]]
    
    
    //MARK: - Methods
    
    func getDataSourceModel() -> [[DataSourceModel]] {
        return dataSourceModel
    }
    
    func getNumberOfRowsInSection(at section: Int) -> Int {
        return dataSourceModel[section].count
    }
    
    func getNumberOfSection() -> Int {
        return dataSourceModel.count
    }
}


//MARK: - DataSourceModel

extension SettingViewModel {
    
    enum DataSourceModel {
        case aboutApp
    }
}

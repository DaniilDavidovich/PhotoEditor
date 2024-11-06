//
//  Model.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//


struct DeveloperInfoModel {
    var firstName: String
    var secondName: String
}


extension DeveloperInfoModel{
    static func setupMockModel() -> Self {
        return DeveloperInfoModel(firstName: "Daniil", secondName: "Davidovich")
    }
}

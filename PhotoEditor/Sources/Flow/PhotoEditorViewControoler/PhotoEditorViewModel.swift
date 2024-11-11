//
//  PhotoEditorViewModel.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//

import UIKit

protocol PhotoEditorViewModelDelegate: AnyObject {
    func needUpdateImage(with image: UIImage?)
    func needShowEditor(isVisible: Bool)
    func didUpdateImageAfterApplyFilter(with image: UIImage)
}

protocol PhotoEditorViewProtocol {
    func loadImage(_ image: UIImage)
    func applyFilter(isOn: Bool)
    func saveImage(frameView: UIView, completion: @escaping (Bool) -> Void)
    func resetEditor()
    func setupDelegate(to viewController: PhotoEditorViewModelDelegate)
}

final class PhotoEditorViewModel: PhotoEditorViewProtocol {

    // MARK: - Properties
    
    private weak var delegate: PhotoEditorViewModelDelegate?
    
    private var originalImage: UIImage?
    
    
    // MARK: - Methods
    
    func loadImage(_ image: UIImage) {
        self.originalImage = image
        delegate?.needUpdateImage(with: image)
        delegate?.needShowEditor(isVisible: true)
    }
    
    func applyFilter(isOn: Bool) {
        guard let originalImage = self.originalImage else { return }
        
        if isOn {
            let filter = CIFilter(name: "CIPhotoEffectMono")
            filter?.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
            if let outputImage = filter?.outputImage,
               let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) {
                delegate?.didUpdateImageAfterApplyFilter(with: UIImage(cgImage: cgImage))
            }
        } else {
            delegate?.didUpdateImageAfterApplyFilter(with: originalImage)
        }
    }
    
    func saveImage(frameView: UIView, completion: @escaping (Bool) -> Void) {
        
        let originalBorderColor = frameView.layer.borderColor
        frameView.layer.borderColor = UIColor.clear.cgColor
        
        UIGraphicsBeginImageContextWithOptions(frameView.bounds.size, false, UIScreen.main.scale)
        frameView.drawHierarchy(in: CGRect(origin: .zero, size: frameView.bounds.size), afterScreenUpdates: true)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let finalImage = finalImage {
            UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
            completion(true)
        } else {
            completion(false)
        }
        frameView.layer.borderColor = originalBorderColor
    }
    
    func resetEditor() {
        self.originalImage = nil
        delegate?.needUpdateImage(with: nil)
        delegate?.needShowEditor(isVisible: false)
    }
    
    func setupDelegate(to viewController: PhotoEditorViewModelDelegate) {
        self.delegate = viewController
    }
}

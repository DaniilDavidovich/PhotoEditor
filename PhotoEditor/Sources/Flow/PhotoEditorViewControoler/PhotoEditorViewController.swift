//
//  PhotoEditorViewController.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//

import UIKit

final class PhotoEditorViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel: PhotoEditorViewModel

    //MARK: - UIElements
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(plusButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var frameView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var filterSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isHidden = true
        return toggle
    }()
    
    
    //MARK: - Lyfecycle
    
    init(viewModel: PhotoEditorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        setupGestures()
    }
    
    //MARK: - Setups
    
    private func setupView() {
        self.title = "Editor"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(resetDidTapped))
        navigationItem.leftBarButtonItem?.isHidden = true
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    private func setupHierarchy() {
        view.addSubview(plusButton)
        view.addSubview(frameView)
        frameView.addSubview(imageView)
        view.addSubview(filterSwitch)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 100),
            plusButton.heightAnchor.constraint(equalToConstant: 60),
            
            frameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            frameView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            frameView.widthAnchor.constraint(equalToConstant: 250),
            frameView.heightAnchor.constraint(equalToConstant: 250),
            
            imageView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: frameView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor),
            
            filterSwitch.topAnchor.constraint(equalTo: frameView.bottomAnchor, constant: 20),
            filterSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinchGesture.delegate = self
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        rotateGesture.delegate = self
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotateGesture)
    }
    
    //MARK: - Methods
    
    // Open photo gallery to select an image
    @objc private func plusButtonDidTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Handle pan gesture for moving the image
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: frameView)
        if let view = gesture.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            gesture.setTranslation(.zero, in: frameView)
        }
    }
    
    // Handle pinch gesture for zooming in/out the image
    @objc private func handlePinch(gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        }
    }
    
    @objc private func handleRotate(gesture: UIRotationGestureRecognizer) {
        if let view = gesture.view {
            view.transform = view.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }
    
    @objc private func toggleSwitch() {
        viewModel.applyFilter(isOn: filterSwitch.isOn)
    }
    
    @objc private func saveImage() {
        viewModel.saveImage(frameView: self.frameView) { success in
            if success {
                AllertHelper.presentSuccessAllert(in: self)
            } else {
                AllertHelper.presentErrorAllert(in: self)
            }
        }
    }
    
    @objc private func resetDidTapped() {
        viewModel.resetEditor()
    }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension PhotoEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.loadImage(image)
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - PhotoEditorViewModelDelegate

extension PhotoEditorViewController: PhotoEditorViewModelDelegate2 {
    
    func needUpdateImage(with image: UIImage?) {
        imageView.image = image
        imageView.frame = frameView.bounds
    }
    
    func needShowEditor(isVisible: Bool) {
        plusButton.isHidden = isVisible
        imageView.isHidden = !isVisible
        frameView.isHidden = !isVisible
        filterSwitch.isHidden = !isVisible
        navigationItem.rightBarButtonItem?.isHidden = !isVisible
        navigationItem.leftBarButtonItem?.isHidden = !isVisible
        
        if isVisible {
            filterSwitch.isOn = false
        }
    }
    
    func didUpdateImageAfterApplyFilter(with image: UIImage) {
        imageView.image = image
    }
}


//MARK: - UIGestureRecognizerDelegate

extension PhotoEditorViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

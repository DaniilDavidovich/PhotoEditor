//
//  PhotoEditorViewController.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//

import UIKit

final class PhotoEditorViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel: PhotoEditorViewProtocol
    
    
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
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    //MARK: - Lyfecycle
    
    init(viewModel: PhotoEditorViewProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.setupDelegate(to: self)
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
        needShowEditor(isVisible: false)
    }
    
    //MARK: - Setups
    
    private func setupView() {
        self.view.backgroundColor = .systemGray6
        setupNavigationBar()
    }
    
    private func setupHierarchy() {
        view.addSubview(plusButton)
        view.addSubview(frameView)
        frameView.addSubview(imageView)
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
        ])
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinchGesture.delegate = self
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        rotateGesture.delegate = self
        frameView.addGestureRecognizer(panGesture)
        frameView.addGestureRecognizer(pinchGesture)
        frameView.addGestureRecognizer(rotateGesture)
    }
    
    private func setupNavigationBar() {
        self.title = "Editor"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let saveButton = UIBarButtonItem(title: "Save",
                                         style: .done,
                                         target: self,
                                         action: #selector(saveImage))
        
        let filterButton = UIBarButtonItem(title: nil,
                                           image: UIImage(systemName: "camera.filters"),
                                           primaryAction: nil,
                                           menu: self.setupUIMenu())
   
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(resetDidTapped))
        navigationItem.rightBarButtonItems = [saveButton, filterButton]
    }
    
    
    private func setupUIMenu() -> UIMenu  {
        return UIMenu(title: "", children: [
            UIAction(title: "Turn on", image: nil, handler: { [weak self] _ in
                self?.viewModel.applyFilter(isOn: true)
            }),
            UIAction(title: "Turn off", image: nil, handler: { [weak self] _ in
                self?.viewModel.applyFilter(isOn: false)
            }),
        ])
    }
    
    
    //MARK: - Methods
    
    
    @objc private func plusButtonDidTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        let translation = gesture.translation(in: frameView)
        
        let rotationAngle = atan2(gestureView.transform.b, gestureView.transform.a)
        
        let adjustedTranslationX = translation.x * cos(rotationAngle) - translation.y * sin(rotationAngle)
        let adjustedTranslationY = translation.x * sin(rotationAngle) + translation.y * cos(rotationAngle)
        
        imageView.center = CGPoint(
            x: imageView.center.x + adjustedTranslationX,
            y: imageView.center.y + adjustedTranslationY
        )
        
        gesture.setTranslation(.zero, in: frameView)
    }
    
    @objc private func handlePinch(gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        let pinchLocation = gesture.location(in: imageView)
        let scale = gesture.scale
        
        imageView.transform = imageView.transform
            .translatedBy(x: pinchLocation.x - imageView.bounds.midX, y: pinchLocation.y - imageView.bounds.midY)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: imageView.bounds.midX - pinchLocation.x, y: imageView.bounds.midY - pinchLocation.y)
        
        gesture.scale = 1.0
    }
    
    @objc private func handleRotate(gesture: UIRotationGestureRecognizer) {
        guard gesture.view != nil else { return }

        imageView.transform = imageView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc private func saveImage() {
        viewModel.saveImage(frameView: self.frameView) { [weak self] success in
            guard let self else { return }
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

extension PhotoEditorViewController: PhotoEditorViewModelDelegate {
    
    func needUpdateImage(with image: UIImage?) {
        imageView.image = image
        imageView.frame = frameView.bounds
        imageView.transform = .init(scaleX: 0, y: 0)
        imageView.transform  = .init(rotationAngle: 0)
    }
    
    func needShowEditor(isVisible: Bool) {
        plusButton.isHidden = isVisible
        imageView.isHidden = !isVisible
        frameView.isHidden = !isVisible
        navigationItem.rightBarButtonItems?.forEach { $0.isHidden = !isVisible }
        navigationItem.leftBarButtonItem?.isHidden = !isVisible
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

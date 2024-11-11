//
//  AboutAppViewController.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 6.11.24.
//

import UIKit


final class AboutAppViewController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel: AboutAppViewModelProtocol
    
    
    //MARK: - UIElements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = setupAttributedText()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.items = [navigationItemToNavigationBar]
        return navigationBar
    }()
    
    private lazy var navigationItemToNavigationBar: UINavigationItem = {
        let navigationItem = UINavigationItem(title: "About app")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                            target: self,
                                                            action: #selector(closeButtonDidTapped))
        return navigationItem
    }()
    
    
    //MARK: - Lifecycle
    
    init(viewModel: AboutAppViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        self.view.backgroundColor = .systemGray6
    }
    
    private func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(navigationBar)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textDidTapped))
        self.titleLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupAttributedText() -> NSAttributedString {
        let text = "Tap on \(viewModel.getModel().firstName) \(viewModel.getModel().secondName)"
        
        let attributedText = NSMutableAttributedString(string: text)
        let nameRange = (text as NSString).range(of: "\(viewModel.getModel().firstName) \(viewModel.getModel().secondName)")
        
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: nameRange)
        return attributedText
    }
    
    
    //MARK: - @objc Methods
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc private func textDidTapped(_ gesture: UITapGestureRecognizer) {
        if let text = titleLabel.text {
            let nameRange = (text as NSString).range(of: "\(viewModel.getModel().firstName) \(viewModel.getModel().secondName)")
            
            if gesture.didTapAttributedTextInLabel(label: titleLabel, inRange: nameRange) {
                viewModel.openUrl { [weak self] success in
                    guard let self else { return }
                    switch success {
                    case true:
                        break
                    case false:
                        AllertHelper.presentErrorAllert(in: self)
                    }
                }
            }
        }
    }
}



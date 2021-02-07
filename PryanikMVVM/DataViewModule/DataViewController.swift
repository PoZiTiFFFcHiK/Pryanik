//
//  ViewController.swift
//  PryanikMVVM
//
//  Created by Владимир on 03.02.2021.
//

import UIKit
import Moya

class ViewController: UIViewController {
    let viewModel = JsonViewsViewModel()
    
    let stack = UIStackView()
    let viewTappedLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        self.stack.axis = .vertical
        self.stack.spacing = 10
        self.stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewTappedLabel.text = "После нажатия на элемент здесь появится информация о нём"
        self.viewTappedLabel.lineBreakMode = .byWordWrapping
        self.viewTappedLabel.numberOfLines = 0
        self.viewTappedLabel.textAlignment = .center
        self.viewTappedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.viewTappedLabel)
        
        view.addSubview(self.stack)
        
        viewModel.getDataFromServer() { serverData in
            self.makeViews(data: serverData)
        }
        
        constraintInit(view: view)
        
        self.view = view
    }
    
    private func makeViews(data: DataView) {
        
        for view in data.view {
            switch view {
            case "hz":
                let label = makeLabel(nameAndData: data.data[0])
                self.stack.addArrangedSubview(label)
            case "selector":
                let selector = makeSelector(nameAndData: data.data[2])
                self.stack.addArrangedSubview(selector)
            case "picture":
                let imageView = makeImage(nameAndData: data.data[1])
                self.stack.addArrangedSubview(imageView)
            default:
                print("Unknown view")
            }
        }
    }
    
    private func makeLabel(nameAndData: NameData) -> UILabel {
        let label = UILabel()
        
        label.text = nameAndData.data.text
        let labelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTapRecognizer)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func makeSelector(nameAndData: NameData) -> UISegmentedControl {
        let selector = UISegmentedControl()
        
        for segment in nameAndData.data.variants! {
            selector.insertSegment(withTitle: "", at: segment.id, animated: true)
            let action = UIAction(title: segment.text) { action in
                self.viewTappedLabel.text = segment.text
            }
            selector.setAction(action, forSegmentAt: segment.id - 1)
        }
        selector.selectedSegmentIndex = nameAndData.data.selectedId!
        selector.translatesAutoresizingMaskIntoConstraints = false
        
        return selector
    }
    
    private func makeImage(nameAndData: NameData) -> UIImageView {
        let imageView = UIImageView()
        
        viewModel.getImageFromServer(url: nameAndData.data.url!) { image in
            imageView.image = image
        }
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTapRecognizer)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer, text: String) {
        if type(of: sender.view!) == type(of: UIImageView.init()) {
            self.viewTappedLabel.text = "Нажата картинка"
        } else {
            self.viewTappedLabel.text = "Нажат текстовый блок"
        }
    }
    
    private func constraintInit(view: UIView) {
        NSLayoutConstraint.activate ([
            stack.topAnchor.constraint(equalTo: viewTappedLabel.bottomAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            viewTappedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTappedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            viewTappedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            viewTappedLabel.bottomAnchor.constraint (equalTo: view.topAnchor, constant: 120),
            viewTappedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}


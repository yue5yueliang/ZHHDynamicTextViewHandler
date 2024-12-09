//
//  ViewController.swift
//  ZHHDynamicTextViewHandler
//
//  Created by 桃色三岁 on 2022/5/16.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit
import ZHHDynamicTextViewHandler

class ViewController: UIViewController, UITextViewDelegate {
    private var textView: UITextView!
    private var textViewHeightConstraint: NSLayoutConstraint!
    private var handler: ZHHDynamicTextViewHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        // 初始化 UITextView
        textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .lightGray
        textView.layer.cornerRadius = 8
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)

        // 添加约束
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
        
        // 添加高度约束
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 40)
        textViewHeightConstraint.isActive = true

        // 初始化处理器
        handler = ZHHDynamicTextViewHandler(textView: textView, heightConstraint: textViewHeightConstraint)
        handler.minimumNumberOfLines = 2
        handler.maximumNumberOfLines = 6
        
        // 添加按钮
        setupButtons()
    }

    // MARK: - 添加按钮
    private func setupButtons() {
        // 清空按钮
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("清空文本", for: .normal)
        clearButton.addTarget(self, action: #selector(emptyText), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)

        // 添加文本按钮
        let addButton = UIButton(type: .system)
        addButton.setTitle("添加文本", for: .normal)
        addButton.addTarget(self, action: #selector(addText), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        // 按钮布局
        NSLayoutConstraint.activate([
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            clearButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),

            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - Action Methods
    @objc func emptyText() {
        handler.updateText("", animated: true)
    }

    @objc func addText() {
        handler.updateText("这是一个 Swift 版本的 Growing TextView 示例，非常实用！", animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        handler.resizeTextView(animated: true)
    }
}



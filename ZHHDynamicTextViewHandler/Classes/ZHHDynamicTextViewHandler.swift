//
//  ZHHGrowingTextViewHandler.swift
//  ZHHGrowingTextViewHandler
//
//  Created by 桃色三岁 on 2022/5/16.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

import UIKit

/// 用于动态调整 UITextView 高度的处理类
open class ZHHDynamicTextViewHandler: NSObject {
    
    /// 待调整高度的 UITextView
    open var growingTextView: UITextView!
    
    /// 动画持续时间，默认 0.5 秒
    open var heightChangeAnimationDuration = 0.5
    
    /// 最大行数（设置后会自动更新高度）
    open var maximumNumberOfLines = Int.max {
        didSet {
            updateInitialHeightAndResize()
        }
    }
    
    /// 最小行数（设置后会自动更新高度）
    open var minimumNumberOfLines = 1 {
        didSet {
            updateInitialHeightAndResize()
        }
    }
    
    /// UITextView 的高度约束
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    /// UITextView 的初始高度
    private var initialHeight: CGFloat = 0.0
    
    /// UITextView 的最大高度
    private var maximumHeight: CGFloat = 0.0
    
    /// 光标高度（取决于字体大小）
    private var caretHeight: CGFloat {
        if let selectedTextRange = growingTextView.selectedTextRange {
            return growingTextView.caretRect(for: selectedTextRange.end).size.height
        } else {
            return 0.0
        }
    }
    
    /// 当前文本内容对应的高度
    private var currentHeight: CGFloat {
        guard let textViewFont = growingTextView.font else {
            return 0.0
        }
        let width = growingTextView.bounds.size.width - 2.0 * growingTextView.textContainer.lineFragmentPadding
        let boundingRect = growingTextView.text.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: textViewFont],
            context: nil
        )
        let heightByBoundingRect = boundingRect.height + textViewFont.lineHeight
        return max(heightByBoundingRect, growingTextView.contentSize.height)
    }
    
    /// 当前文本对应的行数
    private var currentNumberOfLines: Int {
        let totalHeight = currentHeight + growingTextView.textContainerInset.top + growingTextView.textContainerInset.bottom
        return Int(totalHeight / caretHeight) - 1
    }
    
    // MARK: - 初始化方法
    
    /// 初始化并返回一个 `ZHHGrowingTextViewHandler` 实例
    /// - Parameters:
    ///   - textView: 待调整高度的 UITextView
    ///   - heightConstraint: UITextView 的高度约束
    public init(textView: UITextView, heightConstraint: NSLayoutConstraint) {
        super.init()
        growingTextView = textView
        textViewHeightConstraint = heightConstraint
        initialHeight = heightConstraint.constant
        updateInitialHeightAndResize()
    }
    
    // MARK: - 公共方法
    
    /// 根据内容动态调整 UITextView 的高度
    /// - Parameter animated: 是否使用动画
    open func resizeTextView(animated: Bool) {
        let textViewNumberOfLines = currentNumberOfLines
        var verticalAlignmentConstant: CGFloat = 0.0
        
        if textViewNumberOfLines <= minimumNumberOfLines {
            verticalAlignmentConstant = initialHeight
        } else if textViewNumberOfLines > minimumNumberOfLines && textViewNumberOfLines <= maximumNumberOfLines {
            verticalAlignmentConstant = max(currentHeight, initialHeight)
        } else {
            verticalAlignmentConstant = maximumHeight
        }
        
        if let heightConstraint = textViewHeightConstraint, heightConstraint.constant != verticalAlignmentConstant {
            updateVerticalAlignmentWithHeight(verticalAlignmentConstant, animated: animated)
        }
        
        // 限制滚动
        if textViewNumberOfLines <= maximumNumberOfLines {
            growingTextView.setContentOffset(.zero, animated: true)
        }
    }
    
    /// 设置 UITextView 的内容并根据内容调整高度
    /// - Parameters:
    ///   - text: 要设置的文本
    ///   - animated: 是否使用动画
    open func updateText(_ text: String, animated: Bool) {
        growingTextView.text = text
        if text.isEmpty {
            updateVerticalAlignmentWithHeight(initialHeight, animated: animated)
        } else {
            resizeTextView(animated: animated)
        }
    }
    
    // MARK: - 私有方法
    
    /// 更新初始高度和最大高度，并调整 UITextView 高度
    private func updateInitialHeightAndResize() {
        initialHeight = estimatedInitialHeight()
        maximumHeight = estimatedMaximumHeight()
        resizeTextView(animated: false)
    }
    
    /// 计算初始高度
    private func estimatedInitialHeight() -> CGFloat {
        let totalHeight = caretHeight * CGFloat(minimumNumberOfLines) +
            growingTextView.textContainerInset.top +
            growingTextView.textContainerInset.bottom
        return max(totalHeight, initialHeight)
    }
    
    /// 计算最大高度
    private func estimatedMaximumHeight() -> CGFloat {
        return caretHeight * CGFloat(maximumNumberOfLines) +
            growingTextView.textContainerInset.top +
            growingTextView.textContainerInset.bottom
    }
    
    /// 更新高度约束并调整布局
    /// - Parameters:
    ///   - height: 新的高度
    ///   - animated: 是否使用动画
    private func updateVerticalAlignmentWithHeight(_ height: CGFloat, animated: Bool) {
        guard let heightConstraint = textViewHeightConstraint else { return }
        heightConstraint.constant = height
        if animated {
            UIView.animate(withDuration: heightChangeAnimationDuration) {
                self.growingTextView.superview?.layoutIfNeeded()
            }
        } else {
            growingTextView.superview?.layoutIfNeeded()
        }
    }
}


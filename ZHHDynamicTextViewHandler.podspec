Pod::Spec.new do |s|
  s.name             = 'ZHHDynamicTextViewHandler' # 库名
  s.version          = '0.0.1' # 当前版本号
  s.summary          = '一个轻量级工具，用于根据 UITextView 的内容动态调整其高度。'

  s.description      = <<-DESC
ZHHDynamicTextViewHandler 是一个基于 Swift 的实用工具，可根据 UITextView 中的文本内容动态调整高度，支持流畅动画。
  DESC

  s.homepage         = 'https://github.com/yue5yueliang/ZHHDynamicTextViewHandler' # 主页链接
  s.license          = { :type => 'MIT', :file => 'LICENSE' } # 开源协议
  s.author           = { '桃色三岁' => '136769890@qq.com' } # 作者信息
  s.source           = { :git => 'https://github.com/yue5yueliang/ZHHDynamicTextViewHandler.git', :tag => s.version.to_s } # Git 仓库地址和版本

  # iOS 部署版本要求
  s.ios.deployment_target = '13.0'

  # 源代码文件路径
  s.source_files = 'ZHHDynamicTextViewHandler/Classes/**/*'

  # Swift 相关配置
  s.requires_arc = true # 使用 ARC
  s.swift_version = '5.0' # Swift 版本
end

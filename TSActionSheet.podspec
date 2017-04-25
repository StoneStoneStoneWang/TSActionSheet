Pod::Spec.new do |s|

//文件名
s.name = 'ActionSheet'
//版本
s.version = '1.0.1'
//描述信息
s.summary = 'A view like ActionSheet on iOS.'
//这里的主页自己随便写
s.homepage = 'http://www.swifthumb.com/home.php?mod=space&uid=1904&do=index' 
//作者
s.authors = { ‘018652wl’ => ‘yuanxingfu1314@163.com' }
//资源路径
s.source = { :git => 'https://github.com/StoneStoneStoneWang/TSActionSheet.git', :tag => '1.0.1' }
//ARC模式
s.requires_arc = true
//license，一般我们用MIT
s.license = 'MIT'
//允许的最低系统使用版本
s.ios.deployment_target = '7.0'
//库文件路径
s.source_files = 'ActionSheet/*'

end

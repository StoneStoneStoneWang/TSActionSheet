Pod::Spec.new do |s|


  s.name = 'TSActionSheet'

  s.version = '1.0.0'

  s.summary = 'A view like ActionSheet on iOS.'

  s.homepage = 'http://www.swifthumb.com/home.php?mod=space&uid=1904&do=index' 

  s.authors = { 'ActionSheet' => 'yuanxingfu1314@163.com' }

  s.source = { :git => 'https://github.com/StoneStoneStoneWang/TSActionSheet.git', :tag => s.version }

  s.license = 'MIT'

  s.ios.deployment_target = '8.0'

  s.osx.deployment_target = '10.10'

  s.source_files = 'ActionSheet/*'

end

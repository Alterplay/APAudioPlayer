Pod::Spec.new do |s|
  s.name         = "APAudioPlayer"
  s.version      = "0.0.2"
  s.summary      = "Drop-in iOS Audio Player built on top of BASS-library"
  s.homepage     = "https://github.com/Alterplay/APAudioPlayer"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Serg Krivoblotsky" => "sergey@alterplay.com" }
  s.source       = { :git => "https://github.com/Alterplay/APAudioPlayer.git",
		                 :tag => s.version.to_s }
  s.source_files = 'APAudioPlayer/**/*.{h,m}'
  s.ios.vendored_library = 'APAudioPlayer/bass/libbass.a', 'APAudioPlayer/bass/plugins/bassflac/libbassflac.a', 'APAudioPlayer/bass/plugins/bassopus/libbassopus.a', 'APAudioPlayer/bass/plugins/basswv/libbasswv.a'
  s.ios.deployment_target = "6.0"
  s.requires_arc = true
  s.frameworks   = 'AVFoundation'
end
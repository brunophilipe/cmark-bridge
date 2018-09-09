target 'ArgonPro' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  platform :ios, '12.0'

  # Pods for ArgonPro
  pod 'GadgetKit', :path => 'Dependencies/GadgetKit'
  pod 'ArgonModel', :path => 'Dependencies/ArgonModel'
  pod 'Tokamak', :path => 'Dependencies/Tokamak'
  pod 'Yams'
  pod 'SavannaKit', :path => 'Dependencies/SavannaKit'
  pod 'SourceEditor', :path => 'Dependencies/source-editor'
  pod 'liquid-swift', :path => 'Dependencies/liquid-swift'

  target 'ArgonProTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'CommonMark' do
    use_frameworks!
    platform :ios, 12.0
    
    # Pods for CommonMark
    pod 'cmark-bridge', :path => 'Dependencies/cmark-bridge'
    
    target 'CommonMarkTests' do
        inherit! :search_paths
        # Pods for testing
    end
end

target 'ArgonTool' do
  pod 'GadgetKit', :path => 'Dependencies/GadgetKit'
  pod 'ArgonModel', :path => 'Dependencies/ArgonModel'
  pod 'Tokamak', :path => 'Dependencies/Tokamak'
  pod 'Yams'
end

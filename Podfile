platform:ios,'8.0'

def native_pods
	pod 'JLRoutes', '2.1'
end


def react_pods
    pod 'React', :path => './ReactNative/node_modules/react-native', :subspecs => [
    'Core',
        'ART',
        'RCTActionSheet',
        'RCTAdSupport',
        'RCTGeolocation',
        'RCTImage',
        'RCTNetwork',
        'RCTPushNotification',
        'RCTSettings',
        'RCTText',
        'RCTVibration',
        'RCTWebSocket',
        'RCTLinkingIOS',
        'RCTAnimation',
        'DevSupport'
    ]
    pod "Yoga", :path => "./ReactNative/node_modules/react-native/ReactCommon/yoga"
end

target 'CCDemo' do
	native_pods
	react_pods
end

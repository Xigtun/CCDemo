### iOS原生项目集成 React Native 一 导航

先来看一下完整效果



集成 RN 的步骤请参照 [官方文档](https://reactnative.cn/docs/0.51/integration-with-existing-apps.html#content)。
这里注意一下项目的目录结构，所有 RN 相关均在 `ReactNative` 目录下。



【pict】




相应地，`podfile` 和 `package.json` 要做一下相应调整。

`podfile`

```
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

```

如果运行报错 如 `'RCTAnimation/RCTValueAnimatedNode.h' file not found.`，
`则将#import <RCTAnimation/RCTValueAnimatedNode.h> 改成 #import "RCTValueAnimatedNode.h"`


`package.json`

```
{
  "name": "CCDemo",
  "version": "0.0.1",
  "private": true,
  "scripts": {
    "start": "node node_modules/react-native/local-cli/cli.js start"
  },
  "dependencies": {
    "bundle": "^2.1.0",
    "react": "16.0.0-alpha.6",
    "react-native": "0.44.3",
    "react-navigation": "^1.0.0-beta.26"
  }
}

```

好了，下面来写两个 RN 页面

新建 RN1Scene.js RN2Scene.js App.js

```
export default class RN1Scene extends Component {

    constructor(props) {
        super(props);
        const {
            navigation,
        } = this.props;
    }

    render() {
        const { navigate } = this.props.navigation;
        return (
            <View style={styles.container}>
                <Text style={styles.instructions} onPress={()=>navigate('RN2Scene')}>To RN2Scene</Text> 
            </View>
        );
    }
}

export default class RN2Scene extends Component {
    handleOnPress() {
        console.log('To Native2')
    }

    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.instructions} onPress={this.handleOnPress}>To Native2</Text> 
            </View>
        );
    }
}

```

由 `App.js` 统一管理 RN Scene

先来测试一下RN部分代码是否可行，

`ViewController`中

```
- (IBAction)ToRN1Scene:(id)sender {
    NSURL *jsCodeLocation = [NSURL
                             URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios"];
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL : jsCodeLocation
                         moduleName        : @"DemoRN"
                         initialProperties : nil
                          launchOptions    : nil];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = rootView;
    [self.navigationController pushViewController:vc animated:YES];
}

```


现在已经完成了 Native -> RN1 -> RN2。同时也会出现几个问题，

- 导航栏
- 首页的返回按钮
- 返回手势

对于导航栏，由于RN使用的NavigationBar 与原生同时存在，有可能原生导航栏会覆盖在 RN 上，有部分应用可能隐藏了系统导航栏，使用自定义的 View，则不存在这个问题，这里只需要在 RN 页面隐藏原生导航栏即可。至于 RN 部分是继续自定义还是使用 `StackNavigator` 就看大家选择了。

隐藏了原生NavigationBar会带来第二个问题，进入RN1Scene时，返回按钮没有了。这时需要自己实现pop功能。

我们看到呈现的 RN1Scene 和 RN2Scene 都承载到一个 ViewController 中，无论在哪个 Scene 使用返回手势，都会返回到原生页面。


下面需要进行原生部分的工作
新建 bridge 文件，
这里写一个原生返回方法，一个原生跳转方法供 RN 使用

```
@implementation CCRNBridge

RCT_EXPORT_MODULE(RNBridge)

/// UI 相关 需写在主线程
RCT_EXPORT_METHOD(pushToVC:(NSString *)vc paramters:(NSDictionary *)para)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CCRouterManager sharedInstance] pushToVC:vc paramters:para];
    });
}

RCT_EXPORT_METHOD(popViewController:(BOOL)animated)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[CCRouterManager sharedInstance] popViewController:animated];
    });
}

/// RN 使用的参数，可以传方法或者常量
- (NSDictionary *)constantsToExport {
    return @{
             @"baseurl" : @"someurl"
             };
}

@end
```

在 RN2Scene 加入如下代码：

```
import {
    NativeModules
} from 'react-native';

var Native = NativeModules.RNBridge;

'''
	handleOnPress() {
        Native.pushToVC('CCOneController',{labelText:'From RN2'})
    }
'''

```
到这里已经完成了 已经完成了 Native -> RN1 -> RN2 -> Native。

现在总结一下现有的跳转方式

Native -> Native  Router
RN -> RN  StackNavigator
RN -> Native Router

还有一种 Native -> RN 这种还是使用比较原始的方法，我们可以再封装一层，统一使用 Router 的方式跳转。

新建 统一的 Container

```
@interface CCRNContainer : CCBaseViewController

@property (nonatomic, strong) NSString *moduleName;

@property (nonatomic, strong) NSString *bundlePath;

@property (nonatomic, strong) NSDictionary *paramters;

@end


@implementation CCRNContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *jsCodeLocation = [NSURL
                             URLWithString:self.bundlePath];
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL : jsCodeLocation
                         moduleName        : self.moduleName
                         initialProperties : self.paramters
                          launchOptions    : nil];
    self.view = rootView;
}

@end

```

ViewController 中

```
- (IBAction)ToRN1Scene:(id)sender {
    NSDictionary *para = @{
                           @"moduleName" : @"DemoRN",
                           @"bundlePath" : @"http://localhost:8081/index.ios.bundle?platform=ios",
                           };
    [[CCRouterManager sharedInstance] pushToVC:@"CCRNContainer" paramters:para];
}
```

至此，我们的几种跳转方式已经统一了。


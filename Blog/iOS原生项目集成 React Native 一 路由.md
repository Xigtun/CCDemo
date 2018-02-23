## iOS原生项目集成 React Native 一 路由

### 集成 RN 的目的

* 代码热更新

* 多端代码复用

团队考虑集成 RN 主要是为了代码热更新。

相对于原生开发，使用 RN，初期成本可能会有些高。

如果团队人员足够，而且不存在审核方面的问题，不建议在现有项目里面集成 RN。


### 存在的问题


由于项目已使用原生代码开发了完整的功能，集成 RN 大多是新模块的开发，所以就涉及到原生与 RN 间相互跳转传参。RN 模块自身使用 ` StackNavigator ` 可以很好的进行导航管理；Native 跳转 RN，主要是提供 `View Controller` 作为容器，承载 `RCTRootView`；关键在于RN 跳转 Native，不可能对每一个对应的跳转都写一次 Bridge 方法。考虑到这里，就想到了路由。以路由的方式，可以方便的对项目进行解耦，统一处理 Native 与 RN 间的跳转。
Demo中选用了 [JLRoutes](https://github.com/joeldev/JLRoutes) 方案。

### 集成步骤

#### 1、定义跳转协议
在 `plist` 中加入下列代码 

	<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>CCDemo</string>
            </array>
        </dict>
    </array>	

这里，使用 `CCDemo` 作为协议，使用 `CCDemo://` 就可以跳转到应用内了。

#### 2、定义跳转规则
这里新建一个 `RouterManager` 统一处理 `router` 相关。这里也建议大家这样做，如果以后要修改或新增跳转协议类型(多Target)，会简单得多。

`CCRouterManager`
	
	- (void)setupRouterRule {
	    /// vc from code 
	    [[JLRoutes globalRoutes] addRoute:@"/NavPush/:controller" handler:^BOOL(NSDictionary<NSString *,NSString *> * _Nonnull parameters) {
	        UIViewController *v = [[NSClassFromString(parameters[@"controller"]) alloc] init];
	        [self paramToVc:v param:parameters];
	        [[AppDelegate sharedDelegate].currentVC pushViewController:v animated:YES];
	        return YES;
	    }];
	}
	
	- (void)paramToVc:(UIViewController *) v param:(NSDictionary<NSString *,NSString *> *)parameters {
	    unsigned int outCount = 0;
	    objc_property_t * properties = class_copyPropertyList(v.class , &outCount);
	    for (int i = 0; i < outCount; i++) {
	        objc_property_t property = properties[i];
	        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
	        NSString *param = parameters[key];
	        if (param != nil) {
	            [v setValue:param forKey:key];
	        }
	    }
	}

这里只实现了从代码中加载 VC，从 Xib 或 StoryBoard 加载可以自行实现。

`AppDelegate`


	static AppDelegate *sInstance = nil;
	
	+ (instancetype)sharedDelegate {
	    if (sInstance == nil) {
	        sInstance = [[AppDelegate alloc] init];
	    }
	    return sInstance;
	}
	
	- (id)init {
	    if (self = [super init]) {
	        sInstance = self;
	    }
	    return self;
	}
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    
	    [[CCRouterManager sharedInstance] setupRouterRule];
	    
	    return YES;
	}

	- (UINavigationController *)currentVC
	{
	    return (UINavigationController *)self.window.rootViewController;
	}

3、handle url

在 `AppDelegate` 中加入如下代码

	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
	    if ([url.absoluteString containsString:@"CCDemo://"]) {
	        return [[CCRouterManager sharedInstance] canRouteURL:url];
	    }
	    return  YES;
	}


到这里，router 部分就完成了，现在可以通过

	NSDictionary *para = @{
	                           @"labelText" : @"CCOneController-labelText",
	                           };
	[[CCRouterManager sharedInstance] pushToVC:@"CCOneController" paramters:para];

来实现跳转了。
[demo 地址](https://github.com/Xigtun/CCDemo) tag： router

与原生页面相互跳转见下节 [iOS原生项目集成 React Native 一 导航](https://github.com/Xigtun/CCDemo/blob/master/Blog/iOS%E5%8E%9F%E7%94%9F%E9%A1%B9%E7%9B%AE%E9%9B%86%E6%88%90%20React%20Native%20%E4%B8%80%20%E5%AF%BC%E8%88%AA.md)








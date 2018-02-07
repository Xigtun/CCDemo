//
//  AppDelegate.m
//  CCDemo
//
//  Created by cysu on 07/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import "AppDelegate.h"
#import "CCRouterManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.absoluteString containsString:@"CCDemo://"]) {
        return [[CCRouterManager sharedInstance] canRouteURL:url];
    }
    return  YES;
}

- (UINavigationController *)currentVC
{
    return (UINavigationController *)self.window.rootViewController;
}

@end

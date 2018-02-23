//
//  CCRNBridge.m
//  CCDemo
//
//  Created by cysu on 23/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import "CCRNBridge.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>
@interface CCRNBridge()<RCTBridgeModule>

@end

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

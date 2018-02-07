//
//  CCRouterManager.m
//  CCDemo
//
//  Created by cysu on 07/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import "CCRouterManager.h"
#import <objc/runtime.h>
#import "JLRoutes.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CCUtils.h"

@implementation CCRouterManager

+ (instancetype)sharedInstance
{
    static CCRouterManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CCRouterManager alloc] init];
    });
    return sharedInstance;
}

- (BOOL)canRouteURL:(NSURL *)url
{
    return [JLRoutes routeURL:url];
}

- (void)setupRouterRule {
    /// vc from code
    [[JLRoutes globalRoutes] addRoute:@"/NavPush/:controller" handler:^BOOL(NSDictionary<NSString *,NSString *> * _Nonnull parameters) {
        UIViewController *v = [[NSClassFromString(parameters[@"controller"]) alloc] init];
        [self paramToVc:v param:parameters];
        [[AppDelegate sharedDelegate].currentVC pushViewController:v animated:YES];
        return YES;
    }];
}

- (void)pushToVC:(NSString *)vcName paramters:(NSDictionary *)para
{
    NSString *scheme = @"CCDemo://";
    NSString *rootPath = [NSString stringWithFormat:@"%@NavPush/%@",scheme, vcName];
    if (para) {
        rootPath = [CCUtils addQueryStringToUrlString:rootPath withDictionary:para];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rootPath]];
}



#pragma mark  - private method
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






@end

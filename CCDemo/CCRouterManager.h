//
//  CCRouterManager.h
//  CCDemo
//
//  Created by cysu on 07/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCRouterManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)canRouteURL:(NSURL *)url;

- (void)setupRouterRule;

- (void)pushToVC:(NSString *)vcName paramters:(NSDictionary *)para;

@end

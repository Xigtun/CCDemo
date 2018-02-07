//
//  AppDelegate.h
//  CCDemo
//
//  Created by cysu on 07/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedDelegate;

- (UINavigationController *)currentVC;

@end


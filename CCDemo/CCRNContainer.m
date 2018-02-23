//
//  CCRNContainer.m
//  CCDemo
//
//  Created by cysu on 23/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import "CCRNContainer.h"
#import <React/RCTRootView.h>

@interface CCRNContainer ()

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


@end

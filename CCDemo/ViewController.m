//
//  ViewController.m
//  CCDemo
//
//  Created by cysu on 07/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import "ViewController.h"
#import <React/RCTRootView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CCDemo";
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];


}

- (IBAction)pushAction:(id)sender {
    
    NSDictionary *para = @{
                           @"labelText" : @"CCOneController-labelText",
                           };
    [[CCRouterManager sharedInstance] pushToVC:@"CCOneController" paramters:para];
}


- (IBAction)ToRN1Scene:(id)sender {
    NSDictionary *para = @{
                           @"moduleName" : @"DemoRN",
                           @"bundlePath" : @"http://localhost:8081/index.ios.bundle?platform=ios",
                           };
    [[CCRouterManager sharedInstance] pushToVC:@"CCRNContainer" paramters:para];
}



@end

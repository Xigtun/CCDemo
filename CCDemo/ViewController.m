//
//  ViewController.m
//  CCDemo
//
//  Created by cysu on 07/02/2018.
//  Copyright © 2018 cysu. All rights reserved.
//

#import "ViewController.h"
//#import "CCOneController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CCDemo";
}

- (IBAction)pushAction:(id)sender {
    NSDictionary *para = @{
                           @"labelText" : @"CCOneController-labelText",
                           };
    [[CCRouterManager sharedInstance] pushToVC:@"CCOneController" paramters:para];
//    CCOneController *vc = [[CCOneController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}



@end

//
//  AppDelegate.m
//  NetworkMonitor
//
//  Created by walen on 2019/10/4.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkStatusView.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

        
    NetworkStatusView *lb_network = [[NetworkStatusView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.height-120, 60, 60)];
    [self.window addSubview:lb_network];

    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}



@end

//
//  AppDelegate.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "AppDelegate.h"
#import "MSWindow.h"
#import "MSTabBarController.h"
#import "MinstaMacro.h"

@interface AppDelegate () <UIApplicationDelegate>
{
    MSWindow *_window;
}
@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self _setupController];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - Private

- (void)_setupController {
    MSTabBarController *tabBarController = [MSTabBarController new];

    _window = [[MSWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = MS_WIHTE_BACKGROUND_COLOR;
    _window.rootViewController = tabBarController;

    [_window makeKeyAndVisible];
}

@end

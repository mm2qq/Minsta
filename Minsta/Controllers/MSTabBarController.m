//
//  MSTabBarController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSTabBarController.h"

static const NSString *kViewControllerClassName = @"class";
static const NSString *kTabBarItemImageString = @"image";
static const NSString *kTabBarItemSelectedImageString = @"selectedImage";

@implementation MSTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *imageDics = @[@{kViewControllerClassName : @"MSHomeViewController",
                             kTabBarItemImageString : @"tabbar-home-icon",
                             kTabBarItemSelectedImageString : @"tabbar-home-icon-highlighted"},
                           @{kViewControllerClassName : @"MSSearchViewController",
                             kTabBarItemImageString : @"tabbar-search-icon",
                             kTabBarItemSelectedImageString : @"tabbar-search-icon-highlighted"},
                           @{kViewControllerClassName : @"MSCameraViewController",
                             kTabBarItemImageString : @"tabbar-camera-icon",
                             kTabBarItemSelectedImageString : @"tabbar-camera-icon-highlighted"},
                           @{kViewControllerClassName : @"MSActivityViewController",
                             kTabBarItemImageString : @"tabbar-activity-icon",
                             kTabBarItemSelectedImageString : @"tabbar-activity-icon-highlighted"},
                           @{kViewControllerClassName : @"MSProfileViewController",
                             kTabBarItemImageString : @"tabbar-profile-icon",
                             kTabBarItemSelectedImageString : @"tabbar-profile-icon-highlighted"}];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:imageDics.count];

    for (NSDictionary *imageDic in imageDics) {
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:imageDic[kTabBarItemImageString]] selectedImage:[UIImage imageNamed:imageDic[kTabBarItemSelectedImageString]]];
        tabBarItem.imageInsets = (UIEdgeInsets){6.f, 0.f, -6.f, 0.f};
        ASViewController *viewController = [NSClassFromString(imageDic[kViewControllerClassName]) new];
        ASNavigationController *navigationController = [[ASNavigationController alloc] initWithRootViewController:viewController];
        navigationController.tabBarItem = tabBarItem;

        [viewControllers addObject:navigationController];
    }

    self.viewControllers = viewControllers;
}

@end

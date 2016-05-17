//
//  MSTabBarController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSTabBarController.h"

@implementation MSTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *identifiers            = @[@"home", @"search", @"camera", @"activity", @"profile"];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:identifiers.count];

    for (NSString *identifier in identifiers) {
        UIImage *image         = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar-%@-icon", identifier]];
        UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar-%@-icon-h", identifier]];
        Class class            = NSClassFromString([NSString stringWithFormat:@"MS%@ViewController", identifier.capitalizedString]);

        UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:nil image:image selectedImage:selectedImage];
        barItem.imageInsets   = (UIEdgeInsets){6.f, 0.f, -6.f, 0.f};

        ASViewController *viewController                = [class new];
        ASNavigationController *navigationController    = [[ASNavigationController alloc] initWithRootViewController:viewController];
        navigationController.tabBarItem                 = barItem;
        navigationController.hidesBarsOnSwipe           = YES;
        navigationController.navigationBar.translucent  = NO;
        navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.976 green:.976 blue:.976 alpha:1.f];

        [viewControllers addObject:navigationController];
    }

    self.viewControllers     = viewControllers;
    self.tabBar.translucent  = NO;
    self.tabBar.barTintColor = [UIColor colorWithRed:.976 green:.976 blue:.976 alpha:1.f];
}

@end

//
//  MSActivityViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSActivityViewController.h"

@interface MSActivityViewController ()

@end

@implementation MSActivityViewController

#pragma mark - Lifecycle

- (instancetype)init {
    if (self = [super initWithNode:[ASDisplayNode new]]) {

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end

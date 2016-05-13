//
//  MSHomeViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSHomeViewController.h"

@interface MSHomeViewController () <ASTableDataSource, ASTableDelegate>

@property (nonatomic, copy) NSArray *imageCategories;

@end

@implementation MSHomeViewController

#pragma mark - Lifecycle

- (instancetype)init {
    ASTableNode *tableNode = [ASTableNode new];

    if (self = [super initWithNode:tableNode]) {
        tableNode.dataSource = self;
        tableNode.delegate = self;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _imageCategories = @[@"abstract", @"animals", @"business", @"cats", @"city", @"food", @"nightlife", @"fashion", @"people", @"nature", @"sports", @"technics", @"transport"];
}

#pragma mark - Getters & setters

#pragma mark - ASTableDataSource & ASTableDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageCategories.count;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imageCategory = _imageCategories[indexPath.row];

    return ^{
        ASTextCellNode *textCellNode = [ASTextCellNode new];
        textCellNode.text = [imageCategory capitalizedString];
        return textCellNode;
    };
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end

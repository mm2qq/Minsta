//
//  MSHomeViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSPhotoFeedHeaderNode.h"
#import "MSPhotoFeedCellNode.h"
#import "MSPhotoFeed.h"
#import "MinstaMacro.h"

@interface MSHomeViewController () <ASTableDataSource, ASTableDelegate>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) MSPhotoFeed *photoFeed;

@end

@implementation MSHomeViewController

#pragma mark - Lifecycle

- (instancetype)init {
    ASTableNode *tableNode = [ASTableNode new];

    if (self = [super initWithNode:tableNode]) {
        tableNode.dataSource = self;
        tableNode.delegate = self;
        tableNode.view.allowsSelection = NO;
        tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return self;
}

- (void)loadView {
    [super loadView];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _photoFeed = [[MSPhotoFeed alloc] initWithFrameSize:(CGSize){screenSize.width, screenSize.width * MS_HOME_PHOTO_RATIO}];

    // load datasource
    [self _refreshPhotos];
}

#pragma mark - Properties

- (ASTableNode *)tableNode {
    return (ASTableNode *)self.node;
}

#pragma mark - ASTableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _photoFeed.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 == _photoFeed.count ? 0 : 1;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSPhoto *photo = [_photoFeed photoAtIndex:indexPath.section];

    return ^ASCellNode *() {
        return [[MSPhotoFeedCellNode alloc] initWithPhoto:photo];
    };
}

#pragma mark - ASTableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = (CGRect){CGPointZero, tableView.frame.size.width, 52.f};
    MSPhoto *photo = [_photoFeed photoAtIndex:section];
    MSPhotoFeedHeaderNode *headerNode = [[MSPhotoFeedHeaderNode alloc] initWithFrame:frame photo:photo];

    return headerNode.view;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [context beginBatchFetching];
    [self _loadPhotosWithContext:context];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Private

- (void)_refreshPhotos {
    @weakify(self)
    [_photoFeed refreshPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
        @strongify(self)
        [self _insertRows:photos];
    } pageSize:5];
}

- (void)_loadPhotosWithContext:(ASBatchContext *)context {
    @weakify(self)
    [_photoFeed fetchPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
        @strongify(self)
        [self _insertRows:photos];

        // complete batch fetching
        if (context) [context completeBatchFetching:YES];
    } pageSize:30];
}

- (void)_insertRows:(NSArray<MSPhoto *> *)photos {
    [self.tableNode.view beginUpdates];

    for (NSUInteger section = _photoFeed.count - photos.count; section < _photoFeed.count; section++) {
        [self.tableNode.view insertSections:[NSIndexSet indexSetWithIndex:section]
                           withRowAnimation:UITableViewRowAnimationNone];
    }

    [self.tableNode.view endUpdates];
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end

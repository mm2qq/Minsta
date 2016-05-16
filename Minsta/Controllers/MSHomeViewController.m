//
//  MSHomeViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSPhotoFeedCellNode.h"
#import "MSPhotoFeedHeaderNode.h"
#import "MSPhotoFeed.h"
#import "MinstaMacro.h"

@interface MSHomeViewController () <ASTableDataSource, ASTableDelegate>

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) MSPhotoFeed *feed;

@end

@implementation MSHomeViewController

#pragma mark - Lifecycle

- (instancetype)init {
    ASTableNode *tableNode = [ASTableNode new];

    if (self = [super initWithNode:tableNode]) {
        tableNode.dataSource = self;
        tableNode.delegate = self;
        tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return self;
}

- (void)loadView {
    [super loadView];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _feed = [[MSPhotoFeed alloc] initWithFrameSize:(CGSize){screenSize.width, screenSize.width * MS_HOME_PHOTO_RATIO}];

    // load datasource
    [self _refreshPhotos];
}

#pragma mark - Properties

- (ASTableNode *)tableNode {
    return (ASTableNode *)self.node;
}

#pragma mark - ASTableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _feed.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 == _feed.count ? 0 : 1;
}

- (ASCellNodeBlock)tableView:(ASTableView *)tableView nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSPhoto *photo = [_feed photoAtIndex:indexPath.section];

    return ^ASCellNode *() {
        MSPhotoFeedCellNode *cellNode = [[MSPhotoFeedCellNode alloc] initWithPhoto:photo];
        return cellNode;
    };
}

#pragma mark - ASTableDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MSPhoto *photo = [_feed photoAtIndex:section];
    MSPhotoFeedHeaderNode *headerNode = [[MSPhotoFeedHeaderNode alloc] initWithPhoto:photo];
    return headerNode.view;
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [context beginBatchFetching];
    [self _loadPhotosWithContext:context];
}

#pragma mark - Private

- (void)_refreshPhotos {
    @weakify(self)
    [_feed refreshPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
        @strongify(self)
        [self _insertRows:photos];
        [self _loadPhotosWithContext:nil];
    } pageSize:5];
}

- (void)_loadPhotosWithContext:(ASBatchContext *)context {
    @weakify(self)
    [_feed fetchPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
        @strongify(self)
        [self _insertRows:photos];

        // complete batch fetching
        if (context) [context completeBatchFetching:YES];
    } pageSize:20];
}

- (void)_insertRows:(NSArray<MSPhoto *> *)photos {
    [self.tableNode.view beginUpdates];

    for (NSUInteger section = _feed.count - photos.count; section < _feed.count; section++) {
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

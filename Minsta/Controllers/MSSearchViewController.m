//
//  MSSearchViewController.m
//  Minsta
//
//  Created by maocl023 on 16/5/12.
//  Copyright © 2016年 jjj2mdd. All rights reserved.
//

#import "MSSearchViewController.h"
#import "MSPhotoFreshCellNode.h"
#import "MSPhotoFeed.h"
#import "MinstaMacro.h"

static const CGFloat kItemMargin = 2.5f;
static const CGFloat kItemSizeWidth = 105.f;

@interface MSSearchViewController () <ASCollectionDataSource, ASCollectionDelegate>

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) MSPhotoFeed *photoFeed;

@end

@implementation MSSearchViewController

#pragma mark - Lifecycle

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = kItemMargin;
    flowLayout.minimumInteritemSpacing = kItemMargin;
    ASCollectionNode *collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];

    if (self = [super initWithNode:collectionNode]) {
        collectionNode.dataSource = self;
        collectionNode.delegate = self;
    }

    return self;
}

- (void)loadView {
    [super loadView];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSArray *imageSizes = @[@(MSImageSizeIdForStandardSize((CGSize){screenSize.width, screenSize.width * MS_UNCROPPED_PHOTO_RATIO})), @(MSImageSizeIdForStandardSize((CGSize){kItemSizeWidth, kItemSizeWidth}))];
    _photoFeed = [[MSPhotoFeed alloc] initWithImageSizes:imageSizes];

    // load datasource
    [self _refreshPhotos];
}

#pragma mark - Properties

- (ASCollectionNode *)collectionNode {
    return (ASCollectionNode *)self.node;
}

#pragma mark - ASCollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoFeed.count;
}

- (ASCellNodeBlock)collectionView:(ASCollectionView *)collectionView nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSPhoto *photo = [_photoFeed photoAtIndex:indexPath.item];
    BOOL shouldCropped = indexPath.item != 0;// first item do not crop

    return ^ASCellNode *() {
        return [[MSPhotoFreshCellNode alloc] initWithPhoto:photo shouldCropped:shouldCropped];
    };
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize itemSize = indexPath.item == 0 ? (CGSize){screenSize.width, screenSize.width * MS_UNCROPPED_PHOTO_RATIO} : (CGSize){kItemSizeWidth, kItemSizeWidth};
    return ASSizeRangeMake(itemSize, itemSize);
}

#pragma mark - ASCollectionDelegate

- (void)collectionView:(ASCollectionView *)collectionView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [context beginBatchFetching];
    [self _loadPhotosWithContext:context];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Private

- (void)_refreshPhotos {
    @weakify(self)
    [_photoFeed refreshFreshPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
        @strongify(self)
        [self _insertItems:photos];
    } pageSize:20];
}

- (void)_loadPhotosWithContext:(ASBatchContext *)context {
    @weakify(self)
    [_photoFeed fetchFreshPhotosOnCompletion:^(NSArray<MSPhoto *> * _Nonnull photos) {
        @strongify(self)
        [self _insertItems:photos];

        // complete batch fetching
        if (context) [context completeBatchFetching:YES];
    } pageSize:30];
}

- (void)_insertItems:(NSArray<MSPhoto *> *)photos {
    if (photos.count == 0) return;

    NSMutableArray *indexPaths = [NSMutableArray array];

    for (NSUInteger item = _photoFeed.count - photos.count; item < _photoFeed.count; item++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:item inSection:0]];
    }

    [self.collectionNode.view insertItemsAtIndexPaths:indexPaths];
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
